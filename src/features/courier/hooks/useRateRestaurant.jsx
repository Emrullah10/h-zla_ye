import { useMutation } from '@tanstack/react-query'
import { rateRestaurant } from '@api/courier'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useRateRestaurant = (orderId) => {
  const navigate = useNavigate()
  return useMutation({
    mutationFn: (data) => rateRestaurant(orderId, data),
    onSuccess: () => navigate(Routes.Dashboard)
  })
}
