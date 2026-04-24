import { create } from 'zustand'
import { persist } from 'zustand/middleware'

export const useAuthStore = create(
  persist(
    (set) => ({
      token: null,
      tokenExpiry: null,
      refreshToken: null,
      driver: null,
      onboardingStatus: null,
      setToken: (token, expiresIn, refreshToken) =>
        set({ token, tokenExpiry: Date.now() / 1000 + expiresIn, refreshToken }),
      setDriver: (driver) => set({ driver }),
      setOnboardingStatus: (status) => set({ onboardingStatus: status }),
      logout: () => set({ token: null, tokenExpiry: null, refreshToken: null, driver: null }),
    }),
    { name: 'hizla-auth' }
  )
)
