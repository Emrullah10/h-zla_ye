import { useState } from 'react'
import { useEarnings } from '@features/courier/hooks/useEarnings'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { formatCurrency } from '@shared/utils/formatters'
import { Loading } from '@components/Loading/Loading'

const PERIODS = [
  { label: 'Haftalık', value: 'weekly' },
  { label: 'Aylık', value: 'monthly' },
]

export const EarningsChart = () => {
  const [period, setPeriod] = useState('weekly')
  const { data, isLoading } = useEarnings(period)

  if (isLoading) return <Loading />

  const maxVal = Math.max(...(data?.bars ?? []).map((b) => b.amount), 1)

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1rem' }}>
      <div style={{ display: 'flex', gap: '0.5rem' }}>
        {PERIODS.map(({ label, value }) => (
          <button
            key={value}
            onClick={() => setPeriod(value)}
            style={{
              padding: '0.375rem 1rem', borderRadius: '9999px', fontSize: '0.875rem', border: 'none',
              cursor: 'pointer', transition: 'all 0.2s',
              background: period === value ? '#FF4B2B' : '#2a2a2a',
              color: period === value ? '#fff' : '#9e9e9e',
            }}
          >
            {label}
          </button>
        ))}
      </div>
      <GlassCard>
        <p style={{ fontSize: '0.75rem', color: '#9e9e9e', marginBottom: '4px' }}>Toplam Kazanç</p>
        <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '1.875rem', color: '#e2e2e2', marginBottom: '1rem' }}>
          {formatCurrency(data?.total ?? 0)}
        </p>
        <div style={{ display: 'flex', alignItems: 'flex-end', gap: '4px', height: '8rem' }}>
          {(data?.bars ?? []).map((bar, i) => (
            <div key={i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', flex: 1, gap: '4px' }}>
              <div style={{
                width: '100%', background: 'rgba(255,75,43,0.3)', borderRadius: '2px',
                height: `${(bar.amount / maxVal) * 100}%`, transition: 'height 0.3s',
              }} />
              <span style={{ fontSize: '0.65rem', color: '#9e9e9e' }}>{bar.label}</span>
            </div>
          ))}
        </div>
      </GlassCard>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '0.75rem' }}>
        {[
          { label: 'Sipariş', value: data?.orderCount ?? 0, mono: false },
          { label: 'Ort. Sipariş', value: formatCurrency(data?.avgOrderFee ?? 0), mono: true },
          { label: 'Çevrimiçi', value: `${data?.onlineHours ?? 0}s`, mono: true },
        ].map(({ label, value }) => (
          <GlassCard key={label} style={{ padding: '0.75rem' }}>
            <p style={{ fontSize: '0.75rem', color: '#9e9e9e', marginBottom: '4px' }}>{label}</p>
            <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '1.125rem', color: '#e2e2e2' }}>{value}</p>
          </GlassCard>
        ))}
      </div>
    </div>
  )
}
