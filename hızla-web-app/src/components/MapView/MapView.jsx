import { useEffect, useRef } from 'react'

export const MapView = ({ center = [41.015, 28.979], zoom = 14, className = '', style = {} }) => {
  const containerRef = useRef(null)
  const mapRef = useRef(null)

  useEffect(() => {
    let map = null
    const init = async () => {
      const L = (await import('leaflet')).default
      await import('leaflet/dist/leaflet.css')
      if (mapRef.current || !containerRef.current) return
      map = L.map(containerRef.current, { center, zoom, zoomControl: false })
      L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
        attribution: '&copy; OpenStreetMap &copy; CARTO'
      }).addTo(map)
      mapRef.current = map
    }
    init()
    return () => {
      mapRef.current?.remove()
      mapRef.current = null
    }
  }, [])

  return <div ref={containerRef} className={className} style={{ width: '100%', height: '100%', ...style }} />
}
