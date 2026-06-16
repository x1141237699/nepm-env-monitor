import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { supervisorLogin, supervisorRegister } from '../api/supervisor'

export const useSupervisorAuthStore = defineStore('supervisorAuth', () => {
  const token = ref(localStorage.getItem('supervisorToken') || '')
  const supervisorInfo = ref(JSON.parse(localStorage.getItem('supervisorInfo') || 'null'))

  const isLogin = computed(() => !!token.value)

  async function login(supervisorCode, password) {
    const data = await supervisorLogin({ supervisorCode, password })
    token.value = data.token
    supervisorInfo.value = data.supervisorInfo
    localStorage.setItem('supervisorToken', data.token)
    localStorage.setItem('supervisorInfo', JSON.stringify(data.supervisorInfo))
    return data
  }

  async function register(form) {
    return supervisorRegister(form)
  }

  function logout() {
    token.value = ''
    supervisorInfo.value = null
    localStorage.removeItem('supervisorToken')
    localStorage.removeItem('supervisorInfo')
  }

  return { token, supervisorInfo, isLogin, login, register, logout }
})
