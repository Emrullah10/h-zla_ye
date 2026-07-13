import { createTheme } from '@mui/material/styles'

// "Kinetic Nocturne" (dark) / "Kinetic Daylight" (light) token tablosu.
// Marka rengi (#FF4B2B) ve gradyanlar her iki temada AYNI kalır.
const tokens = {
  dark: {
    scaffold: '#0e0e0e',
    surface: '#131313',
    surfaceContainer: '#1f1f1f',
    surfaceContainerHigh: '#2a2a2a',
    surfaceContainerHighest: '#353535',
    textPrimary: '#e2e2e2',
    textSecondary: '#9e9e9e',
    textMuted: '#e5bdb6',
    neon: '#00daf3',
    error: '#ffb4ab',
    cardBg: 'rgba(42,42,42,0.6)',
    inputBg: '#2a2a2a',
    glassFill: 'rgba(255,255,255,0.06)',
    glassBorder: 'rgba(255,255,255,0.12)',
  },
  light: {
    scaffold: '#faf7f5',
    surface: '#ffffff',
    surfaceContainer: '#efeae6',
    surfaceContainerHigh: '#e8e2dd',
    surfaceContainerHighest: '#dfd8d2',
    textPrimary: '#1d1b1a',
    textSecondary: '#6e5a54',
    textMuted: '#6e5a54',
    neon: '#0093a6',
    error: '#ba1a1a',
    cardBg: 'rgba(232,226,221,0.6)',
    inputBg: '#e8e2dd',
    glassFill: 'rgba(0,0,0,0.04)',
    glassBorder: 'rgba(0,0,0,0.08)',
  },
}

// Marka/platform renkleri — temadan bağımsız, her iki modda aynı.
const brand = {
  primary: '#FF4B2B',
  primaryDark: '#ff5637',
  gradientStart: '#ffb4a5',
  yemeksepeti: '#EA004B',
  getir: '#5D3EBD',
  trendyol: '#FF6000',
}

export const getTheme = (mode = 'dark') => {
  const t = tokens[mode] ?? tokens.dark

  return createTheme({
    palette: {
      mode,
      primary: { main: brand.primary, dark: brand.primaryDark, light: brand.gradientStart },
      secondary: { main: t.surfaceContainer },
      error: { main: t.error },
      background: { default: t.scaffold, paper: t.surface },
      text: { primary: t.textPrimary, secondary: t.textMuted },
      // Uygulamaya özgü ek token'lar — sx içinde theme.palette.neon vb. ile erişilir.
      neon: { main: t.neon },
      surfaces: {
        container: t.surfaceContainer,
        containerHigh: t.surfaceContainerHigh,
        containerHighest: t.surfaceContainerHighest,
      },
      muted: { main: t.textSecondary },
      glass: { fill: t.glassFill, border: t.glassBorder },
      platform: brand,
    },
    typography: {
      fontFamily: '"Inter", sans-serif',
    },
    shape: { borderRadius: 16 },
    components: {
      MuiCard: {
        styleOverrides: {
          root: {
            background: t.cardBg,
            backdropFilter: 'blur(20px)',
            border: 'none',
            boxShadow: 'none',
          },
        },
      },
      MuiButton: {
        styleOverrides: {
          containedPrimary: {
            background: `linear-gradient(135deg, ${brand.primary}, ${brand.primaryDark})`,
            '&:hover': { background: `linear-gradient(135deg, ${brand.primaryDark}, ${brand.primary})` },
          },
        },
      },
      MuiOutlinedInput: {
        styleOverrides: {
          root: {
            background: t.inputBg,
            '& fieldset': { border: 'none' },
            '&.Mui-focused fieldset': { border: '1px solid rgba(255,75,43,0.2)' },
          },
        },
      },
      MuiBottomNavigation: {
        styleOverrides: {
          root: { background: t.surface },
        },
      },
      MuiAppBar: {
        styleOverrides: {
          root: { background: t.surface, boxShadow: 'none' },
        },
      },
    },
  })
}

// Geriye dönük uyumluluk — yeni kod getTheme(mode) kullanmalı.
export const theme = getTheme('dark')
