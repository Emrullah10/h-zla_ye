import { create } from 'zustand'

export const useModalStore = create((set) => ({
  openModal: null,
  openModalData: null,
  open: (name, data = null) => set({ openModal: name, openModalData: data }),
  close: () => set({ openModal: null, openModalData: null }),
}))
