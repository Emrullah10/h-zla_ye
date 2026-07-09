import { useEffect, useRef } from 'react'

export const QRScanner = ({ onScan }) => {
  const videoRef = useRef(null)

  useEffect(() => {
    let stream = null
    navigator.mediaDevices?.getUserMedia({ video: { facingMode: 'environment' } })
      .then((s) => {
        stream = s
        if (videoRef.current) videoRef.current.srcObject = s
      })
      .catch(console.error)
    return () => stream?.getTracks().forEach((t) => t.stop())
  }, [])

  return (
    <div style={{ position: 'relative', width: '100%', aspectRatio: '1', background: '#1f1f1f', borderRadius: '12px', overflow: 'hidden' }}>
      <video ref={videoRef} autoPlay playsInline style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
      <div style={{
        position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <div style={{
          width: '12rem', height: '12rem', border: '2px solid #00daf3', borderRadius: '12px',
          boxShadow: '0 0 20px rgba(0,218,243,0.3)',
        }} />
      </div>
      <button
        onClick={() => onScan?.('mock-qr-code')}
        style={{
          position: 'absolute', bottom: '1rem', left: '50%', transform: 'translateX(-50%)',
          padding: '0.5rem 1.5rem', background: '#FF4B2B', color: '#fff',
          borderRadius: '9999px', border: 'none', fontSize: '0.875rem', cursor: 'pointer',
        }}
      >
        Manuel Giriş
      </button>
    </div>
  )
}
