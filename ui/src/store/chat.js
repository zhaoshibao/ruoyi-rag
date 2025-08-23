import { defineStore } from 'pinia';
import { sendMessage, sendMessageV2, createChat, listMessages, listChats, saveMessage } from '@/api/chat/chat';
import Prism from 'prismjs';
import { v4 as uuidv4 } from 'uuid';

export const useChatStore = defineStore('chat', {
  state: () => ({
    messages: [],
    projectId: '',
    chatId: 5,
    chatList: [],
    isSending: false,
    uuid: '',
    useSSE: false, // 默认普通模式
    currentEventSource: null,
    currentAbortController: null, // 新增：当前请求的AbortController
  }),
  actions: {
    uuidToNumber(uuid) {
      let number = 0;
      for (let i = 0; i < uuid.length && i < 6; i++) {
        const hexValue = uuid[i];
        let digit = 0;
        if (/[0-9a-fA-F]/.test(hexValue)) {
          digit = parseInt(hexValue, 16);
        }
        number = number * 16 + digit;
      }
      return number % 1000000; // 取模得到 6 位数字
    },
    // 初始化时检查UUID是否存在，如果没有则生成新的UUID
    initUUID() {
      let storedUUID = localStorage.getItem('user_uuid');
      if (!storedUUID) {
        // 生成新的UUID并转换为数字
        const newUUID = uuidv4();
        const numericUUID = this.uuidToNumber(newUUID);
        localStorage.setItem('user_uuid', numericUUID.toString());
        this.uuid = numericUUID;
      } else {
        // 从localStorage读取已存在的数字UUID
        this.uuid = parseInt(storedUUID, 10);
      }
    },

    // 获取会话列表
    async fetchChatList(projectId) {
      try {
        const response = await listChats(projectId);
        console.log('获取会话列表:', response.data);
        
        // 处理大数值ID，将其转换为字符串
        this.chatList = response.data.map(item => {
          if (item.chatId) {
            item.chatId = item.chatId.toString(); // 将 BigInt ID 转换为字符串
          }
          return item;
        });
        
      } catch (error) {
        console.error('获取会话列表失败:', error);
      }
    },

    // 选择会话，切换当前会话
    async selectChat(chatId) {
      this.chatId = chatId;
      console.log('选择会话:', chatId);
      await this.fetchMessages(chatId); // 加载选中会话的消息
    },


    // 添加消息
    addMessage(message) {
      this.messages.push(message);
    },

    
    // 修改：发送消息到ChatGPT
    async sendMessageToChatGPT(userMessage) {
      // 添加用户消息
      this.addMessage({ sender: 'user', text: userMessage.msg });
      
      this.isSending = true;
      
      console.log('=== 发送消息调试信息 ===');
      console.log('用户消息:', userMessage);
      console.log('用户ID:', this.uuid);
      
      try {
        console.log('使用传统模式发送消息');
        await this.sendMessageTraditional(userMessage);
      } catch (error) {
        console.error('发送消息时出错:', error);
        this.handleSendError(error);
      }
    },
    
    
    
    // 修改：停止当前请求
    // 修改：停止当前请求
    stopCurrentSSE() {
      console.log('🛑 停止当前请求...');
      
      // 停止HTTP请求
      if (this.currentAbortController) {
        console.log('取消HTTP请求');
        this.currentAbortController.abort();
        this.currentAbortController = null;
      }
      
      // 停止SSE连接（由Chat组件管理）
      if (this.currentEventSource) {
        console.log('关闭SSE连接');
        this.currentEventSource.close();
        this.currentEventSource = null;
      }
      
      // 确保状态重置
      this.isSending = false;
      
      // 更新最后一条消息状态
      if (this.messages.length > 0) {
        const lastMessage = this.messages[this.messages.length - 1];
        if (lastMessage.sender === 'chatgpt' && (lastMessage.isStreaming || lastMessage.isThinking || lastMessage.isTyping)) {
          lastMessage.isStreaming = false;
          lastMessage.isTyping = false;
          lastMessage.isThinking = false;
          if (!lastMessage.text || lastMessage.text.trim() === '') {
            lastMessage.text = '[用户停止了生成]';
          } else {
            lastMessage.text += '\n\n[用户停止了生成]';
          }
          this.messages = [...this.messages];
        }
      }
    },
    
    /**
     * 使用传统（非SSE）模式发送消息到ChatGPT
     * 特点：
     * 1. 支持请求取消功能
     * 2. 实现打字机效果的消息显示
     * 3. 自动处理代码块的格式化和高亮
     * 4. 包含错误处理机制
     * 
     * @param {Object} userMessage - 用户消息对象
     * @param {string} userMessage.msg - 用户发送的消息内容
     * @param {number} userMessage.language - 消息的语言类型
     * @returns {Promise<string>} 返回ChatGPT的完整响应消息
     */
    async sendMessageTraditional(userMessage) {
      console.log('使用流式模式发送消息:', userMessage);
      this.currentAbortController = new AbortController();
      
      try {
        // 生成唯一的消息ID
        const messageId = Date.now();
        const thinkingMessage = { 
          sender: 'chatgpt', 
          text: "努力思考中，请稍后...", 
          isThinking: true,
          id: messageId
        };
        this.addMessage(thinkingMessage);
        
        const messagePayload = {
          projectId: this.projectId,
          language: 0,
          chatId: this.chatId,
          ...userMessage,
        };
        
        const response = await fetch('/api/ai/chat-stream', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(messagePayload),
          signal: this.currentAbortController.signal
        });

        // 获取响应的第一个数据块来检查是否有错误
        const reader = response.body.getReader();
        const {value, done} = await reader.read();
        const text = new TextDecoder().decode(value);
        
        try {
          const data = JSON.parse(text);
          if (data.code === 500) {
            // 创建错误提示消息
            const errorMessage = {
              sender: 'chatgpt',
              text: `抱歉，出现了一些问题：\n${data.msg || '服务器内部错误'}`,
              isError: true,
              id: messageId
            };

            // 查找并替换思考中的消息
            const thinkingIndex = this.messages.findIndex(msg => msg.id === messageId);
            if (thinkingIndex !== -1) {
              this.messages.splice(thinkingIndex, 1, errorMessage);
              this.messages = [...this.messages];
            } else {
              this.addMessage(errorMessage);
            }

            // 重置发送状态
            this.isSending = false;
            throw new Error(data.msg || '服务器内部错误');
          }
        } catch (e) {
          // 如果解析JSON失败，说明是正常的流式响应
          console.log('Not JSON response, continuing with stream');
        }
        
        // 创建新的回复消息，使用相同的ID
        const chatGptReply = { 
          sender: 'chatgpt', 
          text: text, // 使用已经读取的第一块数据
          isTyping: true,
          isStreaming: true,
          id: messageId
        };
        
        // 使用ID查找并替换思考中的消息
        const thinkingIndex = this.messages.findIndex(msg => msg.id === messageId);
        if (thinkingIndex !== -1) {
          this.messages.splice(thinkingIndex, 1, chatGptReply);
          // 确保Vue更新视图
          this.messages = [...this.messages];
        } else {
          this.addMessage(chatGptReply);
        }

        const decoder = new TextDecoder();
        let buffer = '';
        let fullMessage = '';
        let currentCodeBlock = {
          isInBlock: false,
          language: '',
          content: ''
        };
        
        try {
          while (true) {
            const { done, value } = await reader.read();
            if (done) {
              // 处理缓冲区中剩余的数据
              if (buffer) {
                const lines = buffer.split('\n');
                for (const line of lines) {
                  if (line.trim() && line.startsWith('data: ')) {
                    await this.processStreamData(line.slice(6), chatGptReply, currentCodeBlock);
                  }
                }
              }
              break;
            }
            
            // 如果请求已被取消，停止处理
            if (this.currentAbortController?.signal.aborted) {
              console.log('请求已被取消');
              return;
            }

            const chunk = decoder.decode(value, { stream: true });
           
            buffer += chunk;
            console.log('buffer===============', buffer);
            // 尝试处理buffer中的数据
            try {
              const content = await this.processStreamData(buffer, chatGptReply, currentCodeBlock);
              console.log('content===============', content);
              if (content) {
                fullMessage += content;
                // 清空已处理的buffer
                buffer = '';
              }
            } catch (e) {
              console.log('处理数据出错，继续累积buffer:', e);
            }
            
          }
        } catch (error) {
          console.error('处理流数据时出错:', error);
          throw error;
        } finally {
          // 确保读取器被正确关闭
          reader.releaseLock();
        }
        
        // 保存完整消息到后端
        try {
          await saveMessage({
            "chatId": this.chatId,
            "content": fullMessage
          }, this.currentAbortController);
        } catch (error) {
          console.error('保存消息失败:', error);
        }
        
        // 收尾逻辑：重置状态标志
        chatGptReply.isThinking = false;
        chatGptReply.isTyping = false;
        chatGptReply.isStreaming = false;
        this.isSending = false;
        this.currentAbortController = null;
        this.messages = [...this.messages];
        
        return fullMessage;
        
      } catch (error) {
        if (error.name === 'AbortError' || error.code === 'ERR_CANCELED') {
          console.log('请求被用户取消');
          this.isSending = false;
          this.currentAbortController = null;
          return;
        }
        
        console.error('发送消息失败:', error);
        this.handleSendError(error);
        throw error;
      }
    },

    // 处理流式数据
    async processStreamData(data, chatGptReply, currentCodeBlock) {
      try {
        // 尝试直接解析数据
        let content;
        try {
          const parsed = JSON.parse(data);
          if (!parsed.choices || !parsed.choices[0].delta.content) {
            return '';
          }
          content = parsed.choices[0].delta.content;
        } catch (e) {
          // 如果解析失败，可能是数据不完整，直接使用原始数据
          content = data;
        }
        
        // 其他代码保持不变...
        chatGptReply.text += content;
        this.messages = [...this.messages];
        
        return content;
      } catch (e) {
        console.error('处理数据出错:', e);
        return '';
      }
    },



    // 创建新会话
    async createNewChat() {
      try {
        const response = await createChat({
          userId:this.uuid,
          projectId: this.projectId,
          title: '新会话' + Math.random().toString(36).substring(2, 7),
        });
        this.messages = [];
        this.chatId = response;
        console.log('创建新会话:', this.chatId);
        //this.chatId = BigInt(response.data).toString()
        
        
        await this.fetchChatList(this.projectId); // 创建新会话后更新会话列表
      } catch (error) {
        console.error('创建新聊天失败:', error);
      }
    },

    // 获取指定会话的消息
    async fetchMessages(chatId) {
      try {
        const response = await listMessages(chatId);
        this.messages = response.data.map(msg => ({
          ...msg,
          //text: this.formatMessage(msg.content),
          text: msg.content,
          sender: msg.type ===0?'user':'chatgpt'
        }));
      } catch (error) {
        console.error('获取消息失败:', error);
      }
    },
  },
});
