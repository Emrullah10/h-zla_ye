import { createTheme } from '@mui/material/styles'

export const theme = createTheme({
  palette: {
    mode: 'dark',
    primary:    { main: '#FF4B2B', dark: '#ff5637', light: '#ffdad3' },
    secondary:  { main: '#1A1A1A' },
    error:      { main: '#ffb4ab' },
    background: { default: '#0e0e0e', paper: '#131313' },
    text:       { primary: '#e2e2e2', secondary: '#e5bdb6' },
  },
  typography: {
    fontFamily: '"Inter", sans-serif',
  },
  shape: { borderRadius: 16 },
  components: {
    MuiCard: {
      styleOverrides: {
        root: {
          background: 'rgba(42,42,42,0.6)',
          backdropFilter: 'blur(20px)',
          border: 'none',
          boxShadow: 'none',
        }
      }
    },
    MuiButton: {
      styleOverrides: {
        containedPrimary: {
          background: 'linear-gradient(135deg, #FF4B2B, #ff5637)',
          '&:hover': { background: 'linear-gradient(135deg, #ff5637, #FF4B2B)' },
        }
      }
    },
    MuiOutlinedInput: {
      styleOverrides: {
        root: {
          background: '#2a2a2a',
          '& fieldset': { border: 'none' },
          '&.Mui-focused fieldset': { border: '1px solid rgba(255,75,43,0.2)' },
        }
      }
    },
    MuiBottomNavigation: {
      styleOverrides: {
        root: { background: '#131313' }
      }
    },
    MuiAppBar: {
      styleOverrides: {
        root: { background: '#131313', boxShadow: 'none' }
      }
    },
  }
})
