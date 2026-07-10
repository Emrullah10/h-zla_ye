import { Route } from 'react-router-dom'
import { ErrorPage } from '@components/ErrorPage/ErrorPage'

export const errorRoutes = (
  <>
    <Route
      path="/unauthorized"
      element={
        <ErrorPage
          code="401"
          title="Yetkisiz Erişim"
          description="Bu sayfayı görüntülemek için gerekli izne sahip değilsiniz."
        />
      }
    />
    <Route
      path="*"
      element={
        <ErrorPage
          code="404"
          title="Sayfa Bulunamadı"
          description="Aradığınız sayfa taşınmış veya hiç var olmamış olabilir."
        />
      }
    />
  </>
)
