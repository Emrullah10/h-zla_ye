import { useState, useRef } from 'react'

export const SlideToAccept = ({ onAccept, label = 'Kabul Et' }) => {
  const [pos, setPos] = useState(0)
  const trackRef = useRef(null)
  const MAX = 220

  const onPointerMove = (e) => {
    if (!e.buttons) return
    const rect = trackRef.current.getBoundingClientRect()
    const newPos = Math.min(MAX, Math.max(0, e.clientX - rect.left - 28))
    setPos(newPos)
    if (newPos >= MAX - 4) onAccept?.()
  }

  return (
    <div
      ref={trackRef}
      onPointerMove={onPointerMove}
      onPointerUp={() => setPos(0)}
      style={{
        position: 'relative', height: '3.5rem', width: '100%',
        background: 'var(--surface-container-high)', borderRadius: '9999px', overflow: 'hidden', userSelect: 'none',
      }}
    >
      <div style={{
        position: 'absolute', left: 0, top: 0, height: '100%', borderRadius: '9999px',
        background: 'rgba(255,75,43,0.2)', width: pos + 56, transition: 'none',
      }} />
      <div style={{
        position: 'absolute', top: '4px', left: '4px', width: '3rem', height: '3rem',
        borderRadius: '50%', background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        cursor: 'grab', transform: `translateX(${pos}px)`, transition: 'none',
      }}>
        →
      </div>
      <span style={{
        position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: '0.875rem', color: 'var(--text-secondary)', paddingLeft: '4rem',
      }}>
        {label}
      </span>
    </div>
  )
}
