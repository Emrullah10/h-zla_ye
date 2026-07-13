const DARK_TILE = 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
const LIGHT_TILE = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png'

/**
 * mapMode ('light' | 'dark' | 'auto') + verilen saate göre CARTO tile URL'i.
 * 'auto': 06:00–19:00 arası açık tile, gece koyu tile (mobil ile aynı kural).
 */
export function resolveTileUrl(mapMode, now = new Date()) {
  if (mapMode === 'light') return LIGHT_TILE
  if (mapMode === 'dark') return DARK_TILE
  const hour = now.getHours()
  const isDaytime = hour >= 6 && hour < 19
  return isDaytime ? LIGHT_TILE : DARK_TILE
}
