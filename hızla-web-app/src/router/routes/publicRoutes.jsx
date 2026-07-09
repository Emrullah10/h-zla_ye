import { Route } from 'react-router-dom'
import { lazy, Suspense } from 'react'

const Login = lazy(() => import('@pages/login/Login'))

export const publicRoutes = (
  <Route path="/login" element={<Suspense fallback={null}><Login /></Suspense>} />
)
