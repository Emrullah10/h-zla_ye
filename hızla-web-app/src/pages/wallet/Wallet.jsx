import { WalletSummary } from '@features/courier/components/WalletSummary/WalletSummary'

const Wallet = () => (
  <div style={{ minHeight: '100%', background: '#0e0e0e' }}>
    <div style={{ padding: '1rem' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: '#e2e2e2' }}>Cüzdan</h1>
    </div>
    <WalletSummary />
  </div>
)

export default Wallet
