import { useQuery } from '@tanstack/react-query'
import { getAdminDashboard } from '@api/admin'

export const useAdminDashboard = () =>
  useQuery({
    queryKey: ['admin', 'dashboard'],
    queryFn: () => getAdminDashboard().then((r) => r.data),
    refetchInterval: 60_000,
  })
