import { useState } from 'react'
import { useLogin } from '@features/auth/hooks/useLogin'

export const LoginForm = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const { mutate, isPending, error } = useLogin()

  const onSubmit = (e) => {
    e.preventDefault()
    mutate({ email, password })
  }

  return (
    <form onSubmit={onSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1rem', width: '100%', maxWidth: '24rem' }}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
        <label style={{ fontSize: '0.75rem', color: '#9e9e9e', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          E-posta
        </label>
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          style={{
            background: '#2a2a2a', borderRadius: '8px', padding: '0.75rem 1rem',
            color: '#e2e2e2', outline: 'none', border: 'none', fontSize: '1rem',
          }}
          placeholder="kurye@hizlaye.com"
          required
        />
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
        <label style={{ fontSize: '0.75rem', color: '#9e9e9e', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Şifre
        </label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          style={{
            background: '#2a2a2a', borderRadius: '8px', padding: '0.75rem 1rem',
            color: '#e2e2e2', outline: 'none', border: 'none', fontSize: '1rem',
          }}
          placeholder="••••••••"
          required
        />
      </div>
      {error && <p style={{ color: '#ffb4ab', fontSize: '0.875rem' }}>{error.message}</p>}
      <button
        type="submit"
        disabled={isPending}
        style={{
          background: 'linear-gradient(135deg, #FF4B2B, #ff5637)',
          color: '#fff',
          fontWeight: 600,
          padding: '0.75rem',
          borderRadius: '8px',
          border: 'none',
          cursor: isPending ? 'not-allowed' : 'pointer',
          opacity: isPending ? 0.5 : 1,
          fontSize: '1rem',
        }}
      >
        {isPending ? 'Giriş yapılıyor…' : 'Giriş Yap'}
      </button>
    </form>
  )
}
