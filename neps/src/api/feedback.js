import request from './request'

export function submitFeedback(data) {
  return request.post('/supervisor/feedback', data)
}

export function getFeedbackList(supervisorId) {
  return request.get('/supervisor/feedback/list', { params: { supervisorId } })
}
