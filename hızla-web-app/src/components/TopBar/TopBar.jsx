import { useState } from 'react'
import { useAuthStore } from '@store/authStore'
import { ProfileSheet } from '@components/ProfileSheet/ProfileSheet'

export const TopBar = () => {
  const driver = useAuthStore((s) => s.driver)
  const role = useAuthStore((s) => s.role)
  const [open, setOpen] = useState(false)

  return (
    <>
      <header style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '0.75rem 1rem',
        background: '#131313',
      }}>
        <span style={{ fontSize: '0.75rem', color: '#9e9e9e', letterSpacing: '0.1em', textTransform: 'uppercase' }}>
          Hızla Ye
        </span>
        <div
          role="button"
          aria-label="Profil"
          onClick={() => setOpen(true)}
          style={{
            width: '2rem', height: '2rem', borderRadius: '50%',
            background: '#2a2a2a', display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: '0.75rem', color: '#e2e2e2', cursor: 'pointer',
          }}
        >
          {driver?.name?.[0] ?? (role === 'admin' ? 'Y' : '?')}
        </div>
      </header>
      {open && <ProfileSheet onClose={() => setOpen(false)} />}
    </>
  )
}
