import { Outlet, useLocation } from 'react-router-dom'

const STEPS = [
  '/onboarding/vehicle',
  '/onboarding/documents',
  '/onboarding/training',
  '/onboarding/pending',
]

const OnboardingLayout = () => {
  const { pathname } = useLocation()
  const currentStep = STEPS.indexOf(pathname)

  return (
    <div style={{ minHeight: '100vh', background: '#0e0e0e', display: 'flex', flexDirection: 'column' }}>
      <div style={{ display: 'flex', gap: '4px', padding: '1rem' }}>
        {STEPS.map((_, i) => (
          <div
            key={i}
            style={{
              height: '4px',
              flex: 1,
              borderRadius: '2px',
              background: i <= currentStep ? '#FF4B2B' : '#353535',
              transition: 'background 0.3s',
            }}
          />
        ))}
      </div>
      <Outlet />
    </div>
  )
}

export default OnboardingLayout
