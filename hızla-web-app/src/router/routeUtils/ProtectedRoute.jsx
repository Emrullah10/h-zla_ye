import { Navigate, Outlet } from 'react-router-dom'
import { useMe } from '@shared/hooks/useMe'
import { useAuthStore } from '@store/authStore'
import { Routes } from '@shared/constant/route-paths'
import { Loading } from '@components/Loading/Loading'

export const ProtectedRoute = () => {
  const isAuthenticated = useAuthStore((s) => s.isAuthenticated)
  const { isLoading, isError } = useMe()

  if (!isAuthenticated) return <Navigate to={Routes.Login} replace />
  if (isLoading) return <Loading />
  if (isError) return <Navigate to={Routes.Login} replace />
  return <Outlet />
}
