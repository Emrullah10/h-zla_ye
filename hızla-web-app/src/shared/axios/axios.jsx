import axios from 'axios'
import { API_BASE_URL } from '@shared/constant/api-constant'

const instance = axios.create({
  baseURL: API_BASE_URL,
  withCredentials: true,
})

function getXsrfToken() {
  const match = document.cookie.match(/(?:^|;\s*)XSRF-TOKEN=([^;]*)/)
  return match ? decodeURIComponent(match[1]) : null
}

instance.interceptors.request.use((config) => {
  const method = config.method?.toUpperCase()
  if (method && !['GET', 'HEAD', 'OPTIONS'].includes(method)) {
    const xsrf = getXsrfToken()
    if (xsrf) config.headers['X-XSRF-TOKEN'] = xsrf
  }
  return config
})

let isRefreshing = false
let pendingQueue = []

function drainQueue(error) {
  pendingQueue.forEach((cb) => cb(error))
  pendingQueue = []
}

instance.interceptors.response.use(
  (res) => res,
  async (error) => {
    const original = error.config
    if (error.response?.status !== 401 || original._retry) {
      return Promise.reject(error)
    }
    // Login/refresh/me endpoint'lerine retry yapma
    if (
      original.url?.includes('/gateway/refresh') ||
      original.url?.includes('/auth/login') ||
      original.url?.includes('/gateway/me')
    ) {
      return Promise.reject(error)
    }
    if (isRefreshing) {
      return new Promise((_, reject) => pendingQueue.push(reject))
    }
    original._retry = true
    isRefreshing = true
    try {
      await axios.post(`${API_BASE_URL}/gateway/refresh`, {}, { withCredentials: true })
      drainQueue(null)
      return instance(original)
    } catch (refreshError) {
      drainQueue(refreshError)
      return Promise.reject(refreshError)
    } finally {
      isRefreshing = false
    }
  },
)

export default instance
