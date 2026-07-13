import { useEffect, useRef } from 'react'
import { useUIStore } from '../../store/uiStore'
import { resolveTileUrl } from '@shared/map/tileUrl'

const ICON_COLORS = { courier: 'var(--neon)', pickup: 'var(--brand)', delivery: 'var(--success)' }

export const MapView = ({ center = [41.015, 28.979], zoom = 14, className = '', style = {}, markers = [], polyline = null }) => {
  const containerRef = useRef(null)
  const mapRef = useRef(null)
  const leafletRef = useRef(null)
  const tileLayerRef = useRef(null)
  const markerLayerRef = useRef(null)
  const polylineLayerRef = useRef(null)
  const hasCenteredRef = useRef(false)
  const mapMode = useUIStore((s) => s.mapMode)

  useEffect(() => {
    let cancelled = false
    const init = async () => {
      const L = (await import('leaflet')).default
      await import('leaflet/dist/leaflet.css')
      if (cancelled || mapRef.current || !containerRef.current) return
      const map = L.map(containerRef.current, { center, zoom, zoomControl: false })
      tileLayerRef.current = L.tileLayer(resolveTileUrl(mapMode), {
        attribution: '&copy; OpenStreetMap &copy; CARTO'
      }).addTo(map)
      mapRef.current = map
      leafletRef.current = L
      markerLayerRef.current = L.layerGroup().addTo(map)
      polylineLayerRef.current = L.layerGroup().addTo(map)
    }
    init()
    return () => {
      cancelled = true
      mapRef.current?.remove()
      mapRef.current = null
    }
  }, [])

  useEffect(() => {
    tileLayerRef.current?.setUrl(resolveTileUrl(mapMode))
  }, [mapMode])

  useEffect(() => {
    const L = leafletRef.current
    const map = mapRef.current
    const markerLayer = markerLayerRef.current
    const polylineLayer = polylineLayerRef.current
    if (!L || !map || !markerLayer || !polylineLayer) return

    markerLayer.clearLayers()
    polylineLayer.clearLayers()

    for (const m of markers) {
      if (typeof m.lat !== 'number' || typeof m.lng !== 'number') continue
      const color = ICON_COLORS[m.type] || 'var(--text)'
      const icon = L.divIcon({
        className: '',
        html: `<div style="width:14px;height:14px;border-radius:50%;background:${color};box-shadow:0 0 8px ${color}"></div>`,
        iconSize: [14, 14],
        iconAnchor: [7, 7],
      })
      L.marker([m.lat, m.lng], { icon }).addTo(markerLayer)
    }

    if (Array.isArray(polyline) && polyline.length > 1) {
      L.polyline(polyline, { color: 'var(--brand)', weight: 3, opacity: 0.8 }).addTo(polylineLayer)
    }

    const courierMarker = markers.find((m) => m.type === 'courier')
    if (courierMarker && !hasCenteredRef.current) {
      map.setView([courierMarker.lat, courierMarker.lng], zoom)
      hasCenteredRef.current = true
    } else if (courierMarker) {
      map.panTo([courierMarker.lat, courierMarker.lng])
    }
  }, [markers, polyline])

  return <div ref={containerRef} className={className} style={{ width: '100%', height: '100%', ...style }} />
}
