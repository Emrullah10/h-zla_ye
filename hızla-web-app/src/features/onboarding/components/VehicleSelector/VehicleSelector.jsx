import { useState } from 'react'
import { useSelectVehicle } from '@features/onboarding/hooks/useSelectVehicle'
import { GlassCard } from '@components/GlassCard/GlassCard'

const VEHICLES = [
  { type: 'bicycle',    label: 'Bisiklet', icon: '🚲', desc: 'Şehir içi, çevre dostu' },
  { type: 'motorcycle', label: 'Motor',    icon: '🏍️', desc: 'Hızlı teslimat' },
  { type: 'car',        label: 'Otomobil', icon: '🚗', desc: 'Büyük siparişler' },
]

export const VehicleSelector = () => {
  const [selected, setSelected] = useState(null)
  const { mutate, isPending } = useSelectVehicle()

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1rem' }}>
      {VEHICLES.map((v) => (
        <button
          key={v.type}
          onClick={() => setSelected(v.type)}
          style={{ textAlign: 'left', background: 'none', border: 'none', cursor: 'pointer' }}
        >
          <GlassCard style={{
            outline: selected === v.type ? '2px solid #FF4B2B' : '2px solid transparent',
            transition: 'outline 0.2s',
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
              <span style={{ fontSize: '2.5rem' }}>{v.icon}</span>
              <div>
                <p style={{ fontWeight: 600, color: '#e2e2e2' }}>{v.label}</p>
                <p style={{ fontSize: '0.75rem', color: '#9e9e9e' }}>{v.desc}</p>
              </div>
            </div>
          </GlassCard>
        </button>
      ))}
      <button
        onClick={() => selected && mutate(selected)}
        disabled={!selected || isPending}
        style={{
          background: 'linear-gradient(135deg, #FF4B2B, #ff5637)',
          color: '#e2e2e2', padding: '0.75rem', borderRadius: '16px', border: 'none',
          fontWeight: 600, fontSize: '1rem', cursor: (!selected || isPending) ? 'not-allowed' : 'pointer',
          opacity: (!selected || isPending) ? 0.5 : 1, marginTop: '0.5rem',
        }}
      >
        {isPending ? 'Kaydediliyor…' : 'Devam Et'}
      </button>
    </div>
  )
}
