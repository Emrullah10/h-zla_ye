import { Route } from 'react-router-dom'

export const errorRoutes = (
  <>
    <Route path="/unauthorized" element={<div style={{ padding: '2rem', color: '#e2e2e2' }}>Yetkisiz erişim.</div>} />
    <Route path="*" element={<div style={{ padding: '2rem', color: '#e2e2e2' }}>Sayfa bulunamadı.</div>} />
  </>
)
