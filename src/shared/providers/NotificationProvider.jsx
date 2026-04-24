import { createContext, useContext, useState, useCallback } from 'react'

const NotificationContext = createContext(null)

export const NotificationProvider = ({ children }) => {
  const [notifications, setNotifications] = useState([])

  const show = useCallback((message, type = 'info') => {
    const id = Date.now()
    setNotifications(prev => [...prev, { id, message, type }])
    setTimeout(() => setNotifications(prev => prev.filter(n => n.id !== id)), 3000)
  }, [])

  const showSuccess = useCallback((msg) => show(msg, 'success'), [show])
  const showError = useCallback((msg) => show(msg, 'error'), [show])

  return (
    <NotificationContext.Provider value={{ showSuccess, showError, notifications }}>
      {children}
    </NotificationContext.Provider>
  )
}

export const useNotification = () => useContext(NotificationContext)
