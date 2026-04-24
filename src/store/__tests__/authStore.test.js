import { useAuthStore } from '../authStore'

beforeEach(() => useAuthStore.getState().logout())

test('başlangıçta token null', () => {
  expect(useAuthStore.getState().token).toBeNull()
})

test('setToken token ve expiry set eder', () => {
  useAuthStore.getState().setToken('abc', 3600)
  const { token, tokenExpiry } = useAuthStore.getState()
  expect(token).toBe('abc')
  expect(tokenExpiry).toBeGreaterThan(Date.now() / 1000)
})

test('logout sonrası token null', () => {
  useAuthStore.getState().setToken('abc', 3600)
  useAuthStore.getState().logout()
  expect(useAuthStore.getState().token).toBeNull()
})
