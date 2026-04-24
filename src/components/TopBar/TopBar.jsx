import { useAuthStore } from '@store/authStore'

export const TopBar = () => {
  const driver = useAuthStore((s) => s.driver)
  return (
    <header style={{
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0.75rem 1rem',
      background: '#131313',
      borderBottom: '1px solid rgba(92,64,58,0.15)',
    }}>
      <span style={{ fontSize: '0.75rem', color: '#9e9e9e', letterSpacing: '0.1em', textTransform: 'uppercase' }}>
        Hızla Ye
      </span>
      <div style={{
        width: '2rem', height: '2rem', borderRadius: '50%',
        background: '#2a2a2a', display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: '0.75rem', color: '#e2e2e2',
      }}>
        {driver?.name?.[0] ?? '?'}
      </div>
    </header>
  )
}
