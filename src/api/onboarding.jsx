import axios from '@shared/axios/axios'

export const getOnboardingStatus = () => axios.get('/onboarding/status')
export const selectVehicle       = (vehicleType) => axios.post('/onboarding/vehicle', { vehicleType })
export const uploadDocument      = (type, file) => {
  const fd = new FormData()
  fd.append('type', type)
  fd.append('file', file)
  return axios.post('/onboarding/document', fd, { headers: { 'Content-Type': 'multipart/form-data' } })
}
export const completeTraining    = () => axios.post('/onboarding/training/complete')
