import request from '@/utils/request'

// 生成文档摘要 - 文件上传方式
export function genSummaryByFile(data) {
  const formData = new FormData()
  
  // 只添加有效的参数
  if (data.file) {
    formData.append('file', data.file)
  }
  if (data.url) {
    formData.append('url', data.url)
  }

  return request({
    url: '/ai/summarizer/genSummary',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    responseType: 'text'
  })
}

