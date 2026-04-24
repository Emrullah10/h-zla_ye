import { useWallet } from '@features/courier/hooks/useWallet'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { formatCurrency } from '@shared/utils/formatters'
import { Loading } from '@components/Loading/Loading'

export const WalletSummary = () => {
  const { data, isLoading } = useWallet()

  if (isLoading) return <Loading />

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1rem' }}>
      <GlassCard>
        <p style={{ fontSize: '0.75rem', color: '#9e9e9e', textTransform: 'uppercase', letterSpacing: '0.1em', marginBottom: '4px' }}>
          Toplam Bakiye
        </p>
        <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '2.5rem', color: '#e2e2e2' }}>
          {formatCurrency(data?.balance ?? 0)}
        </p>
      </GlassCard>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
        <GlassCard style={{ padding: '1rem' }}>
          <p style={{ fontSize: '0.75rem', color: '#9e9e9e', marginBottom: '4px' }}>Bu Hafta</p>
          <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '1.25rem', color: '#FF4B2B' }}>
            {formatCurrency(data?.weeklyEarnings ?? 0)}
          </p>
        </GlassCard>
        <GlassCard style={{ padding: '1rem' }}>
          <p style={{ fontSize: '0.75rem', color: '#9e9e9e', marginBottom: '4px' }}>Bekleyen</p>
          <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '1.25rem', color: '#00daf3' }}>
            {formatCurrency(data?.pending ?? 0)}
          </p>
        </GlassCard>
      </div>
      <GlassCard>
        <p style={{ fontSize: '0.75rem', color: '#9e9e9e', marginBottom: '0.75rem' }}>Son İşlemler</p>
        {(data?.transactions ?? []).map((tx) => (
          <div key={tx.id} style={{
            display: 'flex', justifyContent: 'space-between', alignItems: 'center',
            padding: '0.5rem 0', borderBottom: '1px solid rgba(255,255,255,0.05)',
          }}>
            <div>
              <p style={{ fontSize: '0.875rem', color: '#e2e2e2' }}>{tx.description}</p>
              <p style={{ fontSize: '0.75rem', color: '#9e9e9e' }}>{tx.date}</p>
            </div>
            <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '0.875rem', color: tx.amount > 0 ? '#FF4B2B' : '#ffb4ab' }}>
              {tx.amount > 0 ? '+' : ''}{formatCurrency(tx.amount)}
            </p>
          </div>
        ))}
      </GlassCard>
    </div>
  )
}
