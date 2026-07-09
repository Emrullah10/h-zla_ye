import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { publicRoutes } from './routes/publicRoutes'
import { protectedRoutes } from './routes/protectedRoutes'
import { errorRoutes } from './routes/errorRoutes'

export const App = () => (
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Navigate to="/dashboard" replace />} />
      {publicRoutes}
      {protectedRoutes}
      {errorRoutes}
    </Routes>


  </BrowserRouter>
)
