import { useEffect, useMemo } from 'react'
import { ThemeProvider, CssBaseline, useMediaQuery } from '@mui/material'
import { getTheme } from '@shared/theme/theme'
import { QueryProvider } from '@shared/providers/QueryProvider'
import { NotificationProvider } from '@shared/providers/NotificationProvider'
import { useUIStore } from '../store/uiStore'

export const Container = ({ children }) => {
  const themeMode = useUIStore((s) => s.themeMode)
  const prefersDark = useMediaQuery('(prefers-color-scheme: dark)')
  const resolvedMode = themeMode === 'system' ? (prefersDark ? 'dark' : 'light') : themeMode
  const theme = useMemo(() => getTheme(resolvedMode), [resolvedMode])

  useEffect(() => {
    document.documentElement.dataset.theme = resolvedMode
  }, [resolvedMode])

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <QueryProvider>
        <NotificationProvider>
          {children}
        </NotificationProvider>
      </QueryProvider>
    </ThemeProvider>
  )
}
