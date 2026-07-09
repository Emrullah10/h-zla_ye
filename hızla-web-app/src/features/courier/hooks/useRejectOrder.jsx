import { useMutation, useQueryClient } from '@tanstack/react-query'
import { rejectOrder } from '@api/courier'

export const useRejectOrder = () => {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: rejectOrder,
    onSuccess: () => qc.invalidateQueries({ queryKey: ['courier', 'active-order'] })
  })
}
