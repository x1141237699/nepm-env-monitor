import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { gridLogin } from '../api/grid'

export const useGridAuthStore = defineStore('gridAuth', () => {
  const token = ref(localStorage.getItem('gridToken') || '')
  const gridInfo = ref(JSON.parse(localStorage.getItem('gridInfo') || 'null'))

  const isLogin = computed(() => !!token.value)

  async function login(memberCode, password) {
    const data = await gridLogin({ memberCode, password })
    token.value = data.token
    gridInfo.value = data.gridInfo
    localStorage.setItem('gridToken', data.token)
    localStorage.setItem('gridInfo', JSON.stringify(data.gridInfo))
    return data
  }

  function logout() {
    token.value = ''
    gridInfo.value = null
    localStorage.removeItem('gridToken')
    localStorage.removeItem('gridInfo')
  }

  return { token, gridInfo, isLogin, login, logout }
})
