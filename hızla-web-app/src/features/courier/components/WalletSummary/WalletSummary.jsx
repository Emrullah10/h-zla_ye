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
        <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '0.1em', marginBottom: '4px' }}>
          Toplam Bakiye
        </p>
        <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '2.5rem', color: 'var(--text)' }}>
          {formatCurrency(data?.balance ?? 0)}
        </p>
      </GlassCard>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
        <GlassCard style={{ padding: '1rem' }}>
          <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginBottom: '4px' }}>Bu Hafta</p>
          <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '1.25rem', color: 'var(--brand)' }}>
            {formatCurrency(data?.weeklyEarnings ?? 0)}
          </p>
        </GlassCard>
        <GlassCard style={{ padding: '1rem' }}>
          <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginBottom: '4px' }}>Bekleyen</p>
          <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '1.25rem', color: 'var(--neon)' }}>
            {formatCurrency(data?.pending ?? 0)}
          </p>
        </GlassCard>
      </div>
      <GlassCard>
        <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginBottom: '0.75rem' }}>Son İşlemler</p>
        {(data?.transactions ?? []).map((tx) => (
          <div key={tx.id} style={{
            display: 'flex', justifyContent: 'space-between', alignItems: 'center',
            padding: '0.5rem 0',
          }}>
            <div>
              <p style={{ fontSize: '0.875rem', color: 'var(--text)' }}>{tx.description}</p>
              <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>{tx.date}</p>
            </div>
            <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '0.875rem', color: tx.amount > 0 ? 'var(--brand)' : 'var(--error)' }}>
              {tx.amount > 0 ? '+' : ''}{formatCurrency(tx.amount)}
            </p>
          </div>
        ))}
      </GlassCard>
    </div>
  )
}
