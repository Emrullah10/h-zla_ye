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

test('başarılı login sonrası isAuthenticated true olur', async () => {
  const { login } = await import('@api/auth')
  login.mockResolvedValue({
    data: {
      driver: { id: '1', phone: '+905550000001' },
      role: 'courier',
      onboardingStatus: 'APPROVED',
      userPermissionList: ['courier:*'],
    },
  })

  useAuthStore.getState().logout()

  const { useLogin } = await import('../useLogin')
  const { result } = renderHook(() => useLogin(), { wrapper })
  await act(() => result.current.mutateAsync({ phone: '+905550000001', password: '123' }))
  expect(useAuthStore.getState().isAuthenticated).toBe(true)
  expect(useAuthStore.getState().role).toBe('courier')
})
