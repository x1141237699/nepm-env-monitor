import axios from 'axios'
import { ElMessage } from 'element-plus'

const request = axios.create({
  baseURL: 'http://localhost:8080/api',
  timeout: 10000,
})

function resolveToken(role) {
  if (role === 'grid') return localStorage.getItem('gridToken')
  if (role === 'supervisor') return localStorage.getItem('supervisorToken')
  return localStorage.getItem('adminToken')
}

request.interceptors.request.use((config) => {
  const role = config.meta?.authRole || 'admin'
  const token = resolveToken(role)
  if (token) {
    if (role === 'grid') config.headers.gridToken = token
    else if (role === 'supervisor') config.headers.supervisorToken = token
    else config.headers.adminToken = token
  }
  return config
})

request.interceptors.response.use(
  (response) => {
    const res = response.data
    if (res.code !== 200) {
      ElMessage.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    return res.data
  },
  (error) => {
    ElMessage.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

export default request
