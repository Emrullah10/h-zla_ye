import { create } from 'zustand'
import { persist } from 'zustand/middleware'

export const useUIStore = create(
  persist(
    (set) => ({
      isLoading: false,
      setLoading: (isLoading) => set({ isLoading }),
      // 'system' | 'light' | 'dark'
      themeMode: 'system',
      setThemeMode: (themeMode) => set({ themeMode }),
      // 'auto' | 'light' | 'dark'
      mapMode: 'auto',
      setMapMode: (mapMode) => set({ mapMode }),
    }),
    {
      name: 'hizla-ui',
      partialize: (state) => ({ themeMode: state.themeMode, mapMode: state.mapMode }),
    }
  )
)
