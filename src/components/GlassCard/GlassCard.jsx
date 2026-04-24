export const GlassCard = ({ children, className = '', style = {} }) => (
  <div
    className={className}
    style={{
      background: 'rgba(42,42,42,0.6)',
      backdropFilter: 'blur(20px)',
      borderRadius: '12px',
      padding: '1.5rem',
      ...style,
    }}
  >
    {children}
  </div>
)
