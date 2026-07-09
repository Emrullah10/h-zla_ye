import { renderHook, waitFor } from '@testing-library/react'
import { vi } from 'vitest'
import { useActiveOrder } from '../useActiveOrder'
import { QueryProvider } from '@shared/providers/QueryProvider'

vi.mock('@api/courier', () => ({
  getActiveOrder: vi.fn(),
}))

const wrapper = ({ children }) => <QueryProvider>{children}</QueryProvider>

test('API den aktif siparişi döner', async () => {
  const { getActiveOrder } = await import('@api/courier')
  getActiveOrder.mockResolvedValue({ data: { id: 'ord1', restaurant: 'Burger Co' } })
  const { result } = renderHook(() => useActiveOrder(), { wrapper })
  await waitFor(() => expect(result.current.isSuccess).toBe(true))
  expect(result.current.data.id).toBe('ord1')
})
