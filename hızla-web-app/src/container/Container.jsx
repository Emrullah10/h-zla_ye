import { ThemeProvider, CssBaseline } from '@mui/material'
import { theme } from '@shared/theme/theme'
import { QueryProvider } from '@shared/providers/QueryProvider'
import { NotificationProvider } from '@shared/providers/NotificationProvider'

export const Container = ({ children }) => (
  <ThemeProvider theme={theme}>
    <CssBaseline />
    <QueryProvider>
      <NotificationProvider>
        {children}
      </NotificationProvider>
    </QueryProvider>
  </ThemeProvider>
)
