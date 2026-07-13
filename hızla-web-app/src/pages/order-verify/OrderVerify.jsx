import { useParams } from 'react-router-dom'
import { QRScanner } from '@components/QRScanner/QRScanner'
import { useVerifyPackage } from '@features/courier/hooks/useVerifyPackage'

const OrderVerify = () => {
  const { id } = useParams()
  const { mutate, isPending, isSuccess } = useVerifyPackage(id)

  if (isSuccess) return (
    <div style={{ height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
      <div style={{ textAlign: 'center' }}>
        <p style={{ fontSize: '4rem', marginBottom: '1rem' }}>✅</p>
        <p style={{ color: 'var(--text)', fontWeight: 600 }}>Paket Doğrulandı</p>
      </div>
    </div>
  )

  return (
    <div style={{ padding: '1rem', display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: 'var(--text)' }}>Paket Doğrulama</h1>
      <QRScanner onScan={(code) => mutate(code)} />
      {isPending && <p style={{ textAlign: 'center', color: 'var(--text-secondary)', fontSize: '0.875rem' }}>Doğrulanıyor…</p>}
    </div>
  )
}

export default OrderVerify
