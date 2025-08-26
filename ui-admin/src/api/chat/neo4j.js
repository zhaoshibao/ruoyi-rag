import request from '@/utils/request'

// 获取知识图谱数据
export function getGraphData(projectId) {
  return request({
    url: '/neo4j/graph/' + projectId,
    method: 'get'
  })
}

// 搜索知识图谱
export function searchGraph(query) {
  return request({
    url: '/neo4j/search',
    method: 'get',
    params: query
  })
}

// 上传CSV文件
export function uploadCsv(data) {
  return request({
    url: '/neo4j/upload',
    method: 'post',
    data: data
  })
}