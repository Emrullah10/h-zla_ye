import { GlassCard } from '@components/GlassCard/GlassCard'
import { SlideToAccept } from '@components/SlideToAccept/SlideToAccept'
import { CountdownBorder } from '@components/CountdownBorder/CountdownBorder'
import { useAcceptOrder } from '@features/courier/hooks/useAcceptOrder'
import { useRejectOrder } from '@features/courier/hooks/useRejectOrder'
import { formatCurrency, formatDistance } from '@shared/utils/formatters'

export const IncomingOrderOverlay = ({ order }) => {
  const { mutate: accept } = useAcceptOrder()
  const { mutate: reject } = useRejectOrder()

  return (
    <div style={{
      position: 'absolute', bottom: '5rem', left: '1rem', right: '1rem', zIndex: 50,
    }}>
      <CountdownBorder active>
        <GlassCard>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '1rem' }}>
            <div>
              <h3 style={{ color: '#e2e2e2', fontWeight: 600 }}>{order.restaurant}</h3>
              <p style={{ color: '#9e9e9e', fontSize: '0.875rem' }}>{order.customerAddress}</p>
            </div>
            <div style={{ textAlign: 'right' }}>
              <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '1.25rem', color: '#FF4B2B' }}>
                {formatCurrency(order.fee)}
              </p>
              <p style={{ color: '#9e9e9e', fontSize: '0.75rem' }}>{formatDistance(order.distanceMeters)}</p>
            </div>
          </div>
          <SlideToAccept onAccept={() => accept(order.id)} label="Sürükle → Kabul Et" />
          <button
            onClick={() => reject(order.id)}
            style={{
              width: '100%', marginTop: '0.5rem', padding: '0.5rem',
              background: 'none', border: 'none', color: '#9e9e9e',
              fontSize: '0.875rem', cursor: 'pointer',
            }}
          >
            Reddet
          </button>
        </GlassCard>
      </CountdownBorder>
    </div>
  )
}
