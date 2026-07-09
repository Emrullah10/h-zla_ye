import { useQuery } from '@tanstack/react-query'
import { getDrivers } from '@api/admin'

export const useDrivers = () =>
  useQuery({
    queryKey: ['admin', 'drivers'],
    queryFn: () => getDrivers().then((r) => r.data),
  })
