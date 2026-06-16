import request from './request'

export function supervisorLogin(data) {
  return request.post('/auth/supervisor/login', data)
}

export function supervisorRegister(data) {
  return request.post('/auth/supervisor/register', data)
}

export function submitFeedback(data) {
  return request.post('/supervisor/feedback', data)
}
