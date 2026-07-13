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
        <h1 style={{ fontSize: '1.5rem', fontWeight: 700, color: 'var(--text)' }}>Onay Bekleniyor</h1>
        <p style={{ color: 'var(--text-secondary)', marginTop: '0.5rem', fontSize: '0.875rem' }}>
          Belgeleriniz inceleniyor. Genellikle 24 saat içinde sonuçlanır.
        </p>
      </div>
      {data?.submittedAt && (
        <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>
          Başvuru tarihi: {new Date(data.submittedAt).toLocaleDateString('tr-TR')}
        </p>
      )}
    </div>
  )
}

export default PendingApproval
