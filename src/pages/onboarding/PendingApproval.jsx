import { useOnboardingStatus } from '@features/onboarding/hooks/useOnboardingStatus'

const PendingApproval = () => {
  const { data } = useOnboardingStatus()

  return (
    <div style={{
      display: 'flex', flexDirection: 'column', flex: 1,
      alignItems: 'center', justifyContent: 'center',
      padding: '2rem', textAlign: 'center', gap: '1.5rem',
    }}>
      <span style={{ fontSize: '4.5rem' }}>⏳</span>
      <div>
        <h1 style={{ fontSize: '1.5rem', fontWeight: 700, color: '#e2e2e2' }}>Onay Bekleniyor</h1>
        <p style={{ color: '#9e9e9e', marginTop: '0.5rem', fontSize: '0.875rem' }}>
          Belgeleriniz inceleniyor. Genellikle 24 saat içinde sonuçlanır.
        </p>
      </div>
      {data?.submittedAt && (
        <p style={{ fontSize: '0.75rem', color: '#9e9e9e' }}>
          Başvuru tarihi: {new Date(data.submittedAt).toLocaleDateString('tr-TR')}
        </p>
      )}
    </div>
  )
}

export default PendingApproval
