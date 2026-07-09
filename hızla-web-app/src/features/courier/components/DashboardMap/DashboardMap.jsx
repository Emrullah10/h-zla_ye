import { MapView } from '@components/MapView/MapView'
import { IncomingOrderOverlay } from '../IncomingOrderOverlay/IncomingOrderOverlay'
import { useActiveOrder } from '@features/courier/hooks/useActiveOrder'

export const DashboardMap = () => {
  const { data: order } = useActiveOrder()

  return (
    <div style={{ position: 'relative', height: '100%' }}>
      <MapView style={{ position: 'absolute', inset: 0 }} />
      {order?.status === 'INCOMING' && (
        <IncomingOrderOverlay order={order} />
      )}
    </div>
  )
}
