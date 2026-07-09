import { render, screen } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { ProtectedRoute } from '../ProtectedRoute'
import { useAuthStore } from '@store/authStore'
import { QueryProvider } from '@shared/providers/QueryProvider'
import { vi } from 'vitest'

vi.mock('@shared/hooks/useMe', () => ({
  useMe: vi.fn(),
}))

beforeEach(() => {
  useAuthStore.getState().logout()
  vi.clearAllMocks()
})

function renderWithProviders(ui) {
  return render(<QueryProvider>{ui}</QueryProvider>)
}

test('useMe yüklenirken loading gösterir', async () => {
  const { useMe } = await import('@shared/hooks/useMe')
  useMe.mockReturnValue({ isLoading: true, isError: false })

  renderWithProviders(
    <MemoryRouter initialEntries={['/dashboard']}>
      <Routes>
        <Route path="/login" element={<div>Login</div>} />
        <Route element={<ProtectedRoute />}>
          <Route path="/dashboard" element={<div>Dashboard</div>} />
        </Route>
      </Routes>
    </MemoryRouter>
  )
  // Loading component'i render edilmeli, login'e yönlenmemeli
  expect(screen.queryByText('Login')).not.toBeInTheDocument()
})

test('useMe hata dönerse /login e yönlendirir', async () => {
  const { useMe } = await import('@shared/hooks/useMe')
  useMe.mockReturnValue({ isLoading: false, isError: true })

  renderWithProviders(
    <MemoryRouter initialEntries={['/dashboard']}>
      <Routes>
        <Route path="/login" element={<div>Login</div>} />
        <Route element={<ProtectedRoute />}>
          <Route path="/dashboard" element={<div>Dashboard</div>} />
        </Route>
      </Routes>
    </MemoryRouter>
  )
  expect(screen.getByText('Login')).toBeInTheDocument()
})

test('useMe başarılıysa içeriği render eder', async () => {
  const { useMe } = await import('@shared/hooks/useMe')
  useMe.mockReturnValue({ isLoading: false, isError: false })

  renderWithProviders(
    <MemoryRouter initialEntries={['/dashboard']}>
      <Routes>
        <Route path="/login" element={<div>Login</div>} />
        <Route element={<ProtectedRoute />}>
          <Route path="/dashboard" element={<div>Dashboard</div>} />
        </Route>
      </Routes>
    </MemoryRouter>
  )
  expect(screen.getByText('Dashboard')).toBeInTheDocument()
})
