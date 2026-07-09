import axios from '@shared/axios/axios'

export const login = (credentials) => axios.post('/auth/login', credentials)
export const logout = () => axios.post('/gateway/logout')
export const getMe = () => axios.get('/gateway/me')
