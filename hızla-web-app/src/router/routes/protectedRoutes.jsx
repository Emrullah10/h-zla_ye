import { Route } from 'react-router-dom'
import { lazy, Suspense } from 'react'
import { ProtectedRoute } from '../routeUtils/ProtectedRoute'
import { OnboardingGuard } from '../routeUtils/OnboardingGuard'
import MainLayout from '@layouts/Main/Main'
import OnboardingLayout from '@layouts/Onboarding/Onboarding'

const Dashboard   = lazy(() => import('@pages/dashboard/Dashboard'))
const Wallet      = lazy(() => import('@pages/wallet/Wallet'))
const Earnings    = lazy(() => import('@pages/earnings/Earnings'))
const Quests      = lazy(() => import('@pages/quests/Quests'))
const OrderVerify = lazy(() => import('@pages/order-verify/OrderVerify'))
const OrderRate   = lazy(() => import('@pages/order-rate/OrderRate'))
const Support     = lazy(() => import('@pages/support/Support'))
const Admin       = lazy(() => import('@pages/admin/Admin'))
const VehicleSel  = lazy(() => import('@pages/onboarding/VehicleSelection'))
const DocUpload   = lazy(() => import('@pages/onboarding/DocumentUpload'))
const Training    = lazy(() => import('@pages/onboarding/Training'))
const Pending     = lazy(() => import('@pages/onboarding/PendingApproval'))

const S = ({ children }) => <Suspense fallback={null}>{children}</Suspense>

export const protectedRoutes = (
  <Route element={<ProtectedRoute />}>
    <Route element={<OnboardingGuard />}>
      <Route element={<MainLayout />}>
        <Route path="/dashboard"        element={<S><Dashboard /></S>} />
        <Route path="/wallet"           element={<S><Wallet /></S>} />
        <Route path="/earnings"         element={<S><Earnings /></S>} />
        <Route path="/quests"           element={<S><Quests /></S>} />
        <Route path="/order/:id/verify" element={<S><OrderVerify /></S>} />
        <Route path="/order/:id/rate"   element={<S><OrderRate /></S>} />
        <Route path="/support"          element={<S><Support /></S>} />
        <Route path="/admin"            element={<S><Admin /></S>} />
      </Route>
    </Route>
    <Route element={<OnboardingLayout />}>
      <Route path="/onboarding/vehicle"   element={<S><VehicleSel /></S>} />
      <Route path="/onboarding/documents" element={<S><DocUpload /></S>} />
      <Route path="/onboarding/training"  element={<S><Training /></S>} />
      <Route path="/onboarding/pending"   element={<S><Pending /></S>} />
    </Route>
  </Route>
)
