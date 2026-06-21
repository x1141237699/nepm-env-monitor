const TOKEN_KEY = 'supervisorToken'
const INFO_KEY = 'supervisorInfo'

export function saveSupervisorSession(data) {
  localStorage.setItem(TOKEN_KEY, data.token)
  localStorage.setItem(INFO_KEY, JSON.stringify(data.supervisorInfo))
}

export function getSupervisorInfo() {
  const raw = localStorage.getItem(INFO_KEY)
  return raw ? JSON.parse(raw) : null
}

export function isSupervisorLogin() {
  return !!localStorage.getItem(TOKEN_KEY)
}

export function clearSupervisorSession() {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(INFO_KEY)
}
