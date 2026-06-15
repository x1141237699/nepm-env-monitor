import request from './request'

export function adminLogin(data) {
  return request.post('/auth/admin/login', data)
}

export function getFeedbackPage(params) {
  return request.get('/feedback', { params })
}

export function getFeedbackDetail(afId) {
  return request.get(`/feedback/${afId}`)
}

export function getLocalGridMembers(afId) {
  return request.get(`/feedback/${afId}/assign/local`)
}

export function getOtherProvinceGridMembers(afId) {
  return request.get(`/feedback/${afId}/assign/other`)
}

export function assignGridMember(afId, data) {
  return request.post(`/feedback/${afId}/assign`, data)
}
