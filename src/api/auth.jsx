import axios from '@shared/axios/axios'

export const login = (credentials) => axios.post('/auth/login', credentials)
export const logout = () => axios.post('/auth/logout')
export const refreshToken = (token) => axios.post('/auth/refresh', { refreshToken: token })
