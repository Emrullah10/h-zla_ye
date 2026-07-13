import { LoginForm } from '@features/auth/components/LoginForm/LoginForm'

const Login = () => (
  <div style={{ minHeight: '100vh', background: 'var(--bg)', display: 'flex' }}>
    <div style={{
      flex: 1, background: 'var(--surface)', alignItems: 'center', justifyContent: 'center',
      display: 'none',
    }}>
      <div style={{ textAlign: 'center' }}>
        <h1 style={{ fontSize: '3rem', fontWeight: 700, color: 'var(--brand)', fontFamily: 'JetBrains Mono, monospace' }}>
          HIZLA YE
        </h1>
        <p style={{ color: 'var(--text-secondary)', marginTop: '0.5rem' }}>Kurye Ekosistemi</p>
      </div>
    </div>
    <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '2rem' }}>
      <div style={{ width: '100%', maxWidth: '24rem' }}>
        <h2 style={{ fontSize: '1.5rem', fontWeight: 600, color: 'var(--text)', marginBottom: '0.5rem' }}>
          Hoş Geldin
        </h2>
        <p style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', marginBottom: '2rem' }}>
          Devam etmek için giriş yap.
        </p>
        <LoginForm />
      </div>
    </div>
  </div>
)

export default Login
