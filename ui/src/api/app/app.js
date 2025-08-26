import request from '@/utils/request'

// 查询应用列表
export function listApp(query) {
  return request({
    url: '/chat/app/list',
    method: 'get',
    params: query
  })
}



// 查询应用详细
export function getApp(appId) {
  return request({
    url: '/chat/app/' + appId,
    method: 'get'
  })
}

// 新增应用
export function addApp(data) {
  return request({
    url: '/chat/app',
    method: 'post',
    data: data
  })
}

// 修改应用
export function updateApp(data) {
  return request({
    url: '/chat/app/edit',
    method: 'post',
    data: data
  })
}

// 删除应用
export function delApp(appIds) {
  return request({
    url: '/chat/app/' + appIds,
    method: 'delete'
  })
}

// 导出应用
export function exportApp(query) {
  return request({
    url: '/chat/app/export',
    method: 'get',
    params: query
  })
}

export function listAcknowledges(query) {
  return request({
    url: '/chat/knowledge',
    method: 'get',
    params: query
  })
}

export function removeFile(removeFileData) {    
  return request({
    url: '/chat/knowledge/remove',
    method: 'delete',
    params: removeFileData
  })
}