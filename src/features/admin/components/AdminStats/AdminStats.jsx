import { useAdminDashboard } from '@features/admin/hooks/useAdminDashboard'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { Loading } from '@components/Loading/Loading'
import { formatCurrency } from '@shared/utils/formatters'

export const AdminStats = () => {
  const { data, isLoading } = useAdminDashboard()

  if (isLoading) return <Loading />

  const stats = [
    { label: 'Aktif Kuryeler',      value: data?.activeCouriers ?? 0,              mono: false },
    { label: 'Bugünkü Siparişler',  value: data?.todayOrders ?? 0,                 mono: false },
    { label: 'Günlük Ciro',         value: formatCurrency(data?.dailyRevenue ?? 0), mono: true  },
    { label: 'Onay Bekleyenler',    value: data?.pendingApprovals ?? 0,             mono: false },
  ]

  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem', padding: '1rem' }}>
      {stats.map(({ label, value, mono }) => (
        <GlassCard key={label} style={{ padding: '1rem' }}>
          <p style={{ fontSize: '0.75rem', color: '#9e9e9e', marginBottom: '4px' }}>{label}</p>
          <p style={{
            fontSize: '1.5rem',
            fontFamily: mono ? 'JetBrains Mono, monospace' : 'inherit',
            fontWeight: mono ? 400 : 700,
            color: '#e2e2e2',
          }}>
            {value}
          </p>
        </GlassCard>
      ))}
    </div>
  )
}
