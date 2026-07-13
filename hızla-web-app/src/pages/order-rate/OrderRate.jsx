import { useParams } from 'react-router-dom'
import { useState } from 'react'
import { EmojiRating } from '@components/EmojiRating/EmojiRating'
import { useRateRestaurant } from '@features/courier/hooks/useRateRestaurant'

const OrderRate = () => {
  const { id } = useParams()
  const [rating, setRating] = useState(null)
  const { mutate, isPending } = useRateRestaurant(id)

  return (
    <div style={{ padding: '2rem', display: 'flex', flexDirection: 'column', gap: '2rem', alignItems: 'center' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: 'var(--text)', textAlign: 'center' }}>
        Restoranı Değerlendir
      </h1>
      <EmojiRating onRate={setRating} />
      {rating && (
        <button
          onClick={() => mutate({ rating })}
          disabled={isPending}
          style={{
            width: '100%', maxWidth: '20rem', padding: '0.75rem',
            background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))',
            color: 'var(--text)', border: 'none', borderRadius: '16px',
            fontWeight: 600, fontSize: '1rem', cursor: isPending ? 'not-allowed' : 'pointer',
            opacity: isPending ? 0.5 : 1,
          }}
        >
          {isPending ? 'Gönderiliyor…' : 'Gönder'}
        </button>
      )}
    </div>
  )
}

export default OrderRate
