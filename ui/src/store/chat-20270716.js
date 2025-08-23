import { defineStore } from 'pinia';
import { sendMessage, sendMessageV2, createChat, listMessages, listChats, saveMessage } from '@/api/chat/chat';
import Prism from 'prismjs';
import { v4 as uuidv4 } from 'uuid';

export const useChatStore = defineStore('chat', {
  state: () => ({
    messages: [],
    projectId: '118abc',
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
    async fetchChatList() {
      try {
        const response = await listChats(this.projectId,this.uuid);
        console.log(response.data);
        
        this.chatList = response.data.map(item => {
          item.chatId = BigInt(item.chatId).toString()
          return item;
        }); // 假设 API 返回会话列表
        
      } catch (error) {
        console.error('获取会话列表失败:', error);
      }
    },

    // 选择会话，切换当前会话
    async selectChat(chatId) {
      this.chatId = chatId;
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
      console.log('使用传统模式发送消息:', userMessage);
      // 创建新的AbortController用于支持取消请求
      this.currentAbortController = new AbortController();
      
      try {
        // 添加一个临时的"思考中"消息，提供更好的用户体验
        const thinkingMessage = { sender: 'chatgpt', text: "努力思考中，请稍后", isThinking: true };
        this.addMessage(thinkingMessage);
        
        // 构建发送给后端的消息载荷
        const messagePayload = {
          projectId: this.projectId,
          language: 0,
          ...userMessage,
        };
        
        // 发送请求并等待响应
        const response = await sendMessage(messagePayload, this.currentAbortController);
        
        // 如果请求已被取消，直接返回
        if (this.currentAbortController?.signal.aborted) {
          console.log('请求已被取消');
          return;
        }
        
        // 移除临时的"思考中"消息
        this.messages.splice(this.messages.length - 1, 1);
        
        // 获取ChatGPT的响应消息
        const chatGptMessage = response.data;

        console.log('=== ChatGPT回复 ===', chatGptMessage);
        const chatGptReply = { sender: 'chatgpt', text: '', isTyping: true, isThinking: true };
        this.addMessage(chatGptReply);
        
        // 保存消息到后端
        try {
          await saveMessage({
            "chatId": this.chatId,
            "content": chatGptMessage
          }, this.currentAbortController);
        } catch (error) {
          console.error('保存消息失败:', error);
        }
        
        // 如果请求已被取消，不继续处理
        if (this.currentAbortController?.signal.aborted) {
          console.log('保存消息请求已被取消');
          return;
        }
        
        // 处理消息中的代码块，使用正则表达式匹配 ```language\n code ``` 格式的代码块
        const codeRegex = /```(\w+)?\n([\s\S]*?)```/g;
        let lastIndex = 0;  // 记录上一次匹配结束的位置
        let match;
        
        // 循环查找所有代码块
        while ((match = codeRegex.exec(chatGptMessage)) !== null) {
          // 如果请求已被取消，不继续处理
          if (this.currentAbortController?.signal.aborted) {
            console.log('显示过程已被取消');
            return;
          }
          
          // 解构匹配结果：
          // fullMatch: 完整的匹配文本
          // language: 代码语言（可能为undefined）
          // codeContent: 代码内容
          const [fullMatch, language, codeContent] = match;

          // 获取当前代码块之前的普通文本
          const nonCodeText = chatGptMessage.slice(lastIndex, match.index);
          if (nonCodeText) {
            // 如果存在普通文本，使用打字机效果显示
            await this.outputMessagePart(nonCodeText, chatGptReply);
          }
          
          // 添加代码块的HTML标记，设置语言类型（如果未指定则使用plaintext）
          chatGptReply.text += `<pre><code class="language-${language || 'plaintext'}">`;
          this.messages = [...this.messages];  // 触发Vue的响应式更新
          
          // 使用打字机效果显示代码内容
          await this.outputMessagePart(codeContent, chatGptReply);
          
          // 添加代码块的闭合标签
          chatGptReply.text += `</code></pre>`;
          this.messages = [...this.messages];  // 触发Vue的响应式更新
          
          // 更新lastIndex为当前匹配结束的位置，为下一次匹配做准备
          lastIndex = codeRegex.lastIndex;
        }
        
        if (lastIndex < chatGptMessage.length) {
          const remainingText = chatGptMessage.slice(lastIndex);
          await this.outputMessagePart(remainingText, chatGptReply);
        }
        
        // 如果请求已被取消，不继续处理
        if (this.currentAbortController?.signal.aborted) {
          console.log('最终处理已被取消');
          return;
        }
        
        // 使用setTimeout确保在下一个事件循环中应用代码高亮
        // 这样可以确保DOM已经更新完成
        setTimeout(() => {
          Prism.highlightAll();
        }, 0);
        
        // 收尾逻辑：重置状态标志、清除请求控制器和更新消息列表
        chatGptReply.isThinking = false;  // 结束思考状态
        chatGptReply.isTyping = false;    // 结束打字状态
        this.isSending = false;           // 结束发送状态
        this.currentAbortController = null;  // 清除请求控制器
        this.messages = [...this.messages];  // 触发消息列表的响应式更新
        
        // 返回完整的ChatGPT响应消息
        return chatGptMessage;
        
      } catch (error) {
        // 处理取消错误
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
    
    
    // 新增：处理发送错误
    handleSendError(error) {
      console.log('🚨 处理发送错误:', error);
      
      const errorMessage = '抱歉，我现在无法响应。请检查网络连接后重试。';
      
      // 移除可能存在的思考中消息
      if (this.messages.length > 0) {
        const lastMessage = this.messages[this.messages.length - 1];
        if (lastMessage.sender === 'chatgpt' && (lastMessage.isThinking || lastMessage.isStreaming || lastMessage.isTyping)) {
          lastMessage.text = errorMessage;
          lastMessage.isTyping = false;
          lastMessage.isStreaming = false;
          lastMessage.isThinking = false;
          this.messages = [...this.messages];
        } else {
          this.addMessage({ sender: 'chatgpt', text: errorMessage, isTyping: false });
        }
      } else {
        this.addMessage({ sender: 'chatgpt', text: errorMessage, isTyping: false });
      }
      
      // 确保状态重置
      this.isSending = false;
      this.currentEventSource = null;
      this.currentAbortController = null;
    },
    
    /**
     * 使用打字机效果显示消息的一部分
     * @param {string} part - 要显示的消息部分
     * @param {Object} chatGptReply - ChatGPT回复消息对象
     */
    async outputMessagePart(part, chatGptReply) {
      // 初始化缓冲区，用于逐字构建显示的文本
      let buffer = '';

      // 遍历消息文本的每个字符
      for (const char of part) {
        // 将当前字符添加到缓冲区
        buffer += char;

        // 显示带有光标效果的文本（使用下划线模拟光标）
        chatGptReply.text = buffer + '_';
        // 触发Vue的响应式更新，确保UI立即显示新文本
        this.messages = [...this.messages];

        // 等待50毫秒，创造打字机的节奏感
        await new Promise(resolve => setTimeout(resolve, 50));

        // 移除光标，显示纯文本
        chatGptReply.text = buffer;
        // 再次触发响应式更新，更新UI显示
        this.messages = [...this.messages];
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
        this.chatId = response.data;
        this.chatId = BigInt(response.data).toString()
        console.log(this.chatId);
        
        
        await this.fetchChatList(); // 创建新会话后更新会话列表
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
