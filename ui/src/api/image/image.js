import request from '@/utils/request'

// 文本生成图片
export function text2Image(prompt, style = '', resolution = '1080*1080') {
  return request({
    url: '/ai/image/text2image',
    method: 'get',
    params: {
      prompt,
      style,
      resolution
    },
    responseType: 'blob'
  })
}