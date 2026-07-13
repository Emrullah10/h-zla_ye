import { useDrivers } from '@features/admin/hooks/useDrivers'
import { useApproveDriver } from '@features/admin/hooks/useApproveDriver'
import { useRejectDriver } from '@features/admin/hooks/useRejectDriver'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { Loading } from '@components/Loading/Loading'

const VEHICLE_LABELS = {
  bicycle: 'Bisiklet',
  motorcycle: 'Motor',
  car: 'Otomobil',
}

export const DriverList = () => {
  const { data, isLoading } = useDrivers()
  const approve = useApproveDriver()
  const reject = useRejectDriver()

  if (isLoading) return <Loading />

  const drivers = data?.drivers ?? []

  if (drivers.length === 0) {
    return (
      <p style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', textAlign: 'center', padding: '2rem 0' }}>
        Bekleyen başvuru yok
      </p>
    )
  }

  const isBusy = approve.isPending || reject.isPending

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
      {drivers.map((d) => (
        <GlassCard key={d.appId} style={{ padding: '1rem' }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
            <span style={{ fontSize: '0.9rem', fontWeight: 600, color: 'var(--text)' }}>{d.phone}</span>
            <span style={{
              fontSize: '0.7rem', padding: '2px 8px', borderRadius: '4px',
              background: 'rgba(255,75,43,0.15)', color: 'var(--brand)',
            }}>
              {VEHICLE_LABELS[d.vehicleType] ?? d.vehicleType}
            </span>
          </div>
          <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginBottom: '0.75rem' }}>
            {new Date(d.createdAt).toLocaleDateString('tr-TR', { day: 'numeric', month: 'long', year: 'numeric' })}
          </p>
          <div style={{ display: 'flex', gap: '0.5rem' }}>
            <button
              onClick={() => approve.mutate(d.appId)}
              disabled={isBusy}
              style={{
                flex: 1, padding: '0.5rem', borderRadius: '16px', border: 'none',
                background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))', color: 'var(--text)', fontWeight: 600, fontSize: '0.85rem',
                cursor: isBusy ? 'not-allowed' : 'pointer', opacity: isBusy ? 0.5 : 1,
              }}
            >
              Onayla
            </button>
            <button
              onClick={() => reject.mutate(d.appId)}
              disabled={isBusy}
              style={{
                flex: 1, padding: '0.5rem', borderRadius: '16px',
                background: 'var(--surface-container-highest)',
                color: 'var(--text-secondary)', fontWeight: 500, fontSize: '0.85rem',
                cursor: isBusy ? 'not-allowed' : 'pointer', opacity: isBusy ? 0.5 : 1,
              }}
            >
              Reddet
            </button>
          </div>
        </GlassCard>
      ))}
    </div>
  )
}
