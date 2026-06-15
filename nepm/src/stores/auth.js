import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { adminLogin } from '../api/admin'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('adminToken') || '')
  const adminInfo = ref(JSON.parse(localStorage.getItem('adminInfo') || 'null'))

  const isLogin = computed(() => !!token.value)

  async function login(adminCode, password) {
    const data = await adminLogin({ adminCode, password })
    token.value = data.token
    adminInfo.value = data.adminInfo
    localStorage.setItem('adminToken', data.token)
    localStorage.setItem('adminInfo', JSON.stringify(data.adminInfo))
    return data
  }

  function logout() {
    token.value = ''
    adminInfo.value = null
    localStorage.removeItem('adminToken')
    localStorage.removeItem('adminInfo')
  }

  return { token, adminInfo, isLogin, login, logout }
})
