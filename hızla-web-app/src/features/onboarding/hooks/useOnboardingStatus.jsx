import { useQuery } from '@tanstack/react-query'
import { getOnboardingStatus } from '@api/onboarding'

export const useOnboardingStatus = () =>
  useQuery({
    queryKey: ['onboarding', 'status'],
    queryFn: () => getOnboardingStatus().then((r) => r.data),
    refetchInterval: 30_000,
  })
