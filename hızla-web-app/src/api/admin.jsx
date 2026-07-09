import axios from '@shared/axios/axios'

export const getAdminDashboard = () => axios.get('/admin/dashboard')
export const getDrivers        = (params) => axios.get('/admin/drivers', { params })
export const approveDriver     = (id) => axios.post(`/admin/drivers/${id}/approve`)
export const rejectDriver      = (id) => axios.post(`/admin/drivers/${id}/reject`)
