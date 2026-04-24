import { LoginForm } from '@features/auth/components/LoginForm/LoginForm'

const Login = () => (
  <div style={{ minHeight: '100vh', background: '#0e0e0e', display: 'flex' }}>
    <div style={{
      flex: 1, background: '#131313', alignItems: 'center', justifyContent: 'center',
      display: 'none',
    }}>
      <div style={{ textAlign: 'center' }}>
        <h1 style={{ fontSize: '3rem', fontWeight: 700, color: '#FF4B2B', fontFamily: 'JetBrains Mono, monospace' }}>
          HIZLA YE
        </h1>
        <p style={{ color: '#9e9e9e', marginTop: '0.5rem' }}>Kurye Ekosistemi</p>
      </div>
    </div>
    <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '2rem' }}>
      <div style={{ width: '100%', maxWidth: '24rem' }}>
        <h2 style={{ fontSize: '1.5rem', fontWeight: 600, color: '#e2e2e2', marginBottom: '0.5rem' }}>
          Hoş Geldin
        </h2>
        <p style={{ color: '#9e9e9e', fontSize: '0.875rem', marginBottom: '2rem' }}>
          Devam etmek için giriş yap.
        </p>
        <LoginForm />
      </div>
    </div>
  </div>
)

export default Login
