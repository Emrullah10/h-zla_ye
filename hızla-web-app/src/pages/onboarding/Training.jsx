import { TrainingModule } from '@features/onboarding/components/TrainingModule/TrainingModule'

const Training = () => (
  <div style={{ display: 'flex', flexDirection: 'column', flex: 1, overflowY: 'auto' }}>
    <div style={{ padding: '1rem 1rem 0.5rem' }}>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, color: 'var(--text)' }}>Eğitim Modülleri</h1>
      <p style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', marginTop: '4px' }}>Tüm modülleri tamamla.</p>
    </div>
    <TrainingModule />
  </div>
)

export default Training
