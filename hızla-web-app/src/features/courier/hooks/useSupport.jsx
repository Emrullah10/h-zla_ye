import { useMutation } from '@tanstack/react-query'
import { createSupportTicket } from '@api/courier'
import { useNotification } from '@shared/providers/NotificationProvider'

export const useSupport = () => {
  const { showSuccess, showError } = useNotification()
  return useMutation({
    mutationFn: createSupportTicket,
    onSuccess: () => showSuccess('Talebiniz iletildi.'),
    onError: () => showError('Bir hata oluştu.'),
  })
}
