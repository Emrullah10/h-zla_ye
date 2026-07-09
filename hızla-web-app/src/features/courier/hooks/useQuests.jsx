import { useQuery } from '@tanstack/react-query'
import { getQuests } from '@api/courier'

export const useQuests = () =>
  useQuery({
    queryKey: ['courier', 'quests'],
    queryFn: () => getQuests().then((r) => r.data),
  })
