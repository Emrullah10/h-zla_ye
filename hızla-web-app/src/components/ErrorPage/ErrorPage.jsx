import { useNavigate } from 'react-router-dom'
import { GlassCard } from '@components/GlassCard/GlassCard'

export const ErrorPage = ({ code, title, description }) => {
  const navigate = useNavigate()

  return (
    <div
      style={{
        minHeight: '100vh',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'var(--bg)',
        padding: '1.5rem',
        textAlign: 'center',
      }}
    >
      <GlassCard style={{ maxWidth: 420, width: '100%' }}>
        <div
          style={{
            fontFamily: "'JetBrains Mono', monospace",
            fontSize: '3rem',
            fontWeight: 700,
            background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            marginBottom: '0.5rem',
          }}
        >
          {code}
        </div>
        <div
          style={{
            color: 'var(--text)',
            fontSize: '1.25rem',
            fontWeight: 600,
            marginBottom: '0.5rem',
          }}
        >
          {title}
        </div>
        <div
          style={{
            color: 'var(--text-muted)',
            fontSize: '0.9rem',
            marginBottom: '1.5rem',
          }}
        >
          {description}
        </div>
        <button
          onClick={() => navigate('/dashboard')}
          style={{
            width: '100%',
            padding: '0.9rem',
            border: 'none',
            borderRadius: '16px',
            background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))',
            color: 'var(--surface)',
            fontWeight: 700,
            fontSize: '0.95rem',
            cursor: 'pointer',
          }}
        >
          Ana Sayfaya Dön
        </button>
      </GlassCard>
    </div>
  )
}
