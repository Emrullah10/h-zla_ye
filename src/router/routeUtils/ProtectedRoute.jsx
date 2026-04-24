import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '@store/authStore'
import { Routes } from '@shared/constant/route-paths'

export const ProtectedRoute = () => {
  const token = useAuthStore((s) => s.token)
  return token ? <Outlet /> : <Navigate to={Routes.Login} replace />
}
