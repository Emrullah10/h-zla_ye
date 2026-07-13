import { EarningsChart } from '@features/courier/components/EarningsChart/EarningsChart'

const Earnings = () => (
  <div style={{ minHeight: '100%', background: 'var(--bg)' }}>
    <div style={{ padding: '1rem' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: 'var(--text)' }}>Kazanç & Analitik</h1>
    </div>
    <EarningsChart />
  </div>
)

export default Earnings
