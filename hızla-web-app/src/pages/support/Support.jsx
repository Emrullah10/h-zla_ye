import { SupportTicketForm } from '@features/courier/components/SupportTicketForm/SupportTicketForm'
import { GlassCard } from '@components/GlassCard/GlassCard'

const FAQ = [
  { q: 'Siparişi iptal edemiyorum', a: 'Sipariş teslim aldıktan sonra destek ile iletişime geçin.' },
  { q: 'Ödeme hesabıma geçmedi', a: 'Ödemeler her Pazartesi işlenir, 2 iş günü içinde yansır.' },
]

const Support = () => (
  <div style={{ minHeight: '100%', background: 'var(--bg)', overflowY: 'auto' }}>
    <div style={{ padding: '1rem' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: 'var(--text)' }}>Destek Merkezi</h1>
    </div>
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem', padding: '1rem' }}>
      {FAQ.map((item) => (
        <GlassCard key={item.q}>
          <p style={{ fontSize: '0.875rem', fontWeight: 600, color: 'var(--text)' }}>{item.q}</p>
          <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginTop: '4px' }}>{item.a}</p>
        </GlassCard>
      ))}
    </div>
    <SupportTicketForm />
  </div>
)

export default Support
