import { useMutation, useQueryClient } from '@tanstack/react-query'
import { verifyPackage } from '@api/courier'

export const useVerifyPackage = (orderId) => {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (qrCode) => verifyPackage(orderId, qrCode),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['courier', 'active-order'] })
  })
}
