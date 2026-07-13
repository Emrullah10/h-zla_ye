import { Outlet } from 'react-router-dom'
import { TopBar } from '@components/TopBar/TopBar'
import { BottomNav } from '@components/BottomNav/BottomNav'

const Main = () => (
  <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', background: 'var(--bg)' }}>
    <TopBar />
    <main style={{ flex: 1, overflowY: 'auto' }}>
      <Outlet />
    </main>
    <BottomNav />
  </div>
)

export default Main
