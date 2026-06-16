import request from './request'

export function gridLogin(data) {
  return request.post('/auth/grid/login', data)
}

export function getTaskList(gridMemberId) {
  return request.get('/grid/tasks', {
    params: { gridMemberId },
    meta: { authRole: 'grid' },
  })
}

export function getTaskDetail(afId, gridMemberId) {
  return request.get(`/grid/tasks/${afId}`, {
    params: { gridMemberId },
    meta: { authRole: 'grid' },
  })
}

export function submitTaskData(data) {
  return request.post('/grid/tasks/submit', data, { meta: { authRole: 'grid' } })
}
