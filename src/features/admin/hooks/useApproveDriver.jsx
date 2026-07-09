import { useMutation, useQueryClient } from '@tanstack/react-query'
import { approveDriver } from '@api/admin'

export const useApproveDriver = () => {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: approveDriver,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['admin', 'drivers'] })
      qc.invalidateQueries({ queryKey: ['admin', 'dashboard'] })
    },
  })
}
