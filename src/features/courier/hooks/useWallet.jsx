import { useQuery } from '@tanstack/react-query'
import { getWallet } from '@api/courier'

export const useWallet = () =>
  useQuery({
    queryKey: ['courier', 'wallet'],
    queryFn: () => getWallet().then((r) => r.data),
  })
