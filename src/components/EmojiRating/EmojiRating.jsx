import { useState } from 'react'

const EMOJIS = ['😡', '😕', '😐', '😊', '🤩']

export const EmojiRating = ({ onRate }) => {
  const [selected, setSelected] = useState(null)

  const handleSelect = (index) => {
    setSelected(index)
    onRate?.(index + 1)
  }

  return (
    <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem' }}>
      {EMOJIS.map((emoji, i) => (
        <button
          key={i}
          onClick={() => handleSelect(i)}
          style={{
            fontSize: '2.5rem',
            background: 'none',
            border: 'none',
            cursor: 'pointer',
            transform: selected === i ? 'scale(1.25)' : 'scale(1)',
            opacity: selected === null || selected === i ? 1 : 0.4,
            transition: 'all 0.2s',
          }}
        >
          {emoji}
        </button>
      ))}
    </div>
  )
}
