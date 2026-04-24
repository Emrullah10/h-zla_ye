import axios from 'axios'
import { API_BASE_URL, TOKEN_REFRESH_BUFFER } from '@shared/constant/api-constant'
import { useAuthStore } from '@store/authStore'

const instance = axios.create({ baseURL: API_BASE_URL })

instance.interceptors.request.use(async (config) => {
  const { token, tokenExpiry, refreshToken, setToken } = useAuthStore.getState()
  if (!token) return config

  const expiresIn = tokenExpiry - Date.now() / 1000
  if (expiresIn < TOKEN_REFRESH_BUFFER) {
    const res = await axios.post(`${API_BASE_URL}/auth/refresh`, { refreshToken })
    setToken(res.data.token, res.data.expiresIn)
    config.headers.Authorization = `Bearer ${res.data.token}`
  } else {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export default instance
