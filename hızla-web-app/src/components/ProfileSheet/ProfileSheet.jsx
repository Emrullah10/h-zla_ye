import { ToggleButtonGroup, ToggleButton } from '@mui/material'
import { useAuthStore } from '@store/authStore'
import { useUIStore } from '@store/uiStore'
import { useLogout } from '@features/auth/hooks/useLogout'

const ROLE_LABELS = { courier: 'Kurye', admin: 'Yönetici' }
const THEME_MODE_LABELS = { system: 'Sistem', light: 'Açık', dark: 'Koyu' }
const MAP_MODE_LABELS = { auto: 'Otomatik', light: 'Açık', dark: 'Koyu' }

export const ProfileSheet = ({ onClose }) => {
  const driver = useAuthStore((s) => s.driver)
  const role = useAuthStore((s) => s.role)
  const themeMode = useUIStore((s) => s.themeMode)
  const setThemeMode = useUIStore((s) => s.setThemeMode)
  const mapMode = useUIStore((s) => s.mapMode)
  const setMapMode = useUIStore((s) => s.setMapMode)
  const { mutate: logout, isPending } = useLogout()

  return (
    <>
      <div
        onClick={onClose}
        style={{
          position: 'fixed', inset: 0,
          background: 'rgba(0,0,0,0.6)', zIndex: 100,
        }}
      />
      <div
        onClick={(e) => e.stopPropagation()}
        style={{
          position: 'fixed', bottom: 0, left: 0, right: 0,
          background: 'var(--surface-container-high)', borderRadius: '16px 16px 0 0',
          padding: '1.25rem 1.5rem 2rem', zIndex: 101,
        }}
      >
        <div style={{
          width: '2.5rem', height: '4px', background: 'rgba(255,255,255,0.15)',
          borderRadius: '2px', margin: '0 auto 1.5rem',
        }} />

        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', marginBottom: '1.25rem' }}>
          <div style={{
            width: '3rem', height: '3rem', borderRadius: '50%',
            background: 'var(--surface-container-high)', display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: '1.25rem', color: 'var(--text)', fontWeight: 600, flexShrink: 0,
          }}>
            {driver?.name?.[0] ?? ROLE_LABELS[role]?.[0] ?? '?'}
          </div>
          <div>
            <p style={{ fontSize: '1.1rem', fontWeight: 600, color: 'var(--text)' }}>
              {driver?.name ?? ROLE_LABELS[role] ?? '—'}
            </p>
            <p style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', marginTop: '2px' }}>
              {ROLE_LABELS[role] ?? role}
            </p>
          </div>
        </div>

        <div style={{ marginBottom: '1.25rem' }}>
          <p style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', marginBottom: '0.5rem' }}>Tema</p>
          <ToggleButtonGroup
            value={themeMode}
            exclusive
            size="small"
            onChange={(_, value) => value && setThemeMode(value)}
            fullWidth
          >
            {Object.entries(THEME_MODE_LABELS).map(([value, label]) => (
              <ToggleButton key={value} value={value}>{label}</ToggleButton>
            ))}
          </ToggleButtonGroup>
        </div>

        <div style={{ marginBottom: '1.25rem' }}>
          <p style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', marginBottom: '0.5rem' }}>Harita</p>
          <ToggleButtonGroup
            value={mapMode}
            exclusive
            size="small"
            onChange={(_, value) => value && setMapMode(value)}
            fullWidth
          >
            {Object.entries(MAP_MODE_LABELS).map(([value, label]) => (
              <ToggleButton key={value} value={value}>{label}</ToggleButton>
            ))}
          </ToggleButtonGroup>
        </div>

        <button
          onClick={() => logout()}
          disabled={isPending}
          style={{
            width: '100%', padding: '0.75rem', borderRadius: '10px',
            background: 'rgba(255,75,43,0.12)', border: '1px solid rgba(255,75,43,0.25)',
            color: 'var(--brand)', fontWeight: 500, fontSize: '0.9rem',
            cursor: isPending ? 'not-allowed' : 'pointer', opacity: isPending ? 0.5 : 1,
          }}
        >
          {isPending ? 'Çıkış yapılıyor…' : 'Çıkış Yap'}
        </button>
      </div>
    </>
  )
}
