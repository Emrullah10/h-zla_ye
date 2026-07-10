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
        background: '#0e0e0e',
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
            background: 'linear-gradient(135deg, #ffb4a5, #ff5637)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            marginBottom: '0.5rem',
          }}
        >
          {code}
        </div>
        <div
          style={{
            color: '#e2e2e2',
            fontSize: '1.25rem',
            fontWeight: 600,
            marginBottom: '0.5rem',
          }}
        >
          {title}
        </div>
        <div
          style={{
            color: '#e5bdb6',
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
            background: 'linear-gradient(135deg, #ffb4a5, #ff5637)',
            color: '#650b00',
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
