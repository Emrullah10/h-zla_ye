import { useQuery } from '@tanstack/react-query'
import { getActiveOrder } from '@api/courier'

export const useActiveOrder = () =>
  useQuery({
    queryKey: ['courier', 'active-order'],
    queryFn: () => getActiveOrder().then((r) => r.data),
    refetchInterval: 5000,
  })
