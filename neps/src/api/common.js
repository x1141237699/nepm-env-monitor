import request from './request'

export function getProvinces() {
  return request.get('/common/provinces')
}

export function getCities(provinceId) {
  return request.get('/common/cities', { params: { provinceId } })
}

export function getAqiLevels() {
  return request.get('/common/aqi-levels')
}
