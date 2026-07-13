import axios from '@shared/axios/axios'

export const getActiveOrder      = () => axios.get('/courier/order/active')
export const createOrder         = (data) => axios.post('/courier/order', data)
export const sendLocation        = (lat, lng) => axios.post('/courier/location', { lat, lng })
export const getLatestLocations  = () => axios.get('/courier/location/latest')
export const acceptOrder         = (id) => axios.post(`/courier/order/${id}/accept`)
export const rejectOrder         = (id) => axios.post(`/courier/order/${id}/reject`)
export const verifyPackage       = (id, qrCode) => axios.post(`/courier/order/${id}/verify`, { qrCode })
export const rateRestaurant      = (id, data) => axios.post(`/courier/order/${id}/rate`, data)
export const getWallet           = () => axios.get('/courier/wallet')
export const getEarnings         = (params) => axios.get('/courier/earnings', { params })
export const getQuests           = () => axios.get('/courier/quests')
export const createSupportTicket = (data) => axios.post('/courier/support', data)
