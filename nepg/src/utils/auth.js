const GRID_TOKEN_KEY = 'gridToken'
const GRID_INFO_KEY = 'gridInfo'

export function getGridToken() {
  return localStorage.getItem(GRID_TOKEN_KEY) || ''
}

export function getGridInfo() {
  const raw = localStorage.getItem(GRID_INFO_KEY)
  return raw ? JSON.parse(raw) : null
}

export function isGridLogin() {
  return !!getGridToken()
}

export function saveGridSession(data) {
  localStorage.setItem(GRID_TOKEN_KEY, data.token)
  localStorage.setItem(GRID_INFO_KEY, JSON.stringify(data.gridInfo))
}

export function clearGridSession() {
  localStorage.removeItem(GRID_TOKEN_KEY)
  localStorage.removeItem(GRID_INFO_KEY)
}
