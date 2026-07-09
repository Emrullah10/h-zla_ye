export const CountdownBorder = ({ children, active = false }) => (
  <div style={{
    borderRadius: '12px',
    boxShadow: active ? '0 0 0 2px #FF4B2B, 0 0 20px rgba(255,75,43,0.3)' : 'none',
    animation: active ? 'pulse 1.5s ease-in-out infinite' : 'none',
  }}>
    {children}
  </div>
)
