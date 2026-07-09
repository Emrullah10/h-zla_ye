import { useMutation, useQueryClient } from '@tanstack/react-query'
import { rejectDriver } from '@api/admin'

export const useRejectDriver = () => {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: rejectDriver,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['admin', 'drivers'] })
      qc.invalidateQueries({ queryKey: ['admin', 'dashboard'] })
    },
  })
}
