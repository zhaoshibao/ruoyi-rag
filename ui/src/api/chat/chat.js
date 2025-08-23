import axios from 'axios';
import request from '@/utils/request'
//创建 MockAdapter 实例
// const mock = new MockAdapter(axios);

// // 模拟会话列表接口
// mock.onGet('/api/ai/list-chat').reply(200, [
//   {
//     chatId: 1,
//     projectId: 0,
//     userId: 1,
//     title: "聊天记录 1",
//     createTime: "2024-10-06T12:00:00Z",
//     editing: false,
//   },
//   {
//     chatId: 2,
//     projectId: 0,
//     userId: 2,
//     title: "聊天记录 2",
//     createTime: "2024-10-05T12:00:00Z",
//     editing: false,
//   },
//   {
//     chatId: 3,
//     projectId: 0,
//     userId: 3,
//     title: "聊天记录 3",
//     createTime: "2024-10-06T08:00:00Z",
//     editing: false,
//   },
// ]);

// // 模拟发送消息接口
// mock.onPost('/api/ai/chat-stream').reply(200, `
// 当然，下面是一个简单的 Java "Hello World" 程序：

// \`\`\`java
// public class HelloWorld {
//     public static void main(String[] args) {
//         System.out.println("Hello World");
//     }
// }
// \`\`\`

// 将以上代码保存到一个名为 HelloWorld.java 的文件中。然后在命令行或终端中使用以下步骤进行编译和运行:

// 1. 编译：javac HelloWorld.java
// 2. 运行：java HelloWorld
// `);
// // 模拟创建新的会话接口
// mock.onPost('/api/ai/create-chat').reply(200, {
//   chatId: 4,
//   title: "新聊天记录",
//   createTime: "2024-10-07T12:00:00Z",
// });

// // 模拟修改会话标题接口
// mock.onPost('/api/ai/update-chat').reply(200, { success: true });

// // 模拟保存消息接口
// mock.onPost('/api/ai/save-msg').reply(200, { success: true });

// // 模拟查询会话中的消息接口
// mock.onGet('/api/ai/list-msg').reply(200, [
//   { messageId: 1, chatId: 1, text: "Hello", sender: "user" },
//   { messageId: 2, chatId: 1, text: "Hi there!", sender: "chatgpt" },
// ]);

// // 模拟删除会话接口
// mock.onGet('/api/ai/delete-chat').reply(200, { success: true });

// // 模拟模型列表接口
// mock.onGet('/api/chat/project').reply(200, {
//   "total": 4,
//   "rows": [
//       {
//           "createBy": "",
//           "createTime": "2024-06-28 14:35:05",
//           "updateBy": "",
//           "updateTime": null,
//           "remark": null,
//           "projectId": 114,
//           "projectName": "小谷同学",
//           "type": "ollama",
//           "model": "qwen2.5:7b"
//       },
//       {
//           "createBy": "",
//           "createTime": "2024-07-01 10:50:25",
//           "updateBy": "",
//           "updateTime": null,
//           "remark": null,
//           "projectId": 117,
//           "projectName": "谷粒商城",
//           "type": "ollama",
//           "model": "qwen2.5:7b"
//       },
//       {
//           "createBy": "",
//           "createTime": "2024-07-01 10:50:50",
//           "updateBy": "",
//           "updateTime": null,
//           "remark": null,
//           "projectId": 118,
//           "projectName": "谷粒随享",
//           "type": "openai",
//           "model": "gpt-3.5-turbo"
//       },
//       {
//           "createBy": "",
//           "createTime": "2024-07-01 16:27:02",
//           "updateBy": "",
//           "updateTime": null,
//           "remark": null,
//           "projectId": 119,
//           "projectName": "在线教育",
//           "type": "openai",
//           "model": "gpt-3.5-turbo"
//       }
//   ],
//   "code": 200,
//   "msg": "查询成功"
// });


// 发送消息到 ChatGPT
export const sendMessage = (message, abortController = null) => {
  const config = {};
  if (abortController) {
    config.signal = abortController.signal;
  }
  return axios.post('/api/ai/chat-stream', message, config);
};

// 发送消息到 ChatGPT（v2，支持取消）
export const sendMessageV2 = (message, abortController = null) => {
  const config = {};
  if (abortController) {
    config.signal = abortController.signal;
  }
  return axios.post('/api/ai/chat-stream-v2', message, config);
};



// 新增：连接SSE服务
export const connectSSE = (userId) => {
  const url = `http://127.0.0.1:8080/sse/connect?userId=${userId}`;
  console.log('🔗 准备连接SSE，URL:', url);
  
  try {
    const eventSource = new EventSource(url);
    console.log('✅ EventSource对象创建成功');
    return eventSource;
  } catch (error) {
    console.error('❌ 创建EventSource失败:', error);
    throw error;
  }
};

// 新增：发送消息并通过SSE接收回复
export const sendMessageWithSSE = (queryVo, onMessage, onError, onComplete) => {
  return new Promise((resolve, reject) => {
    let eventSource = null;
    
    try {
      console.log('=== 开始SSE连接流程 ===');
      console.log('查询参数:', queryVo);
      
      // 1. 先建立SSE连接
      eventSource = connectSSE(queryVo.userId);
      let fullResponse = '';
      
      // 添加连接状态监控
      console.log('EventSource初始状态:', {
        readyState: eventSource.readyState,
        url: eventSource.url,
        withCredentials: eventSource.withCredentials
      });
      // eventSource.addEventListener('open', function (e) {
      //   console.log("建立连接。。。")
      // }, false)

      
      // 2. 监听SSE连接打开
      eventSource.onopen = (event) => {
        console.log('🎉 SSE连接成功打开!');
        console.log('连接事件详情:', event);
        console.log('当前连接状态:', eventSource.readyState);
        
        // 连接建立后发送消息
        console.log('📤 开始发送消息到后端...');
        sendMessageV2(queryVo)
          .then((response) => {
            console.log('✅ 消息发送成功，响应:', response);
            console.log('等待SSE数据流...');
          })
          .catch((error) => {
            console.error('❌ 发送消息失败:', error);
            if (eventSource && eventSource.readyState !== EventSource.CLOSED) {
              eventSource.close();
            }
            onError && onError('发送消息失败: ' + error.message);
            reject(error);
          });
      };
      
      // 3. 监听 'add' 事件 - 接收消息内容片段
      eventSource.addEventListener('add', (event) => {
        try {
          const content = event.data;
          console.log('📨 收到add事件数据:', content);
          
          // 累积完整响应
          fullResponse += content;
          console.log('当前完整响应长度:', fullResponse.length);
          
          // 调用回调函数更新UI
          onMessage && onMessage(content, fullResponse);
        } catch (error) {
          console.error('❌ 处理add事件失败:', error);
        }
      });
      
      // 4. 监听 'finish' 事件 - 消息发送完成
      eventSource.addEventListener('finish', (event) => {
        console.log('🏁 收到finish事件，消息发送完成');
        console.log('最终响应长度:', fullResponse.length);
        
        if (eventSource && eventSource.readyState !== EventSource.CLOSED) {
          eventSource.close();
        }
        onComplete && onComplete(fullResponse);
        resolve(fullResponse);
      });
      
      // 5. 监听 'error' 事件 - 处理错误
      eventSource.addEventListener('error', (event) => {
        console.error('❌ 收到error事件:', event.data);
        
        if (eventSource && eventSource.readyState !== EventSource.CLOSED) {
          eventSource.close();
        }
        const errorMsg = event.data || 'SSE接收过程中发生错误';
        onError && onError(errorMsg);
        reject(new Error(errorMsg));
      });
      
      // 6. 监听连接错误（网络层面的错误）
      eventSource.onerror = (error) => {
        console.error('🚨 SSE连接发生错误:');
        console.error('错误对象:', error);
        console.error('连接状态:', eventSource.readyState);
        console.error('连接URL:', eventSource.url);
        
        // 根据连接状态判断错误类型
        if (eventSource.readyState === EventSource.CONNECTING) {
          console.warn('⚠️ SSE正在尝试重连...');
          // EventSource会自动重连，这里不需要手动处理
        } else if (eventSource.readyState === EventSource.CLOSED) {
          console.error('💀 SSE连接已关闭');
          onError && onError('SSE连接已关闭');
          reject(new Error('SSE连接已关闭'));
        } else {
          console.error('💥 SSE连接发生未知错误');
          eventSource.close();
          onError && onError('SSE连接失败，请检查网络或后端服务');
          reject(error);
        }
      };
      
      // 7. 设置连接超时检查
      const connectionTimeout = setTimeout(() => {
        if (eventSource && eventSource.readyState === EventSource.CONNECTING) {
          console.warn('⏰ SSE连接超时（15秒）');
          eventSource.close();
          onError && onError('SSE连接超时，请检查网络连接');
          reject(new Error('SSE连接超时'));
        }
      }, 15000); // 15秒超时
      
      // 连接成功后清除超时
      eventSource.onopen = (event) => {
        clearTimeout(connectionTimeout);
        console.log('🎉 SSE连接成功打开!');
        console.log('连接事件详情:', event);
        console.log('当前连接状态:', eventSource.readyState);
        
        // 连接建立后发送消息
        console.log('📤 开始发送消息到后端...');
        sendMessageV2(queryVo)
          .then((response) => {
            console.log('✅ 消息发送成功，响应:', response);
            console.log('等待SSE数据流...');
          })
          .catch((error) => {
            console.error('❌ 发送消息失败:', error);
            if (eventSource && eventSource.readyState !== EventSource.CLOSED) {
              eventSource.close();
            }
            onError && onError('发送消息失败: ' + error.message);
            reject(error);
          });
      };
      
      // 返回eventSource以便外部可以手动关闭
      return eventSource;
      
    } catch (error) {
      console.error('❌ 创建SSE连接时发生异常:', error);
      if (eventSource) {
        eventSource.close();
      }
      reject(error);
    }
  });
};

// 创建新的会话
export const createChat = (chatVo) => {
  return request({
    url: '/ai/create-chat',
    method: 'post',
    data: chatVo
  });
};

// 修改会话标题
export const updateChat = (chatVo) => {
  return request({
    url: '/ai/update-chat',
    method: 'post',
    data: chatVo
  });
};

// 保存消息
// export const saveMessage = (messageVo) => {
//   return axios.post('/api/ai/save-msg', messageVo);
// };

// 保存消息（支持取消）
export const saveMessage = (messageVo, abortController = null) => {
  const config = {};
  if (abortController) {
    config.signal = abortController.signal;
  }
  return request({
    url: '/ai/save-msg',
    method: 'post',
    data: messageVo,
    ...config
  });
};
// 查询会话列表
export const listChats = (projectId) => {
  return request({
     url: '/ai/list-chat',
     method: 'get',
     params: { projectId }
   })
};

// 查询会话中的消息
export const listMessages = (chatId) => {
  return request({
    url: '/ai/list-msg',
    method: 'get',
    params: { chatId }
  });
};

// 删除会话
export const deleteChat = (projectId, chatId) => {
  return request({
    url: '/ai/delete-chat',
    method: 'get',
    params: { projectId, chatId }
  });
};

// 模型列表
export const fetchProjects = async () => {
  return request({
    url: '/chat/project/list',
    method: 'get'
  });
};

// 发送消息到 ChatGPT（SSE流式）
export const sendMessageSSE = (message, onMessage, onError, onComplete) => {
  return new Promise((resolve, reject) => {
    // 构建查询参数
    const params = new URLSearchParams({
      projectId: message.projectId,
      chatId: message.chatId,
      language: message.language,
      msg: message.msg
    });
    
    // 创建EventSource连接
    const eventSource = new EventSource(`/api/ai/chat-stream-sse?${params.toString()}`);
    
    let fullResponse = '';
    
    // 监听消息事件
    eventSource.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        
        if (data.type === 'content') {
          // 接收到内容片段
          fullResponse += data.content;
          onMessage && onMessage(data.content, fullResponse);
        } else if (data.type === 'complete') {
          // 接收完成
          eventSource.close();
          onComplete && onComplete(fullResponse);
          resolve(fullResponse);
        } else if (data.type === 'error') {
          // 接收到错误
          eventSource.close();
          onError && onError(data.error);
          reject(new Error(data.error));
        }
      } catch (error) {
        console.error('解析SSE数据失败:', error);
        onError && onError('数据解析失败');
      }
    };
    
    // 监听错误事件
    eventSource.onerror = (error) => {
      console.error('SSE连接错误:', error);
      eventSource.close();
      onError && onError('连接失败，请重试');
      reject(error);
    };
    
    // 监听连接打开事件
    eventSource.onopen = () => {
      console.log('SSE连接已建立');
    };
    
    // 返回eventSource以便外部可以手动关闭
    return eventSource;
  });
};

// ... existing code ...
