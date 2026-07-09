import { create } from 'zustand'
import { persist } from 'zustand/middleware'

export const useAuthStore = create(
  persist(
    (set) => ({
      driver: null,
      role: null,
      onboardingStatus: null,
      userPermissionList: [],
      isAuthenticated: false,
      setUser: ({ driver, role, onboardingStatus, userPermissionList }) =>
        set({ driver, role, onboardingStatus, userPermissionList, isAuthenticated: true }),
      setOnboardingStatus: (status) => set({ onboardingStatus: status }),
      logout: () =>
        set({ driver: null, role: null, onboardingStatus: null, userPermissionList: [], isAuthenticated: false }),
    }),
    { name: 'hizla-auth' }
  )
)
