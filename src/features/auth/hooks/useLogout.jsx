import { useMutation, useQueryClient } from '@tanstack/react-query'
import { logout } from '@api/auth'
import { useAuthStore } from '@store/authStore'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useLogout = () => {
  const logoutStore = useAuthStore((s) => s.logout)
  const navigate = useNavigate()
  const qc = useQueryClient()

  return useMutation({
    mutationFn: logout,
    onSettled: () => {
      logoutStore()
      qc.clear()
      navigate(Routes.Login, { replace: true })
    },
  })
}
