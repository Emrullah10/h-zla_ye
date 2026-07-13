import { MapView } from '@components/MapView/MapView'
import { IncomingOrderOverlay } from '../IncomingOrderOverlay/IncomingOrderOverlay'
import { useActiveOrder } from '@features/courier/hooks/useActiveOrder'
import { useCourierLocationWs } from '@features/courier/hooks/useCourierLocationWs'

export const DashboardMap = () => {
  const { data: order } = useActiveOrder()
  const locations = useCourierLocationWs()

  const courierLoc = order?.courierId ? locations[order.courierId] : Object.values(locations)[0]

  const markers = []
  if (courierLoc) markers.push({ type: 'courier', lat: courierLoc.lat, lng: courierLoc.lng })
  if (order?.pickupLat != null && order?.pickupLng != null) {
    markers.push({ type: 'pickup', lat: order.pickupLat, lng: order.pickupLng })
  }
  if (order?.deliveryLat != null && order?.deliveryLng != null) {
    markers.push({ type: 'delivery', lat: order.deliveryLat, lng: order.deliveryLng })
  }

  const polyline = markers.length > 1 ? markers.map((m) => [m.lat, m.lng]) : null

  return (
    <div style={{ position: 'relative', height: '100%' }}>
      <MapView style={{ position: 'absolute', inset: 0 }} markers={markers} polyline={polyline} />
      {order?.status === 'pending' && (
        <IncomingOrderOverlay order={order} />
      )}
    </div>
  )
}
