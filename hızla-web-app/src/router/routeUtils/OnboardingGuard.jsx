import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '@store/authStore'
import { Routes } from '@shared/constant/route-paths'

export const OnboardingGuard = () => {
  const status = useAuthStore((s) => s.onboardingStatus)
  const role = useAuthStore((s) => s.role)
  if (role === 'admin' || status === 'approved') return <Outlet />
  if (status === 'documents_uploaded') return <Navigate to={Routes.OnboardingTraining} replace />
  if (status === 'training_complete') return <Navigate to={Routes.OnboardingPending} replace />
  return <Navigate to={Routes.OnboardingVehicle} replace />
}
