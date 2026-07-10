import { useState } from 'react'
import { useSupport } from '@features/courier/hooks/useSupport'
import { GlassCard } from '@components/GlassCard/GlassCard'

const CATEGORIES = ['Sipariş Sorunu', 'Ödeme Sorunu', 'Teknik Problem', 'Diğer']

export const SupportTicketForm = () => {
  const [category, setCategory] = useState('')
  const [message, setMessage] = useState('')
  const { mutate, isPending } = useSupport()

  return (
    <GlassCard style={{ margin: '1rem' }}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
        <div>
          <label style={{ fontSize: '0.75rem', color: '#9e9e9e', textTransform: 'uppercase', letterSpacing: '0.05em', display: 'block', marginBottom: '0.5rem' }}>
            Kategori
          </label>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.5rem' }}>
            {CATEGORIES.map((c) => (
              <button
                key={c}
                onClick={() => setCategory(c)}
                style={{
                  padding: '0.375rem 0.75rem', borderRadius: '9999px', fontSize: '0.75rem', border: 'none',
                  cursor: 'pointer', transition: 'all 0.2s',
                  background: category === c ? 'linear-gradient(135deg, #FF4B2B, #ff5637)' : '#353535',
                  color: category === c ? '#e2e2e2' : '#9e9e9e',
                }}
              >
                {c}
              </button>
            ))}
          </div>
        </div>
        <div>
          <label style={{ fontSize: '0.75rem', color: '#9e9e9e', textTransform: 'uppercase', letterSpacing: '0.05em', display: 'block', marginBottom: '0.5rem' }}>
            Mesajınız
          </label>
          <textarea
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            rows={4}
            style={{
              width: '100%', background: '#2a2a2a', borderRadius: '16px', padding: '0.75rem 1rem',
              color: '#e2e2e2', outline: 'none', border: 'none', fontSize: '0.875rem', resize: 'none',
              boxSizing: 'border-box',
            }}
            placeholder="Sorununuzu açıklayın…"
          />
        </div>
        <button
          onClick={() => mutate({ category, message })}
          disabled={!category || !message || isPending}
          style={{
            background: 'linear-gradient(135deg, #FF4B2B, #ff5637)',
            color: '#e2e2e2', padding: '0.75rem', borderRadius: '16px', border: 'none',
            fontWeight: 600, fontSize: '1rem', cursor: (!category || !message || isPending) ? 'not-allowed' : 'pointer',
            opacity: (!category || !message || isPending) ? 0.5 : 1,
          }}
        >
          {isPending ? 'Gönderiliyor…' : 'Talebi Gönder'}
        </button>
      </div>
    </GlassCard>
  )
}
