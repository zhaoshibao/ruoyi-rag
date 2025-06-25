import request from '@/utils/request'

// 查询项目列表
export function listProject() {
  return request({
    url: '/chat/project',
    method: 'get'
  })
}

// 查询知识库列表
export function listKnowledge(query) {
  return request({
    url: '/chat/knowledge/list',
    method: 'get',
    params: query
  })
}

// 查询知识库详细
export function getKnowledge(knowledgeId) {
  return request({
    url: '/chat/knowledge/' + knowledgeId,
    method: 'get'
  })
}

// 新增知识库
export function addKnowledge(data) {
  return request({
    url: '/chat/knowledge',
    method: 'post',
    data: data
  })
}

// 删除知识库
export function delKnowledge(data) {
  return request({
    url: '/chat/knowledge',
    method: 'delete',
    data: data
  })
}
