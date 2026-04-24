import { create } from 'zustand'

export const useOrderStore = create((set) => ({
  activeOrder: null,
  incomingOrder: null,
  setActiveOrder: (order) => set({ activeOrder: order }),
  setIncomingOrder: (order) => set({ incomingOrder: order }),
  clearIncomingOrder: () => set({ incomingOrder: null }),
}))
