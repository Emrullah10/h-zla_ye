import { useQuery } from '@tanstack/react-query'
import { getEarnings } from '@api/courier'

export const useEarnings = (period = 'weekly') =>
  useQuery({
    queryKey: ['courier', 'earnings', period],
    queryFn: () => getEarnings({ period }).then((r) => r.data),
  })
