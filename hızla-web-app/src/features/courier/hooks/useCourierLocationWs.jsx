import { useEffect, useRef, useState } from 'react'
import { API_BASE_URL } from '@shared/constant/api-constant'
import { getLatestLocations } from '@api/courier'

function wsUrl() {
  const httpUrl = new URL(API_BASE_URL)
  const protocol = httpUrl.protocol === 'https:' ? 'wss:' : 'ws:'
  return `${protocol}//${httpUrl.host}/ws/courier`
}

export const useCourierLocationWs = () => {
  const [locations, setLocations] = useState({})
  const reconnectRef = useRef(null)

  useEffect(() => {
    getLatestLocations()
      .then((res) => {
        const initial = {}
        for (const loc of res.data ?? []) {
          initial[loc.courierId] = { lat: loc.lat, lng: loc.lng, at: loc.updatedAt }
        }
        setLocations(initial)
      })
      .catch(() => {})
  }, [])

  useEffect(() => {
    let ws
    let closedByEffect = false
    let attempt = 0

    const connect = () => {
      ws = new WebSocket(wsUrl())
      ws.onmessage = (event) => {
        try {
          const msg = JSON.parse(event.data)
          if (msg.type === 'courier:location') {
            setLocations((prev) => ({
              ...prev,
              [msg.courierId]: { lat: msg.lat, lng: msg.lng, at: msg.at },
            }))
          }
        } catch { /* geçersiz mesaj yok say */ }
      }
      ws.onclose = () => {
        if (closedByEffect) return
        attempt += 1
        const delay = Math.min(1000 * 2 ** attempt, 15000)
        reconnectRef.current = setTimeout(connect, delay)
      }
      ws.onopen = () => { attempt = 0 }
    }

    connect()

    return () => {
      closedByEffect = true
      clearTimeout(reconnectRef.current)
      ws?.close()
    }
  }, [])

  return locations
}
