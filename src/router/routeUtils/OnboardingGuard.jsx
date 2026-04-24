import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '@store/authStore'
import { Routes } from '@shared/constant/route-paths'

export const OnboardingGuard = () => {
  const status = useAuthStore((s) => s.onboardingStatus)
  if (status === 'APPROVED') return <Navigate to={Routes.Dashboard} replace />
  return <Outlet />
}
