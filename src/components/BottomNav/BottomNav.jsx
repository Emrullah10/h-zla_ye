import { NavLink } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

const NAV_ITEMS = [
  { to: Routes.Dashboard, label: 'Ana Sayfa', icon: '🏠' },
  { to: Routes.Wallet,    label: 'Cüzdan',    icon: '💰' },
  { to: Routes.Earnings,  label: 'Kazanç',    icon: '📊' },
  { to: Routes.Quests,    label: 'Görevler',  icon: '🎯' },
  { to: Routes.Support,   label: 'Destek',    icon: '💬' },
]

export const BottomNav = () => (
  <nav style={{ display: 'flex', background: '#131313', borderTop: '1px solid rgba(92,64,58,0.15)' }}>
    {NAV_ITEMS.map(({ to, label, icon }) => (
      <NavLink
        key={to}
        to={to}
        style={({ isActive }) => ({
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          flex: 1,
          padding: '0.5rem 0',
          fontSize: '0.75rem',
          gap: '2px',
          textDecoration: 'none',
          color: isActive ? '#FF4B2B' : '#9e9e9e',
          transition: 'color 0.2s',
        })}
      >
        <span style={{ fontSize: '1.125rem' }}>{icon}</span>
        <span>{label}</span>
      </NavLink>
    ))}
  </nav>
)
