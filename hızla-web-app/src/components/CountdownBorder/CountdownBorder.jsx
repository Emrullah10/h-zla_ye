export const CountdownBorder = ({ children, active = false }) => (
  <div style={{
    borderRadius: '16px',
    boxShadow: active ? '0 0 0 2px var(--brand), 0 0 20px rgba(255,75,43,0.3)' : 'none',
    animation: active ? 'pulse 1.5s ease-in-out infinite' : 'none',
  }}>
    {children}
  </div>
)
