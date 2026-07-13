import { AdminStats } from '@features/admin/components/AdminStats/AdminStats'
import { DriverList } from '@features/admin/components/DriverList/DriverList'

const Admin = () => (
  <div style={{ minHeight: '100%', background: 'var(--bg)', overflowY: 'auto' }}>
    <div style={{ padding: '1rem' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: 'var(--text)' }}>Yönetici Paneli</h1>
    </div>
    <AdminStats />
    <div style={{ padding: '1rem 1rem 0' }}>
      <h2 style={{ fontSize: '1rem', fontWeight: 600, color: 'var(--text)', marginBottom: '0.75rem' }}>
        Sürücü Başvuruları
      </h2>
    </div>
    <div style={{ padding: '0 1rem 1rem' }}>
      <DriverList />
    </div>
  </div>
)

export default Admin
