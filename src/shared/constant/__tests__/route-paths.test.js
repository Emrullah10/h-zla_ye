import { Routes } from '../route-paths'

test('Routes.Login returns /login', () => {
  expect(Routes.Login).toBe('/login')
})

test('Routes.Dashboard returns /dashboard', () => {
  expect(Routes.Dashboard).toBe('/dashboard')
})

test('Routes.OrderVerify returns function that builds path', () => {
  expect(Routes.OrderVerify('abc123')).toBe('/order/abc123/verify')
})
