import { VehicleSelector } from '@features/onboarding/components/VehicleSelector/VehicleSelector'

const VehicleSelection = () => (
  <div style={{ display: 'flex', flexDirection: 'column', flex: 1, overflowY: 'auto' }}>
    <div style={{ padding: '1rem 1rem 0.5rem' }}>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, color: '#e2e2e2' }}>Araç Türün?</h1>
      <p style={{ color: '#9e9e9e', fontSize: '0.875rem', marginTop: '4px' }}>Teslimat yapacağın araç türünü seç.</p>
    </div>
    <VehicleSelector />
  </div>
)

export default VehicleSelection
