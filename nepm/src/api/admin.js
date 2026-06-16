import request from './request'

export function adminLogin(data) {
  return request.post('/auth/admin/login', data)
}

export function getFeedbackPage(params) {
  return request.get('/feedback', { params, meta: { authRole: 'admin' } })
}

export function getFeedbackDetail(afId) {
  return request.get(`/feedback/${afId}`, { meta: { authRole: 'admin' } })
}

export function getLocalGridMembers(afId) {
  return request.get(`/feedback/${afId}/assign/local`, { meta: { authRole: 'admin' } })
}

export function getOtherProvinceGridMembers(afId) {
  return request.get(`/feedback/${afId}/assign/other`, { meta: { authRole: 'admin' } })
}

export function assignGridMember(afId, data) {
  return request.post(`/feedback/${afId}/assign`, data, { meta: { authRole: 'admin' } })
}
