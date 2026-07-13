import { WalletSummary } from '@features/courier/components/WalletSummary/WalletSummary'

const Wallet = () => (
  <div style={{ minHeight: '100%', background: 'var(--bg)' }}>
    <div style={{ padding: '1rem' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: 'var(--text)' }}>Cüzdan</h1>
    </div>
    <WalletSummary />
  </div>
)

export default Wallet
