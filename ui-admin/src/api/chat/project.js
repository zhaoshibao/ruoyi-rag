import request from '@/utils/request'

// 查询项目列表
export function listProject(query) {
  return request({
    url: '/chat/project/list',
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

// 查询项目详细
export function getProject(projectId) {
  return request({
    url: '/chat/project/' + projectId,
    method: 'get'
  })
}

// 新增项目
export function addProject(data) {
  return request({
    url: '/chat/project',
    method: 'post',
    data: data
  })
}

// 修改项目
export function updateProject(data) {
  return request({
    url: '/chat/project/edit',
    method: 'post',
    data: data
  })
}

// 删除项目
export function delProject(projectIds) {
  return request({
    url: '/chat/project/' + projectIds,
    method: 'delete'
  })
}
