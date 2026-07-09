import { create } from 'zustand'

export const useUIStore = create((set) => ({
  isLoading: false,
  setLoading: (isLoading) => set({ isLoading }),
}))
