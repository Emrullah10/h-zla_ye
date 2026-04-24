import { renderHook, act } from '@testing-library/react'
import { vi } from 'vitest'
import { MemoryRouter } from 'react-router-dom'
import { useAuthStore } from '@store/authStore'
import { QueryProvider } from '@shared/providers/QueryProvider'

vi.mock('@api/auth', () => ({
  login: vi.fn(),
}))

const wrapper = ({ children }) => (
  <MemoryRouter><QueryProvider>{children}</QueryProvider></MemoryRouter>
)

test('başarılı login sonrası token store a yazılır', async () => {
  const { login } = await import('@api/auth')
  login.mockResolvedValue({ data: { token: 'tok', expiresIn: 3600, refreshToken: 'ref', driver: null, onboardingStatus: 'APPROVED' } })

  useAuthStore.getState().logout()

  const { useLogin } = await import('../useLogin')
  const { result } = renderHook(() => useLogin(), { wrapper })
  await act(() => result.current.mutateAsync({ email: 'a@a.com', password: '123' }))
  expect(useAuthStore.getState().token).toBe('tok')
})
