import { useQuery } from '@tanstack/react-query'
import { getMe } from '@api/auth'
import { useAuthStore } from '@store/authStore'

export const useMe = () => {
  const setUser = useAuthStore((s) => s.setUser)

  return useQuery({
    queryKey: ['me'],
    queryFn: async () => {
      const { data } = await getMe()
      const { driver } = useAuthStore.getState()
      setUser({
        driver,
        role: data.role,
        onboardingStatus: data.onboardingStatus ?? null,
        userPermissionList: data.userPermissionList ?? [],
      })
      return data
    },
    retry: false,
    staleTime: 5 * 60 * 1000,
  })
}
