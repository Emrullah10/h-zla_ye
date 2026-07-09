import { EarningsChart } from '@features/courier/components/EarningsChart/EarningsChart'

const Earnings = () => (
  <div style={{ minHeight: '100%', background: '#0e0e0e' }}>
    <div style={{ padding: '1rem', borderBottom: '1px solid rgba(255,255,255,0.05)' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: '#e2e2e2' }}>Kazanç & Analitik</h1>
    </div>
    <EarningsChart />
  </div>
)

export default Earnings
