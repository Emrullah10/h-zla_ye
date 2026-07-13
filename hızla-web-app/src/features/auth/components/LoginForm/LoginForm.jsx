import { useState } from 'react'
import { useLogin } from '@features/auth/hooks/useLogin'

export const LoginForm = () => {
  const [phone, setPhone] = useState('+905550000001')
  const [password, setPassword] = useState('admin123')
  const { mutate, isPending, error } = useLogin()

  const onSubmit = (e) => {
    e.preventDefault()
    mutate({ phone, password })
  }

  return (
    <form onSubmit={onSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1rem', width: '100%', maxWidth: '24rem' }}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
        <label style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Telefon
        </label>
        <input
          type="tel"
          value={phone}
          onChange={(e) => setPhone(e.target.value)}
          style={{
            background: 'var(--surface-container-high)', borderRadius: '16px', padding: '0.75rem 1rem',
            color: 'var(--text)', outline: 'none', border: 'none', fontSize: '1rem',
          }}
          placeholder="+905550000002"
          required
        />
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
        <label style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Şifre
        </label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          style={{
            background: 'var(--surface-container-high)', borderRadius: '16px', padding: '0.75rem 1rem',
            color: 'var(--text)', outline: 'none', border: 'none', fontSize: '1rem',
          }}
          placeholder="••••••••"
          required
        />
      </div>
      {error && <p style={{ color: 'var(--error)', fontSize: '0.875rem' }}>{error.message}</p>}
      <button
        type="submit"
        disabled={isPending}
        style={{
          background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))',
          color: 'var(--text)',
          fontWeight: 600,
          padding: '0.75rem',
          borderRadius: '16px',
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
