import { useAuthStore } from '../authStore'

beforeEach(() => useAuthStore.getState().logout())

test('başlangıçta isAuthenticated false', () => {
  expect(useAuthStore.getState().isAuthenticated).toBe(false)
})

test('setUser state günceller', () => {
  useAuthStore.getState().setUser({
    driver: { id: '1', phone: '+905550000001' },
    role: 'courier',
    onboardingStatus: 'APPROVED',
    userPermissionList: ['courier:*'],
  })
  const state = useAuthStore.getState()
  expect(state.isAuthenticated).toBe(true)
  expect(state.role).toBe('courier')
  expect(state.driver.phone).toBe('+905550000001')
})

test('logout sonrası isAuthenticated false', () => {
  useAuthStore.getState().setUser({ driver: null, role: 'courier', onboardingStatus: null, userPermissionList: [] })
  useAuthStore.getState().logout()
  expect(useAuthStore.getState().isAuthenticated).toBe(false)
})
