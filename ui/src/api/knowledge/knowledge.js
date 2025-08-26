import request from '@/utils/request'

// 查询知识库列表
export function listKnowledge(queryVo) {
  return request({
    url: '/ruoyi/knowledge/list',
    method: 'get',
    params: queryVo
  })
}


// 新增知识库
export function addKnowledge(data) {
  return request({
    url: '/ruoyi/knowledge',
    method: 'post',
    data: data
  })
}

// 修改知识库
export function updateKnowledge(data) {
  return request({
    url: '/ruoyi/knowledge',
    method: 'put',
    data: data
  })
}

// 删除知识库
export function delKnowledge(knowledgeData) {
  return request({
    url: '/ruoyi/knowledge/' + knowledgeData.knowledgeId,
    method: 'delete'
  })
}

// 获取知识库详细信息
export function getKnowledge(knowledgeId) {
  return request({
    url: '/ruoyi/knowledge/' + knowledgeId,
    method: 'get'
  })
}

//根据知识库ID查询文件列表
export function getFileListByKnowledgeId(knowledgeId) {
  return request({
    url: '/chat/file/getFileListByKnowledgeId',
    method: 'get',
    params: {
      knowledgeId: knowledgeId
    }
  })
}

//文件上传
export function upload(data) {
  return request({
    url: '/chat/file/upload',
    method: 'post',
    params: {
      knowledgeId: data.knowledgeId,
      file: data.file
    }
  })
}


//根据文件ID查询文件分片列表
export function getFileChunkListByKnowledgeId(fileId) {
  return request({
    url: '/ruoyi/segment/list',
    method: 'get',
    params: {
      fileId: fileId
    }
  })
}
