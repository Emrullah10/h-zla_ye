import { useMutation, useQueryClient } from '@tanstack/react-query'
import { acceptOrder } from '@api/courier'

export const useAcceptOrder = () => {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: acceptOrder,
    onSuccess: () => qc.invalidateQueries({ queryKey: ['courier', 'active-order'] })
  })
}
