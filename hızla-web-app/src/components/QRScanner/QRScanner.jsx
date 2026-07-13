import { useEffect, useRef, useState } from 'react'
import jsQR from 'jsqr'

export const QRScanner = ({ onScan }) => {
  const videoRef = useRef(null)
  const canvasRef = useRef(null)
  const rafRef = useRef(null)
  const scannedRef = useRef(false)
  const [error, setError] = useState(null)
  const [manualCode, setManualCode] = useState('')
  const [showManualInput, setShowManualInput] = useState(false)

  useEffect(() => {
    let stream = null

    const scanFrame = () => {
      const video = videoRef.current
      const canvas = canvasRef.current
      if (!video || !canvas || scannedRef.current) return

      if (video.readyState === video.HAVE_ENOUGH_DATA) {
        canvas.width = video.videoWidth
        canvas.height = video.videoHeight
        const ctx = canvas.getContext('2d')
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height)
        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)
        const code = jsQR(imageData.data, imageData.width, imageData.height, {
          inversionAttempts: 'dontInvert',
        })

        if (code?.data) {
          scannedRef.current = true
          onScan?.(code.data)
          return
        }
      }

      rafRef.current = requestAnimationFrame(scanFrame)
    }

    navigator.mediaDevices?.getUserMedia({ video: { facingMode: 'environment' } })
      .then((s) => {
        stream = s
        if (videoRef.current) {
          videoRef.current.srcObject = s
          videoRef.current.onloadedmetadata = () => videoRef.current?.play()
        }
        rafRef.current = requestAnimationFrame(scanFrame)
      })
      .catch((err) => {
        console.error(err)
        setError('Kameraya erişilemedi. Lütfen izin verin veya manuel giriş yapın.')
      })

    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current)
      stream?.getTracks().forEach((t) => t.stop())
    }
  }, [onScan])

  const handleManualSubmit = () => {
    const trimmed = manualCode.trim()
    if (!trimmed) return
    scannedRef.current = true
    onScan?.(trimmed)
  }

  return (
    <div style={{ position: 'relative', width: '100%', aspectRatio: '1', background: 'var(--surface-container)', borderRadius: '16px', overflow: 'hidden' }}>
      <video ref={videoRef} autoPlay playsInline muted style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
      <canvas ref={canvasRef} style={{ display: 'none' }} />
      <div style={{
        position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <div style={{
          width: '12rem', height: '12rem', border: '2px solid var(--neon)', borderRadius: '16px',
          boxShadow: '0 0 20px rgba(0,218,243,0.3)',
        }} />
      </div>

      {error && (
        <div style={{
          position: 'absolute', top: '0.5rem', left: '0.5rem', right: '0.5rem',
          padding: '0.5rem', background: 'rgba(255,75,43,0.9)', color: 'var(--text)',
          borderRadius: '16px', fontSize: '0.75rem', textAlign: 'center',
        }}>
          {error}
        </div>
      )}

      {showManualInput ? (
        <div style={{
          position: 'absolute', bottom: '1rem', left: '50%', transform: 'translateX(-50%)',
          display: 'flex', gap: '0.5rem', width: '90%',
        }}>
          <input
            type="text"
            value={manualCode}
            onChange={(e) => setManualCode(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleManualSubmit()}
            placeholder="QR kodu girin"
            autoFocus
            style={{
              flex: 1, padding: '0.5rem 0.75rem', borderRadius: '9999px',
              border: '1px solid var(--neon)', background: '#111', color: 'var(--text)', fontSize: '0.875rem',
            }}
          />
          <button
            onClick={handleManualSubmit}
            style={{
              padding: '0.5rem 1.25rem', background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))', color: 'var(--text)',
              borderRadius: '9999px', border: 'none', fontSize: '0.875rem', cursor: 'pointer',
            }}
          >
            Onayla
          </button>
        </div>
      ) : (
        <button
          onClick={() => setShowManualInput(true)}
          style={{
            position: 'absolute', bottom: '1rem', left: '50%', transform: 'translateX(-50%)',
            padding: '0.5rem 1.5rem', background: 'linear-gradient(135deg, var(--brand), var(--brand-dark))', color: 'var(--text)',
            borderRadius: '9999px', border: 'none', fontSize: '0.875rem', cursor: 'pointer',
          }}
        >
          Manuel Giriş
        </button>
      )}
    </div>
  )
}
