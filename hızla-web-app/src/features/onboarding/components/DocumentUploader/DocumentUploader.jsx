import { useState } from 'react'
import { useUploadDocument } from '@features/onboarding/hooks/useUploadDocument'
import { GlassCard } from '@components/GlassCard/GlassCard'

const DOCS = [
  { type: 'id_front',           label: 'Kimlik Ön Yüz' },
  { type: 'id_back',            label: 'Kimlik Arka Yüz' },
  { type: 'license_front',      label: 'Sürücü Belgesi Ön' },
  { type: 'license_back',       label: 'Sürücü Belgesi Arka' },
  { type: 'vehicle_registration', label: 'Araç Ruhsatı' },
]

export const DocumentUploader = () => {
  const [uploaded, setUploaded] = useState({})
  const [current, setCurrent] = useState(null)
  const { mutate, isPending } = useUploadDocument()

  const handleFile = (type, file) => {
    setUploaded((prev) => ({ ...prev, [type]: file.name }))
    setCurrent({ type, file })
  }

  const allDone = DOCS.every((d) => uploaded[d.type])

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', padding: '1rem' }}>
      {DOCS.map((doc) => (
        <GlassCard key={doc.type} style={{
          outline: uploaded[doc.type] ? '1px solid rgba(255,75,43,0.4)' : '1px solid transparent',
        }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <p style={{ fontSize: '0.875rem', fontWeight: 600, color: 'var(--text)' }}>{doc.label}</p>
              {uploaded[doc.type] && (
                <p style={{ fontSize: '0.75rem', color: 'var(--brand)', marginTop: '2px' }}>✓ {uploaded[doc.type]}</p>
              )}
            </div>
            <label style={{ cursor: 'pointer' }}>
              <span style={{
                padding: '0.375rem 0.75rem', background: 'var(--surface-container-highest)', color: 'var(--text-secondary)',
                fontSize: '0.75rem', borderRadius: '9999px', display: 'inline-block',
              }}>
                {uploaded[doc.type] ? 'Değiştir' : 'Yükle'}
              </span>
              <input
                type="file"
                accept="image/*"
                style={{ display: 'none' }}
                onChange={(e) => e.target.files?.[0] && handleFile(doc.type, e.target.files[0])}
              />
            </label>
          </div>
        </GlassCard>
      ))}
      <button
        onClick={() => current && mutate(current)}
        disabled={!allDone || isPending}
        style={{
          background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))',
          color: 'var(--text)', padding: '0.75rem', borderRadius: '16px', border: 'none',
          fontWeight: 600, fontSize: '1rem', cursor: (!allDone || isPending) ? 'not-allowed' : 'pointer',
          opacity: (!allDone || isPending) ? 0.5 : 1, marginTop: '0.5rem',
        }}
      >
        {isPending ? 'Yükleniyor…' : 'Belgeleri Gönder'}
      </button>
    </div>
  )
}
