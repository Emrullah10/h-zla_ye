import { useState } from 'react'
import { useCompleteTraining } from '@features/onboarding/hooks/useCompleteTraining'
import { GlassCard } from '@components/GlassCard/GlassCard'

const MODULES = [
  { id: 1, title: 'Güvenli Teslimat', duration: '5 dk', icon: '🛡️' },
  { id: 2, title: 'Müşteri İletişimi', duration: '3 dk', icon: '💬' },
  { id: 3, title: 'Uygulama Kullanımı', duration: '4 dk', icon: '📱' },
]

export const TrainingModule = () => {
  const [completed, setCompleted] = useState(new Set())
  const { mutate, isPending } = useCompleteTraining()
  const allDone = completed.size === MODULES.length

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1rem' }}>
      {MODULES.map((mod) => (
        <button
          key={mod.id}
          onClick={() => setCompleted((s) => new Set([...s, mod.id]))}
          style={{ textAlign: 'left', background: 'none', border: 'none', cursor: 'pointer' }}
        >
          <GlassCard style={{
            outline: completed.has(mod.id) ? '1px solid rgba(255,75,43,0.4)' : '1px solid transparent',
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
              <span style={{ fontSize: '2rem' }}>{mod.icon}</span>
              <div style={{ flex: 1 }}>
                <p style={{ fontWeight: 600, color: '#e2e2e2' }}>{mod.title}</p>
                <p style={{ fontSize: '0.75rem', color: '#9e9e9e' }}>{mod.duration}</p>
              </div>
              {completed.has(mod.id) && <span style={{ color: '#FF4B2B', fontSize: '1.25rem' }}>✓</span>}
            </div>
          </GlassCard>
        </button>
      ))}
      <button
        onClick={() => mutate()}
        disabled={!allDone || isPending}
        style={{
          background: 'linear-gradient(135deg, #FF4B2B, #ff5637)',
          color: '#fff', padding: '0.75rem', borderRadius: '8px', border: 'none',
          fontWeight: 600, fontSize: '1rem', cursor: (!allDone || isPending) ? 'not-allowed' : 'pointer',
          opacity: (!allDone || isPending) ? 0.5 : 1, marginTop: '0.5rem',
        }}
      >
        {isPending ? 'Tamamlanıyor…' : 'Eğitimi Tamamla'}
      </button>
    </div>
  )
}
