# Hızla Ye Web App — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `hızla-web-app` klasörü altında Hızla Ye kurye dashboard'unu, WEB-APPARCHITECTURE.md'deki tüm prensipleri (feature-based mimari, DDD katmanları, TDD) eksiksiz uygulayarak 14 Stitch ekranını React SPA olarak implemente etmek.

**Architecture:** Feature-based (iam → courier, onboarding, admin), Zustand global state, TanStack Query veri katmanı, React Router v7 korumalı route'lar. WEB-APPARCHITECTURE.md'deki dosya/klasör yapısı birebir kopyalanır; sadece domain değişir.

**Tech Stack:** React 19, Vite, React Router v7, TanStack Query v5, Zustand v5, MUI v6 (Kinetic Nocturne teması ThemeProvider'da tanımlı), Vitest + Testing Library, Leaflet (harita)

---

## Ekran Kataloğu (14 Stitch Ekranı)

| # | Başlık | Route | Feature |
|---|--------|-------|---------|
| 1 | Giriş Ekranı (Login) | `/login` | auth |
| 2 | Dashboard & Map | `/dashboard` | courier |
| 3 | Incoming Order Card | `/dashboard` (overlay) | courier |
| 4 | Hakediş ve Cüzdan Detayı | `/wallet` | courier |
| 5 | Earnings & Analytics | `/earnings` | courier |
| 6 | Quests & Perks | `/quests` | courier |
| 7 | Paket Doğrulama & QR | `/order/:id/verify` | courier |
| 8 | Restoran Puanlama (Emoji) | `/order/:id/rate` | courier |
| 9 | Destek Merkezi (Support Hub) | `/support` | courier |
| 10 | Sürücü Ol - Araç Seçimi | `/onboarding/vehicle` | onboarding |
| 11 | Sürücü Ol - Belge Yükleme | `/onboarding/documents` | onboarding |
| 12 | Sürücü Ol - Eğitim | `/onboarding/training` | onboarding |
| 13 | Sürücü Ol - Onay Bekliyor | `/onboarding/pending` | onboarding |
| 14 | Yönetici (Admin) Paneli | `/admin` | admin |

---

## Dosya Yapısı

```
hızla-web-app/
├── index.html
├── vite.config.js            ← path aliases: @components, @pages, @hooks, @features, @store
├── package.json
├── tailwind.config.js        ← Kinetic Nocturne token'ları (primary: #FF4B2B, surface: #131313)
├── vitest.config.js
└── src/
    ├── main.jsx              ← createRoot → Container → App
    ├── container/
    │   └── Container.jsx     ← tüm Provider'ları sarar
    ├── shared/
    │   ├── axios/
    │   │   └── axios.jsx     ← JWT refresh interceptor
    │   ├── constant/
    │   │   ├── api-constant.js
    │   │   └── route-paths.js
    │   ├── providers/
    │   │   ├── QueryProvider.jsx
    │   │   └── NotificationProvider.jsx
    │   └── utils/
    │       └── formatters.js
    ├── store/
    │   ├── index.jsx
    │   ├── authStore.jsx      ← token, driverStatus, isOnline
    │   ├── uiStore.jsx        ← sidebar open/close, loading
    │   └── slices/
    │       ├── orderSlice.jsx ← aktif sipariş state
    │       └── modalSlice.jsx
    ├── router/
    │   ├── App.jsx
    │   ├── routeUtils/
    │   │   ├── ProtectedRoute.jsx
    │   │   └── OnboardingGuard.jsx  ← onboarding tamamlandı mı?
    │   └── routes/
    │       ├── publicRoutes.jsx
    │       ├── protectedRoutes.jsx
    │       └── errorRoutes.jsx
    ├── layouts/
    │   ├── Main/
    │   │   ├── Main.jsx       ← TopBar + BottomNav + <Outlet />
    │   │   └── Main.module.css
    │   └── Onboarding/
    │       ├── Onboarding.jsx ← progress stepper + <Outlet />
    │       └── Onboarding.module.css
    ├── components/            ← paylaşılan UI (iş mantığı yok)
    │   ├── TopBar/
    │   │   └── TopBar.jsx
    │   ├── BottomNav/
    │   │   └── BottomNav.jsx
    │   ├── GlassCard/
    │   │   └── GlassCard.jsx  ← glassmorphic kart (backdrop-blur)
    │   ├── SlideToAccept/
    │   │   └── SlideToAccept.jsx
    │   ├── OrderCard/
    │   │   └── OrderCard.jsx
    │   ├── MapView/
    │   │   └── MapView.jsx    ← Leaflet wrapper
    │   ├── QRScanner/
    │   │   └── QRScanner.jsx
    │   ├── EmojiRating/
    │   │   └── EmojiRating.jsx
    │   ├── CountdownBorder/
    │   │   └── CountdownBorder.jsx  ← glowing timer border
    │   ├── Loading/
    │   │   └── Loading.jsx
    │   └── Notification/
    │       └── Notification.jsx
    ├── features/
    │   ├── auth/
    │   │   ├── components/
    │   │   │   └── LoginForm/
    │   │   │       └── LoginForm.jsx
    │   │   └── hooks/
    │   │       ├── useLogin.jsx      ← useMutation
    │   │       └── useLogout.jsx
    │   ├── courier/
    │   │   ├── components/
    │   │   │   ├── DashboardMap/
    │   │   │   │   └── DashboardMap.jsx
    │   │   │   ├── IncomingOrderOverlay/
    │   │   │   │   └── IncomingOrderOverlay.jsx
    │   │   │   ├── WalletSummary/
    │   │   │   │   └── WalletSummary.jsx
    │   │   │   ├── EarningsChart/
    │   │   │   │   └── EarningsChart.jsx
    │   │   │   ├── QuestList/
    │   │   │   │   └── QuestList.jsx
    │   │   │   └── SupportTicketForm/
    │   │   │       └── SupportTicketForm.jsx
    │   │   └── hooks/
    │   │       ├── useActiveOrder.jsx     ← useQuery: aktif sipariş
    │   │       ├── useAcceptOrder.jsx     ← useMutation
    │   │       ├── useRejectOrder.jsx     ← useMutation
    │   │       ├── useVerifyPackage.jsx   ← useMutation: QR doğrulama
    │   │       ├── useRateRestaurant.jsx  ← useMutation
    │   │       ├── useWallet.jsx          ← useQuery: cüzdan
    │   │       ├── useEarnings.jsx        ← useQuery: kazanç analitik
    │   │       ├── useQuests.jsx          ← useQuery: görevler
    │   │       └── useSupport.jsx         ← useMutation: destek talebi
    │   ├── onboarding/
    │   │   ├── components/
    │   │   │   ├── VehicleSelector/
    │   │   │   │   └── VehicleSelector.jsx
    │   │   │   ├── DocumentUploader/
    │   │   │   │   └── DocumentUploader.jsx
    │   │   │   └── TrainingModule/
    │   │   │       └── TrainingModule.jsx
    │   │   └── hooks/
    │   │       ├── useOnboardingStatus.jsx  ← useQuery
    │   │       ├── useSelectVehicle.jsx     ← useMutation
    │   │       ├── useUploadDocument.jsx    ← useMutation
    │   │       └── useCompleteTraining.jsx  ← useMutation
    │   └── admin/
    │       ├── components/
    │       │   └── AdminStats/
    │       │       └── AdminStats.jsx
    │       └── hooks/
    │           └── useAdminDashboard.jsx    ← useQuery
    ├── api/
    │   ├── index.jsx           ← barrel export
    │   ├── auth.jsx            ← login, logout, refresh
    │   ├── courier.jsx         ← orders, wallet, earnings, quests, support
    │   ├── onboarding.jsx      ← vehicle, documents, training, status
    │   └── admin.jsx           ← admin dashboard metrics
    └── pages/
        ├── login/
        │   └── Login.jsx
        ├── dashboard/
        │   └── Dashboard.jsx
        ├── wallet/
        │   └── Wallet.jsx
        ├── earnings/
        │   └── Earnings.jsx
        ├── quests/
        │   └── Quests.jsx
        ├── order-verify/
        │   └── OrderVerify.jsx
        ├── order-rate/
        │   └── OrderRate.jsx
        ├── support/
        │   └── Support.jsx
        ├── onboarding/
        │   ├── VehicleSelection.jsx
        │   ├── DocumentUpload.jsx
        │   ├── Training.jsx
        │   └── PendingApproval.jsx
        └── admin/
            └── Admin.jsx
```

---

## Tasarım Token'ları (Kinetic Nocturne — MUI Theme)

```js
// src/shared/theme/theme.js
import { createTheme } from '@mui/material/styles'

export const theme = createTheme({
  palette: {
    mode: 'dark',
    primary:   { main: '#FF4B2B', dark: '#ff5637', light: '#ffdad3' },
    secondary: { main: '#1A1A1A' },
    error:     { main: '#ffb4ab' },
    background: { default: '#0e0e0e', paper: '#131313' },
    text:      { primary: '#e2e2e2', secondary: '#e5bdb6' },
    // Custom token'lar sx prop'unda theme.palette.surface.high gibi erişilir
    surface: {
      lowest: '#0e0e0e', default: '#131313', low: '#1b1b1b',
      container: '#1f1f1f', high: '#2a2a2a', highest: '#353535',
    },
    tertiary: { main: '#00daf3' },  // harita / GPS neon
  },
  typography: {
    fontFamily: '"Inter", sans-serif',
    // Sayısal değerler için fontFamily override — component bazlı uygulanır
  },
  shape: { borderRadius: 8 },
  components: {
    MuiCard: {
      styleOverrides: {
        root: {
          background: 'rgba(42,42,42,0.6)',
          backdropFilter: 'blur(20px)',
          border: 'none',
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
  }
})
```

---

## Task 1: Proje İskeleti ve Temel Konfigürasyon

**Files:**
- Create: `hızla-web-app/package.json`
- Create: `hızla-web-app/vite.config.js`
- Create: `hızla-web-app/src/shared/theme/theme.js`
- Create: `hızla-web-app/vitest.config.js`
- Create: `hızla-web-app/index.html`

- [ ] **Step 1: Klasörü oluştur ve package.json yaz**

```bash
mkdir -p /Users/emrullah/developer/fullStack/hızla_ye/hızla-web-app/src
cd /Users/emrullah/developer/fullStack/hızla_ye/hızla-web-app
```

`package.json`:
```json
{
  "name": "hizla-web-app",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "test": "vitest",
    "test:ui": "vitest --ui",
    "lint": "eslint src"
  },
  "dependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "react-router-dom": "^7.0.0",
    "@tanstack/react-query": "^5.0.0",
    "zustand": "^5.0.0",
    "axios": "^1.6.0",
    "leaflet": "^1.9.0",
    "react-leaflet": "^4.2.0",
    "@mui/material": "^6.0.0",
    "@mui/icons-material": "^6.0.0",
    "@emotion/react": "^11.0.0",
    "@emotion/styled": "^11.0.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.0.0",
    "vite": "^5.0.0",
    "vitest": "^1.0.0",
    "@vitest/ui": "^1.0.0",
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.0.0",
    "@testing-library/user-event": "^14.0.0",
    "jsdom": "^24.0.0"
  }
}
```

- [ ] **Step 2: npm install çalıştır**

```bash
cd /Users/emrullah/developer/fullStack/hızla_ye/hızla-web-app && npm install
```

- [ ] **Step 3: vite.config.js yaz**

```js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@components': path.resolve(__dirname, 'src/components'),
      '@pages': path.resolve(__dirname, 'src/pages'),
      '@hooks': path.resolve(__dirname, 'src/hooks'),
      '@features': path.resolve(__dirname, 'src/features'),
      '@store': path.resolve(__dirname, 'src/store'),
      '@shared': path.resolve(__dirname, 'src/shared'),
      '@api': path.resolve(__dirname, 'src/api'),
    }
  }
})
```

- [ ] **Step 4: src/shared/theme/theme.js yaz (Kinetic Nocturne MUI teması)**

```js
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
  shape: { borderRadius: 8 },
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
        root: { background: '#131313', borderTop: '1px solid rgba(92,64,58,0.15)' }
      }
    },
    MuiAppBar: {
      styleOverrides: {
        root: { background: '#131313', boxShadow: 'none', borderBottom: '1px solid rgba(92,64,58,0.15)' }
      }
    },
  }
})
```

- [ ] **Step 5: vitest.config.js yaz**

```js
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './src/test-setup.js',
  },
  resolve: {
    alias: {
      '@components': path.resolve(__dirname, 'src/components'),
      '@pages': path.resolve(__dirname, 'src/pages'),
      '@hooks': path.resolve(__dirname, 'src/hooks'),
      '@features': path.resolve(__dirname, 'src/features'),
      '@store': path.resolve(__dirname, 'src/store'),
      '@shared': path.resolve(__dirname, 'src/shared'),
      '@api': path.resolve(__dirname, 'src/api'),
    }
  }
})
```

- [ ] **Step 6: index.html ve test-setup yaz**

`index.html`:
```html
<!DOCTYPE html>
<html lang="tr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hızla Ye — Kurye Paneli</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;600&family=Space+Grotesk:wght@400;500&display=swap" rel="stylesheet" />
  </head>
  <body class="bg-surface text-on-surface">
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
```

`src/test-setup.js`:
```js
import '@testing-library/jest-dom'
```

- [ ] **Step 7: Commit**

```bash
git init
git add .
git commit -m "feat: hızla-web-app proje iskeleti ve konfigürasyon"
```

---

## Task 2: Shared Altyapı (axios, providers, constants)

**Files:**
- Create: `src/shared/axios/axios.jsx`
- Create: `src/shared/constant/route-paths.js`
- Create: `src/shared/constant/api-constant.js`
- Create: `src/shared/providers/QueryProvider.jsx`
- Create: `src/shared/providers/NotificationProvider.jsx`
- Create: `src/shared/utils/formatters.js`

- [ ] **Step 1: Failing test yaz — route-paths**

`src/shared/constant/__tests__/route-paths.test.js`:
```js
import { Routes } from '../route-paths'

test('Routes.Login returns /login', () => {
  expect(Routes.Login).toBe('/login')
})

test('Routes.Dashboard returns /dashboard', () => {
  expect(Routes.Dashboard).toBe('/dashboard')
})

test('Routes.OrderVerify returns function that builds path', () => {
  expect(Routes.OrderVerify('abc123')).toBe('/order/abc123/verify')
})
```

- [ ] **Step 2: Test'i çalıştır — FAIL bekle**

```bash
cd /Users/emrullah/developer/fullStack/hızla_ye/hızla-web-app && npx vitest run src/shared/constant/__tests__/route-paths.test.js
```
Beklenen: FAIL — "Cannot find module"

- [ ] **Step 3: route-paths.js yaz**

```js
export const Routes = {
  Login: '/login',
  Dashboard: '/dashboard',
  Wallet: '/wallet',
  Earnings: '/earnings',
  Quests: '/quests',
  OrderVerify: (id) => `/order/${id}/verify`,
  OrderRate: (id) => `/order/${id}/rate`,
  Support: '/support',
  OnboardingVehicle: '/onboarding/vehicle',
  OnboardingDocuments: '/onboarding/documents',
  OnboardingTraining: '/onboarding/training',
  OnboardingPending: '/onboarding/pending',
  Admin: '/admin',
  Unauthorized: '/unauthorized',
}
```

- [ ] **Step 4: Test'i çalıştır — PASS bekle**

```bash
npx vitest run src/shared/constant/__tests__/route-paths.test.js
```
Beklenen: 3 tests passed

- [ ] **Step 5: api-constant.js ve formatters.js yaz**

`src/shared/constant/api-constant.js`:
```js
export const API_BASE_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:4000/api'
export const TOKEN_REFRESH_BUFFER = 60 // saniye
```

`src/shared/utils/formatters.js`:
```js
export const formatCurrency = (amount) =>
  new Intl.NumberFormat('tr-TR', { style: 'currency', currency: 'TRY' }).format(amount)

export const formatDistance = (meters) =>
  meters >= 1000 ? `${(meters / 1000).toFixed(1)} km` : `${meters} m`

export const formatDuration = (seconds) => {
  const m = Math.floor(seconds / 60)
  const s = seconds % 60
  return `${m}:${s.toString().padStart(2, '0')}`
}
```

- [ ] **Step 6: axios.jsx yaz (JWT interceptor)**

```jsx
import axios from 'axios'
import { API_BASE_URL, TOKEN_REFRESH_BUFFER } from '@shared/constant/api-constant'
import { useAuthStore } from '@store/authStore'

const instance = axios.create({ baseURL: API_BASE_URL })

instance.interceptors.request.use(async (config) => {
  const { token, tokenExpiry, refreshToken, setToken } = useAuthStore.getState()
  if (!token) return config

  const expiresIn = tokenExpiry - Date.now() / 1000
  if (expiresIn < TOKEN_REFRESH_BUFFER) {
    const res = await axios.post(`${API_BASE_URL}/auth/refresh`, { refreshToken })
    setToken(res.data.token, res.data.expiresIn)
    config.headers.Authorization = `Bearer ${res.data.token}`
  } else {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export default instance
```

- [ ] **Step 7: QueryProvider ve NotificationProvider yaz**

`src/shared/providers/QueryProvider.jsx`:
```jsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

const queryClient = new QueryClient({
  defaultOptions: { queries: { staleTime: 30_000, retry: 1 } }
})

export const QueryProvider = ({ children }) => (
  <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
)
```

`src/shared/providers/NotificationProvider.jsx`:
```jsx
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
```

- [ ] **Step 8: Commit**

```bash
git add src/shared && git commit -m "feat: shared altyapı — axios interceptor, providers, constants"
```

---

## Task 3: Zustand Store'ları

**Files:**
- Create: `src/store/authStore.jsx`
- Create: `src/store/uiStore.jsx`
- Create: `src/store/slices/orderSlice.jsx`
- Create: `src/store/slices/modalSlice.jsx`
- Create: `src/store/index.jsx`

- [ ] **Step 1: Failing test — authStore**

`src/store/__tests__/authStore.test.js`:
```js
import { useAuthStore } from '../authStore'

beforeEach(() => useAuthStore.getState().logout())

test('başlangıçta token null', () => {
  expect(useAuthStore.getState().token).toBeNull()
})

test('setToken token ve expiry set eder', () => {
  useAuthStore.getState().setToken('abc', 3600)
  const { token, tokenExpiry } = useAuthStore.getState()
  expect(token).toBe('abc')
  expect(tokenExpiry).toBeGreaterThan(Date.now() / 1000)
})

test('logout sonrası token null', () => {
  useAuthStore.getState().setToken('abc', 3600)
  useAuthStore.getState().logout()
  expect(useAuthStore.getState().token).toBeNull()
})
```

- [ ] **Step 2: Test'i çalıştır — FAIL bekle**

```bash
npx vitest run src/store/__tests__/authStore.test.js
```

- [ ] **Step 3: authStore.jsx yaz**

```jsx
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

export const useAuthStore = create(
  persist(
    (set) => ({
      token: null,
      tokenExpiry: null,
      refreshToken: null,
      driver: null,
      onboardingStatus: null,
      setToken: (token, expiresIn, refreshToken) =>
        set({ token, tokenExpiry: Date.now() / 1000 + expiresIn, refreshToken }),
      setDriver: (driver) => set({ driver }),
      setOnboardingStatus: (status) => set({ onboardingStatus: status }),
      logout: () => set({ token: null, tokenExpiry: null, refreshToken: null, driver: null }),
    }),
    { name: 'hizla-auth' }
  )
)
```

- [ ] **Step 4: Test'i çalıştır — PASS bekle**

```bash
npx vitest run src/store/__tests__/authStore.test.js
```
Beklenen: 3 tests passed

- [ ] **Step 5: uiStore ve slice'ları yaz**

`src/store/uiStore.jsx`:
```jsx
import { create } from 'zustand'

export const useUIStore = create((set) => ({
  isLoading: false,
  setLoading: (isLoading) => set({ isLoading }),
}))
```

`src/store/slices/orderSlice.jsx`:
```jsx
import { create } from 'zustand'

export const useOrderStore = create((set) => ({
  activeOrder: null,
  incomingOrder: null,
  setActiveOrder: (order) => set({ activeOrder: order }),
  setIncomingOrder: (order) => set({ incomingOrder: order }),
  clearIncomingOrder: () => set({ incomingOrder: null }),
}))
```

`src/store/slices/modalSlice.jsx`:
```jsx
import { create } from 'zustand'

export const useModalStore = create((set) => ({
  openModal: null,
  openModalData: null,
  open: (name, data = null) => set({ openModal: name, openModalData: data }),
  close: () => set({ openModal: null, openModalData: null }),
}))
```

`src/store/index.jsx`:
```jsx
export { useAuthStore } from './authStore'
export { useUIStore } from './uiStore'
export { useOrderStore } from './slices/orderSlice'
export { useModalStore } from './slices/modalSlice'
```

- [ ] **Step 6: Commit**

```bash
git add src/store && git commit -m "feat: Zustand store'ları — auth, ui, order, modal"
```

---

## Task 4: Router ve Layout İskeleti

**Files:**
- Create: `src/router/App.jsx`
- Create: `src/router/routeUtils/ProtectedRoute.jsx`
- Create: `src/router/routeUtils/OnboardingGuard.jsx`
- Create: `src/router/routes/publicRoutes.jsx`
- Create: `src/router/routes/protectedRoutes.jsx`
- Create: `src/router/routes/errorRoutes.jsx`
- Create: `src/layouts/Main/Main.jsx`
- Create: `src/layouts/Onboarding/Onboarding.jsx`
- Create: `src/container/Container.jsx`
- Create: `src/main.jsx`

- [ ] **Step 1: Failing test — ProtectedRoute**

`src/router/routeUtils/__tests__/ProtectedRoute.test.jsx`:
```jsx
import { render, screen } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { ProtectedRoute } from '../ProtectedRoute'
import { useAuthStore } from '@store/authStore'

beforeEach(() => useAuthStore.getState().logout())

test('token yoksa /login e yönlendirir', () => {
  render(
    <MemoryRouter initialEntries={['/dashboard']}>
      <Routes>
        <Route path="/login" element={<div>Login</div>} />
        <Route element={<ProtectedRoute />}>
          <Route path="/dashboard" element={<div>Dashboard</div>} />
        </Route>
      </Routes>
    </MemoryRouter>
  )
  expect(screen.getByText('Login')).toBeInTheDocument()
})

test('token varsa içeriği render eder', () => {
  useAuthStore.getState().setToken('valid-token', 3600)
  render(
    <MemoryRouter initialEntries={['/dashboard']}>
      <Routes>
        <Route path="/login" element={<div>Login</div>} />
        <Route element={<ProtectedRoute />}>
          <Route path="/dashboard" element={<div>Dashboard</div>} />
        </Route>
      </Routes>
    </MemoryRouter>
  )
  expect(screen.getByText('Dashboard')).toBeInTheDocument()
})
```

- [ ] **Step 2: Test'i çalıştır — FAIL bekle**

```bash
npx vitest run src/router/routeUtils/__tests__/ProtectedRoute.test.jsx
```

- [ ] **Step 3: ProtectedRoute.jsx yaz**

```jsx
import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '@store/authStore'
import { Routes } from '@shared/constant/route-paths'

export const ProtectedRoute = () => {
  const token = useAuthStore((s) => s.token)
  return token ? <Outlet /> : <Navigate to={Routes.Login} replace />
}
```

- [ ] **Step 4: Test'i çalıştır — PASS bekle**

```bash
npx vitest run src/router/routeUtils/__tests__/ProtectedRoute.test.jsx
```
Beklenen: 2 tests passed

- [ ] **Step 5: OnboardingGuard yaz**

```jsx
import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '@store/authStore'
import { Routes } from '@shared/constant/route-paths'

export const OnboardingGuard = () => {
  const status = useAuthStore((s) => s.onboardingStatus)
  if (status === 'APPROVED') return <Navigate to={Routes.Dashboard} replace />
  return <Outlet />
}
```

- [ ] **Step 6: Route dosyalarını yaz**

`src/router/routes/publicRoutes.jsx`:
```jsx
import { Route } from 'react-router-dom'
import { lazy, Suspense } from 'react'

const Login = lazy(() => import('@pages/login/Login'))

export const publicRoutes = (
  <Route path="/login" element={<Suspense fallback={null}><Login /></Suspense>} />
)
```

`src/router/routes/protectedRoutes.jsx`:
```jsx
import { Route } from 'react-router-dom'
import { lazy, Suspense } from 'react'
import { ProtectedRoute } from '../routeUtils/ProtectedRoute'
import { OnboardingGuard } from '../routeUtils/OnboardingGuard'
import MainLayout from '@layouts/Main/Main'
import OnboardingLayout from '@layouts/Onboarding/Onboarding'

const Dashboard    = lazy(() => import('@pages/dashboard/Dashboard'))
const Wallet       = lazy(() => import('@pages/wallet/Wallet'))
const Earnings     = lazy(() => import('@pages/earnings/Earnings'))
const Quests       = lazy(() => import('@pages/quests/Quests'))
const OrderVerify  = lazy(() => import('@pages/order-verify/OrderVerify'))
const OrderRate    = lazy(() => import('@pages/order-rate/OrderRate'))
const Support      = lazy(() => import('@pages/support/Support'))
const Admin        = lazy(() => import('@pages/admin/Admin'))
const VehicleSel   = lazy(() => import('@pages/onboarding/VehicleSelection'))
const DocUpload    = lazy(() => import('@pages/onboarding/DocumentUpload'))
const Training     = lazy(() => import('@pages/onboarding/Training'))
const Pending      = lazy(() => import('@pages/onboarding/PendingApproval'))

const S = ({ children }) => <Suspense fallback={null}>{children}</Suspense>

export const protectedRoutes = (
  <Route element={<ProtectedRoute />}>
    <Route element={<OnboardingGuard />}>
      <Route element={<MainLayout />}>
        <Route path="/dashboard"         element={<S><Dashboard /></S>} />
        <Route path="/wallet"            element={<S><Wallet /></S>} />
        <Route path="/earnings"          element={<S><Earnings /></S>} />
        <Route path="/quests"            element={<S><Quests /></S>} />
        <Route path="/order/:id/verify"  element={<S><OrderVerify /></S>} />
        <Route path="/order/:id/rate"    element={<S><OrderRate /></S>} />
        <Route path="/support"           element={<S><Support /></S>} />
        <Route path="/admin"             element={<S><Admin /></S>} />
      </Route>
    </Route>
    <Route element={<OnboardingLayout />}>
      <Route path="/onboarding/vehicle"   element={<S><VehicleSel /></S>} />
      <Route path="/onboarding/documents" element={<S><DocUpload /></S>} />
      <Route path="/onboarding/training"  element={<S><Training /></S>} />
      <Route path="/onboarding/pending"   element={<S><Pending /></S>} />
    </Route>
  </Route>
)
```

`src/router/routes/errorRoutes.jsx`:
```jsx
import { Route } from 'react-router-dom'

export const errorRoutes = (
  <>
    <Route path="/unauthorized" element={<div className="text-on-surface p-8">Yetkisiz erişim.</div>} />
    <Route path="*" element={<div className="text-on-surface p-8">Sayfa bulunamadı.</div>} />
  </>
)
```

`src/router/App.jsx`:
```jsx
import { BrowserRouter, Routes, Navigate } from 'react-router-dom'
import { publicRoutes } from './routes/publicRoutes'
import { protectedRoutes } from './routes/protectedRoutes'
import { errorRoutes } from './routes/errorRoutes'

export const App = () => (
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Navigate to="/dashboard" replace />} />
      {publicRoutes}
      {protectedRoutes}
      {errorRoutes}
    </Routes>
  </BrowserRouter>
)
```

- [ ] **Step 7: Layout'ları yaz**

`src/layouts/Main/Main.jsx`:
```jsx
import { Outlet } from 'react-router-dom'
import { TopBar } from '@components/TopBar/TopBar'
import { BottomNav } from '@components/BottomNav/BottomNav'

const Main = () => (
  <div className="flex flex-col h-screen bg-surface-lowest">
    <TopBar />
    <main className="flex-1 overflow-y-auto">
      <Outlet />
    </main>
    <BottomNav />
  </div>
)

export default Main
```

`src/layouts/Onboarding/Onboarding.jsx`:
```jsx
import { Outlet, useLocation } from 'react-router-dom'

const STEPS = [
  '/onboarding/vehicle',
  '/onboarding/documents',
  '/onboarding/training',
  '/onboarding/pending',
]

const OnboardingLayout = () => {
  const { pathname } = useLocation()
  const currentStep = STEPS.indexOf(pathname)

  return (
    <div className="min-h-screen bg-surface-lowest flex flex-col">
      <div className="flex gap-1 p-4">
        {STEPS.map((_, i) => (
          <div
            key={i}
            className={`h-1 flex-1 rounded-full transition-colors ${
              i <= currentStep ? 'bg-primary' : 'bg-surface-highest'
            }`}
          />
        ))}
      </div>
      <Outlet />
    </div>
  )
}

export default OnboardingLayout
```

- [ ] **Step 8: Container ve main.jsx yaz**

`src/container/Container.jsx`:
```jsx
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
```

`src/main.jsx`:
```jsx
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { Container } from './container/Container'
import { App } from './router/App'
import './index.css'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Container>
      <App />
    </Container>
  </StrictMode>
)
```

`src/index.css`:
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: #0e0e0e; color: #e2e2e2; font-family: 'Inter', sans-serif; }
  ::-webkit-scrollbar { width: 4px; }
  ::-webkit-scrollbar-track { background: #131313; }
  ::-webkit-scrollbar-thumb { background: #353535; border-radius: 2px; }
}
```

- [ ] **Step 9: Commit**

```bash
git add . && git commit -m "feat: router, layout iskeletleri, Container"
```

---

## Task 5: Shared UI Bileşenleri

**Files:**
- Create: `src/components/TopBar/TopBar.jsx`
- Create: `src/components/BottomNav/BottomNav.jsx`
- Create: `src/components/GlassCard/GlassCard.jsx`
- Create: `src/components/SlideToAccept/SlideToAccept.jsx`
- Create: `src/components/CountdownBorder/CountdownBorder.jsx`
- Create: `src/components/Loading/Loading.jsx`

- [ ] **Step 1: Failing test — GlassCard**

`src/components/GlassCard/__tests__/GlassCard.test.jsx`:
```jsx
import { render, screen } from '@testing-library/react'
import { GlassCard } from '../GlassCard'

test('children render eder', () => {
  render(<GlassCard><span>test içerik</span></GlassCard>)
  expect(screen.getByText('test içerik')).toBeInTheDocument()
})

test('glassmorphic class'ları taşır', () => {
  const { container } = render(<GlassCard>x</GlassCard>)
  const el = container.firstChild
  expect(el.className).toContain('backdrop-blur')
})
```

- [ ] **Step 2: Test çalıştır — FAIL bekle**

```bash
npx vitest run src/components/GlassCard/__tests__/GlassCard.test.jsx
```

- [ ] **Step 3: GlassCard.jsx yaz**

```jsx
export const GlassCard = ({ children, className = '' }) => (
  <div className={`bg-surface-high/60 backdrop-blur-glass rounded-card p-6 ${className}`}>
    {children}
  </div>
)
```

- [ ] **Step 4: Test çalıştır — PASS bekle**

```bash
npx vitest run src/components/GlassCard/__tests__/GlassCard.test.jsx
```

- [ ] **Step 5: Diğer bileşenleri yaz**

`src/components/TopBar/TopBar.jsx`:
```jsx
import { useAuthStore } from '@store/authStore'

export const TopBar = () => {
  const driver = useAuthStore((s) => s.driver)
  return (
    <header className="flex items-center justify-between px-4 py-3 bg-surface border-b border-outline-variant/15">
      <span className="font-label text-xs text-on-surface-variant uppercase tracking-widest">Hızla Ye</span>
      <div className="flex items-center gap-2">
        <div className="w-8 h-8 rounded-full bg-surface-highest flex items-center justify-center text-xs text-on-surface">
          {driver?.name?.[0] ?? '?'}
        </div>
      </div>
    </header>
  )
}
```

`src/components/BottomNav/BottomNav.jsx`:
```jsx
import { NavLink } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

const NAV_ITEMS = [
  { to: Routes.Dashboard, label: 'Ana Sayfa', icon: '🏠' },
  { to: Routes.Wallet,    label: 'Cüzdan',    icon: '💰' },
  { to: Routes.Earnings,  label: 'Kazanç',    icon: '📊' },
  { to: Routes.Quests,    label: 'Görevler',  icon: '🎯' },
  { to: Routes.Support,   label: 'Destek',    icon: '💬' },
]

export const BottomNav = () => (
  <nav className="flex bg-surface border-t border-outline-variant/15">
    {NAV_ITEMS.map(({ to, label, icon }) => (
      <NavLink
        key={to}
        to={to}
        className={({ isActive }) =>
          `flex flex-col items-center flex-1 py-2 text-xs gap-1 transition-colors ${
            isActive ? 'text-primary' : 'text-on-surface-variant'
          }`
        }
      >
        <span className="text-lg">{icon}</span>
        <span className="font-label">{label}</span>
      </NavLink>
    ))}
  </nav>
)
```

`src/components/SlideToAccept/SlideToAccept.jsx`:
```jsx
import { useState, useRef } from 'react'

export const SlideToAccept = ({ onAccept, label = 'Kabul Et' }) => {
  const [pos, setPos] = useState(0)
  const trackRef = useRef(null)
  const MAX = 220

  const onPointerMove = (e) => {
    if (!e.buttons) return
    const rect = trackRef.current.getBoundingClientRect()
    const newPos = Math.min(MAX, Math.max(0, e.clientX - rect.left - 28))
    setPos(newPos)
    if (newPos >= MAX - 4) onAccept?.()
  }

  return (
    <div
      ref={trackRef}
      onPointerMove={onPointerMove}
      onPointerUp={() => setPos(0)}
      className="relative h-14 w-full bg-surface-highest rounded-full overflow-hidden shadow-float select-none"
    >
      <div
        className="absolute left-0 top-0 h-full rounded-full bg-primary/20 transition-all"
        style={{ width: pos + 56 }}
      />
      <div
        className="absolute top-1 left-1 w-12 h-12 rounded-full bg-gradient-to-br from-primary to-primary-container flex items-center justify-center cursor-grab active:cursor-grabbing"
        style={{ transform: `translateX(${pos}px)` }}
      >
        →
      </div>
      <span className="absolute inset-0 flex items-center justify-center text-sm text-on-surface-variant pl-16 font-label">
        {label}
      </span>
    </div>
  )
}
```

`src/components/CountdownBorder/CountdownBorder.jsx`:
```jsx
export const CountdownBorder = ({ children, active = false }) => (
  <div className={`rounded-card ${active ? 'animate-pulse_border shadow-glow' : ''}`}>
    {children}
  </div>
)
```

`src/components/Loading/Loading.jsx`:
```jsx
export const Loading = () => (
  <div className="flex items-center justify-center h-full w-full">
    <div className="w-8 h-8 border-2 border-primary border-t-transparent rounded-full animate-spin" />
  </div>
)
```

- [ ] **Step 6: Commit**

```bash
git add src/components && git commit -m "feat: paylaşılan UI bileşenleri — GlassCard, SlideToAccept, BottomNav"
```

---

## Task 6: API Katmanı

**Files:**
- Create: `src/api/auth.jsx`
- Create: `src/api/courier.jsx`
- Create: `src/api/onboarding.jsx`
- Create: `src/api/admin.jsx`
- Create: `src/api/index.jsx`

- [ ] **Step 1: auth.jsx yaz**

```jsx
import axios from '@shared/axios/axios'

export const login = (credentials) => axios.post('/auth/login', credentials)
export const logout = () => axios.post('/auth/logout')
export const refreshToken = (token) => axios.post('/auth/refresh', { refreshToken: token })
```

- [ ] **Step 2: courier.jsx yaz**

```jsx
import axios from '@shared/axios/axios'

export const getActiveOrder     = () => axios.get('/courier/order/active')
export const acceptOrder        = (id) => axios.post(`/courier/order/${id}/accept`)
export const rejectOrder        = (id) => axios.post(`/courier/order/${id}/reject`)
export const verifyPackage      = (id, qrCode) => axios.post(`/courier/order/${id}/verify`, { qrCode })
export const rateRestaurant     = (id, data) => axios.post(`/courier/order/${id}/rate`, data)
export const getWallet          = () => axios.get('/courier/wallet')
export const getEarnings        = (params) => axios.get('/courier/earnings', { params })
export const getQuests          = () => axios.get('/courier/quests')
export const createSupportTicket = (data) => axios.post('/courier/support', data)
```

- [ ] **Step 3: onboarding.jsx yaz**

```jsx
import axios from '@shared/axios/axios'

export const getOnboardingStatus = () => axios.get('/onboarding/status')
export const selectVehicle       = (vehicleType) => axios.post('/onboarding/vehicle', { vehicleType })
export const uploadDocument      = (type, file) => {
  const fd = new FormData()
  fd.append('type', type)
  fd.append('file', file)
  return axios.post('/onboarding/document', fd, { headers: { 'Content-Type': 'multipart/form-data' } })
}
export const completeTraining    = () => axios.post('/onboarding/training/complete')
```

- [ ] **Step 4: admin.jsx yaz**

```jsx
import axios from '@shared/axios/axios'

export const getAdminDashboard = () => axios.get('/admin/dashboard')
export const getDrivers        = (params) => axios.get('/admin/drivers', { params })
export const approveDriver     = (id) => axios.post(`/admin/drivers/${id}/approve`)
export const rejectDriver      = (id) => axios.post(`/admin/drivers/${id}/reject`)
```

- [ ] **Step 5: index.jsx barrel yaz**

```jsx
export * as authApi from './auth'
export * as courierApi from './courier'
export * as onboardingApi from './onboarding'
export * as adminApi from './admin'
```

- [ ] **Step 6: Commit**

```bash
git add src/api && git commit -m "feat: API katmanı — auth, courier, onboarding, admin"
```

---

## Task 7: Auth Feature (Login Ekranı)

**Stitch:** `Giriş Ekranı (Login)` — Koyu tema, sol logo alanı, sağda form, "Hızla Ye Orange" buton

**Files:**
- Create: `src/features/auth/hooks/useLogin.jsx`
- Create: `src/features/auth/hooks/useLogout.jsx`
- Create: `src/features/auth/components/LoginForm/LoginForm.jsx`
- Create: `src/pages/login/Login.jsx`

- [ ] **Step 1: Failing test — useLogin**

`src/features/auth/hooks/__tests__/useLogin.test.jsx`:
```jsx
import { renderHook, act } from '@testing-library/react'
import { vi } from 'vitest'
import { useLogin } from '../useLogin'
import * as authApi from '@api/auth'
import { QueryProvider } from '@shared/providers/QueryProvider'

vi.mock('@api/auth')

const wrapper = ({ children }) => <QueryProvider>{children}</QueryProvider>

test('başarılı login sonrası token store'a yazılır', async () => {
  authApi.login.mockResolvedValue({ data: { token: 'tok', expiresIn: 3600, refreshToken: 'ref' } })
  const { result } = renderHook(() => useLogin(), { wrapper })
  await act(() => result.current.mutateAsync({ email: 'a@a.com', password: '123' }))
  const { useAuthStore } = await import('@store/authStore')
  expect(useAuthStore.getState().token).toBe('tok')
})
```

- [ ] **Step 2: Test çalıştır — FAIL bekle**

```bash
npx vitest run src/features/auth/hooks/__tests__/useLogin.test.jsx
```

- [ ] **Step 3: useLogin.jsx yaz**

```jsx
import { useMutation } from '@tanstack/react-query'
import { login } from '@api/auth'
import { useAuthStore } from '@store/authStore'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useLogin = () => {
  const setToken = useAuthStore((s) => s.setToken)
  const setDriver = useAuthStore((s) => s.setDriver)
  const setOnboardingStatus = useAuthStore((s) => s.setOnboardingStatus)
  const navigate = useNavigate()

  return useMutation({
    mutationFn: login,
    onSuccess: ({ data }) => {
      setToken(data.token, data.expiresIn, data.refreshToken)
      setDriver(data.driver)
      setOnboardingStatus(data.onboardingStatus)
      if (data.onboardingStatus !== 'APPROVED') {
        navigate(Routes.OnboardingVehicle)
      } else {
        navigate(Routes.Dashboard)
      }
    }
  })
}
```

- [ ] **Step 4: Test çalıştır — PASS bekle**

```bash
npx vitest run src/features/auth/hooks/__tests__/useLogin.test.jsx
```

- [ ] **Step 5: useLogout.jsx yaz**

```jsx
import { useMutation } from '@tanstack/react-query'
import { logout } from '@api/auth'
import { useAuthStore } from '@store/authStore'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useLogout = () => {
  const logoutStore = useAuthStore((s) => s.logout)
  const navigate = useNavigate()

  return useMutation({
    mutationFn: logout,
    onSettled: () => {
      logoutStore()
      navigate(Routes.Login)
    }
  })
}
```

- [ ] **Step 6: LoginForm.jsx yaz (Stitch tasarımına uygun)**

```jsx
import { useState } from 'react'
import { useLogin } from '@features/auth/hooks/useLogin'

export const LoginForm = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const { mutate, isPending, error } = useLogin()

  const onSubmit = (e) => {
    e.preventDefault()
    mutate({ email, password })
  }

  return (
    <form onSubmit={onSubmit} className="flex flex-col gap-4 w-full max-w-sm">
      <div className="flex flex-col gap-1">
        <label className="text-xs font-label text-on-surface-variant uppercase tracking-wide">E-posta</label>
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="bg-surface-high rounded-card px-4 py-3 text-on-surface outline-none focus:ring-1 focus:ring-primary/20"
          placeholder="kurye@hizlaye.com"
          required
        />
      </div>
      <div className="flex flex-col gap-1">
        <label className="text-xs font-label text-on-surface-variant uppercase tracking-wide">Şifre</label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="bg-surface-high rounded-card px-4 py-3 text-on-surface outline-none focus:ring-1 focus:ring-primary/20"
          placeholder="••••••••"
          required
        />
      </div>
      {error && <p className="text-error text-sm">{error.message}</p>}
      <button
        type="submit"
        disabled={isPending}
        className="bg-gradient-to-br from-primary to-primary-container text-white font-semibold py-3 rounded-card disabled:opacity-50"
      >
        {isPending ? 'Giriş yapılıyor…' : 'Giriş Yap'}
      </button>
    </form>
  )
}
```

- [ ] **Step 7: Login.jsx page yaz**

```jsx
import { LoginForm } from '@features/auth/components/LoginForm/LoginForm'

const Login = () => (
  <div className="min-h-screen bg-surface-lowest flex">
    <div className="hidden lg:flex flex-1 bg-surface items-center justify-center">
      <div className="text-center">
        <h1 className="text-5xl font-bold text-primary font-mono">HIZLA YE</h1>
        <p className="text-on-surface-variant mt-2 font-label">Kurye Ekosistemi</p>
      </div>
    </div>
    <div className="flex-1 flex items-center justify-center p-8">
      <div className="w-full max-w-sm">
        <h2 className="text-2xl font-semibold text-on-surface mb-2">Hoş Geldin</h2>
        <p className="text-on-surface-variant text-sm mb-8">Devam etmek için giriş yap.</p>
        <LoginForm />
      </div>
    </div>
  </div>
)

export default Login
```

- [ ] **Step 8: Commit**

```bash
git add src/features/auth src/pages/login && git commit -m "feat: Login ekranı — LoginForm, useLogin hook"
```

---

## Task 8: Courier Feature — Dashboard & Map (Ekran 2 + 3)

**Stitch:** Dashboard & Map (harita ekranı, aktif konum, online/offline toggle) + Incoming Order Card (overlay kart, CountdownBorder, SlideToAccept)

**Files:**
- Create: `src/features/courier/hooks/useActiveOrder.jsx`
- Create: `src/features/courier/hooks/useAcceptOrder.jsx`
- Create: `src/features/courier/hooks/useRejectOrder.jsx`
- Create: `src/features/courier/components/DashboardMap/DashboardMap.jsx`
- Create: `src/features/courier/components/IncomingOrderOverlay/IncomingOrderOverlay.jsx`
- Create: `src/components/MapView/MapView.jsx`
- Create: `src/pages/dashboard/Dashboard.jsx`

- [ ] **Step 1: Failing test — useActiveOrder**

`src/features/courier/hooks/__tests__/useActiveOrder.test.jsx`:
```jsx
import { renderHook, waitFor } from '@testing-library/react'
import { vi } from 'vitest'
import { useActiveOrder } from '../useActiveOrder'
import * as courierApi from '@api/courier'
import { QueryProvider } from '@shared/providers/QueryProvider'

vi.mock('@api/courier')

const wrapper = ({ children }) => <QueryProvider>{children}</QueryProvider>

test('API'den aktif siparişi döner', async () => {
  courierApi.getActiveOrder.mockResolvedValue({ data: { id: 'ord1', restaurant: 'Burger Co' } })
  const { result } = renderHook(() => useActiveOrder(), { wrapper })
  await waitFor(() => expect(result.current.isSuccess).toBe(true))
  expect(result.current.data.id).toBe('ord1')
})
```

- [ ] **Step 2: Test çalıştır — FAIL bekle**

```bash
npx vitest run src/features/courier/hooks/__tests__/useActiveOrder.test.jsx
```

- [ ] **Step 3: Hook'ları yaz**

`src/features/courier/hooks/useActiveOrder.jsx`:
```jsx
import { useQuery } from '@tanstack/react-query'
import { getActiveOrder } from '@api/courier'

export const useActiveOrder = () =>
  useQuery({
    queryKey: ['courier', 'active-order'],
    queryFn: () => getActiveOrder().then((r) => r.data),
    refetchInterval: 5000,
  })
```

`src/features/courier/hooks/useAcceptOrder.jsx`:
```jsx
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { acceptOrder } from '@api/courier'

export const useAcceptOrder = () => {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: acceptOrder,
    onSuccess: () => qc.invalidateQueries({ queryKey: ['courier', 'active-order'] })
  })
}
```

`src/features/courier/hooks/useRejectOrder.jsx`:
```jsx
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { rejectOrder } from '@api/courier'

export const useRejectOrder = () => {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: rejectOrder,
    onSuccess: () => qc.invalidateQueries({ queryKey: ['courier', 'active-order'] })
  })
}
```

- [ ] **Step 4: Test çalıştır — PASS bekle**

```bash
npx vitest run src/features/courier/hooks/__tests__/useActiveOrder.test.jsx
```

- [ ] **Step 5: MapView.jsx yaz**

```jsx
import { useEffect, useRef } from 'react'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

export const MapView = ({ center = [41.015, 28.979], zoom = 14, className = '' }) => {
  const containerRef = useRef(null)
  const mapRef = useRef(null)

  useEffect(() => {
    if (mapRef.current) return
    mapRef.current = L.map(containerRef.current, { center, zoom, zoomControl: false })
    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
      attribution: '&copy; OpenStreetMap &copy; CARTO'
    }).addTo(mapRef.current)
    return () => { mapRef.current?.remove(); mapRef.current = null }
  }, [])

  return <div ref={containerRef} className={`w-full h-full ${className}`} />
}
```

- [ ] **Step 6: IncomingOrderOverlay.jsx yaz**

```jsx
import { GlassCard } from '@components/GlassCard/GlassCard'
import { SlideToAccept } from '@components/SlideToAccept/SlideToAccept'
import { CountdownBorder } from '@components/CountdownBorder/CountdownBorder'
import { useAcceptOrder } from '@features/courier/hooks/useAcceptOrder'
import { useRejectOrder } from '@features/courier/hooks/useRejectOrder'
import { formatCurrency, formatDistance } from '@shared/utils/formatters'

export const IncomingOrderOverlay = ({ order }) => {
  const { mutate: accept } = useAcceptOrder()
  const { mutate: reject } = useRejectOrder()

  return (
    <div className="absolute bottom-20 left-4 right-4 z-50 animate-slide_in">
      <CountdownBorder active>
        <GlassCard>
          <div className="flex justify-between items-start mb-4">
            <div>
              <h3 className="text-on-surface font-semibold">{order.restaurant}</h3>
              <p className="text-on-surface-variant text-sm">{order.customerAddress}</p>
            </div>
            <div className="text-right">
              <p className="font-mono text-xl text-primary">{formatCurrency(order.fee)}</p>
              <p className="text-on-surface-variant text-xs">{formatDistance(order.distanceMeters)}</p>
            </div>
          </div>
          <SlideToAccept onAccept={() => accept(order.id)} label="Sürükle → Kabul Et" />
          <button
            onClick={() => reject(order.id)}
            className="w-full mt-2 py-2 text-sm text-on-surface-variant hover:text-error transition-colors"
          >
            Reddet
          </button>
        </GlassCard>
      </CountdownBorder>
    </div>
  )
}
```

- [ ] **Step 7: DashboardMap.jsx yaz**

```jsx
import { MapView } from '@components/MapView/MapView'
import { IncomingOrderOverlay } from '../IncomingOrderOverlay/IncomingOrderOverlay'
import { useActiveOrder } from '@features/courier/hooks/useActiveOrder'

export const DashboardMap = () => {
  const { data: order } = useActiveOrder()

  return (
    <div className="relative h-full">
      <MapView className="absolute inset-0" />
      {order?.status === 'INCOMING' && (
        <IncomingOrderOverlay order={order} />
      )}
    </div>
  )
}
```

- [ ] **Step 8: Dashboard.jsx page yaz**

```jsx
import { DashboardMap } from '@features/courier/components/DashboardMap/DashboardMap'

const Dashboard = () => (
  <div className="h-full relative">
    <DashboardMap />
  </div>
)

export default Dashboard
```

- [ ] **Step 9: Commit**

```bash
git add . && git commit -m "feat: Dashboard & Map, IncomingOrderOverlay, useActiveOrder"
```

---

## Task 9: Wallet, Earnings & Analytics (Ekran 4 + 5)

**Files:**
- Create: `src/features/courier/hooks/useWallet.jsx`
- Create: `src/features/courier/hooks/useEarnings.jsx`
- Create: `src/features/courier/components/WalletSummary/WalletSummary.jsx`
- Create: `src/features/courier/components/EarningsChart/EarningsChart.jsx`
- Create: `src/pages/wallet/Wallet.jsx`
- Create: `src/pages/earnings/Earnings.jsx`

- [ ] **Step 1: useWallet.jsx ve useEarnings.jsx yaz**

`src/features/courier/hooks/useWallet.jsx`:
```jsx
import { useQuery } from '@tanstack/react-query'
import { getWallet } from '@api/courier'

export const useWallet = () =>
  useQuery({
    queryKey: ['courier', 'wallet'],
    queryFn: () => getWallet().then((r) => r.data),
  })
```

`src/features/courier/hooks/useEarnings.jsx`:
```jsx
import { useQuery } from '@tanstack/react-query'
import { getEarnings } from '@api/courier'

export const useEarnings = (period = 'weekly') =>
  useQuery({
    queryKey: ['courier', 'earnings', period],
    queryFn: () => getEarnings({ period }).then((r) => r.data),
  })
```

- [ ] **Step 2: WalletSummary.jsx yaz (Stitch tasarımı: hakedis kart, JetBrains Mono rakamlar)**

```jsx
import { useWallet } from '@features/courier/hooks/useWallet'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { formatCurrency } from '@shared/utils/formatters'
import { Loading } from '@components/Loading/Loading'

export const WalletSummary = () => {
  const { data, isLoading } = useWallet()

  if (isLoading) return <Loading />

  return (
    <div className="flex flex-col gap-4 p-4">
      <GlassCard>
        <p className="text-xs font-label text-on-surface-variant uppercase tracking-widest mb-1">Toplam Bakiye</p>
        <p className="font-mono text-4xl text-on-surface">{formatCurrency(data?.balance ?? 0)}</p>
      </GlassCard>
      <div className="grid grid-cols-2 gap-3">
        <GlassCard className="p-4">
          <p className="text-xs text-on-surface-variant mb-1">Bu Hafta</p>
          <p className="font-mono text-xl text-primary">{formatCurrency(data?.weeklyEarnings ?? 0)}</p>
        </GlassCard>
        <GlassCard className="p-4">
          <p className="text-xs text-on-surface-variant mb-1">Bekleyen</p>
          <p className="font-mono text-xl text-tertiary">{formatCurrency(data?.pending ?? 0)}</p>
        </GlassCard>
      </div>
      <GlassCard>
        <p className="text-xs font-label text-on-surface-variant mb-3">Son İşlemler</p>
        {(data?.transactions ?? []).map((tx) => (
          <div key={tx.id} className="flex justify-between items-center py-2 border-b border-outline-variant/10 last:border-0">
            <div>
              <p className="text-sm text-on-surface">{tx.description}</p>
              <p className="text-xs text-on-surface-variant">{tx.date}</p>
            </div>
            <p className={`font-mono text-sm ${tx.amount > 0 ? 'text-primary' : 'text-error'}`}>
              {tx.amount > 0 ? '+' : ''}{formatCurrency(tx.amount)}
            </p>
          </div>
        ))}
      </GlassCard>
    </div>
  )
}
```

- [ ] **Step 3: EarningsChart.jsx yaz**

```jsx
import { useState } from 'react'
import { useEarnings } from '@features/courier/hooks/useEarnings'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { formatCurrency } from '@shared/utils/formatters'
import { Loading } from '@components/Loading/Loading'

const PERIODS = [
  { label: 'Haftalık', value: 'weekly' },
  { label: 'Aylık', value: 'monthly' },
]

export const EarningsChart = () => {
  const [period, setPeriod] = useState('weekly')
  const { data, isLoading } = useEarnings(period)

  if (isLoading) return <Loading />

  const maxVal = Math.max(...(data?.bars ?? []).map((b) => b.amount), 1)

  return (
    <div className="flex flex-col gap-4 p-4">
      <div className="flex gap-2">
        {PERIODS.map(({ label, value }) => (
          <button
            key={value}
            onClick={() => setPeriod(value)}
            className={`px-4 py-1.5 rounded-full text-sm font-label transition-colors ${
              period === value
                ? 'bg-primary text-white'
                : 'bg-surface-high text-on-surface-variant'
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      <GlassCard>
        <p className="text-xs font-label text-on-surface-variant mb-1">Toplam Kazanç</p>
        <p className="font-mono text-3xl text-on-surface mb-4">{formatCurrency(data?.total ?? 0)}</p>
        <div className="flex items-end gap-1 h-32">
          {(data?.bars ?? []).map((bar, i) => (
            <div key={i} className="flex flex-col items-center flex-1 gap-1">
              <div
                className="w-full bg-primary/30 rounded-sm transition-all"
                style={{ height: `${(bar.amount / maxVal) * 100}%` }}
              />
              <span className="text-xs text-on-surface-variant font-label">{bar.label}</span>
            </div>
          ))}
        </div>
      </GlassCard>

      <div className="grid grid-cols-3 gap-3">
        {[
          { label: 'Sipariş', value: data?.orderCount ?? 0, mono: false },
          { label: 'Ort. Sipariş', value: formatCurrency(data?.avgOrderFee ?? 0), mono: true },
          { label: 'Çevrimiçi Süre', value: `${data?.onlineHours ?? 0}s`, mono: true },
        ].map(({ label, value, mono }) => (
          <GlassCard key={label} className="p-3">
            <p className="text-xs text-on-surface-variant mb-1">{label}</p>
            <p className={`text-lg ${mono ? 'font-mono' : 'font-semibold'} text-on-surface`}>{value}</p>
          </GlassCard>
        ))}
      </div>
    </div>
  )
}
```

- [ ] **Step 4: Wallet.jsx ve Earnings.jsx page'leri yaz**

`src/pages/wallet/Wallet.jsx`:
```jsx
import { WalletSummary } from '@features/courier/components/WalletSummary/WalletSummary'

const Wallet = () => (
  <div className="overflow-y-auto h-full pb-4">
    <div className="px-4 pt-4 pb-2">
      <h1 className="text-xl font-semibold text-on-surface">Hakediş & Cüzdan</h1>
    </div>
    <WalletSummary />
  </div>
)

export default Wallet
```

`src/pages/earnings/Earnings.jsx`:
```jsx
import { EarningsChart } from '@features/courier/components/EarningsChart/EarningsChart'

const Earnings = () => (
  <div className="overflow-y-auto h-full pb-4">
    <div className="px-4 pt-4 pb-2">
      <h1 className="text-xl font-semibold text-on-surface">Kazanç & Analitik</h1>
    </div>
    <EarningsChart />
  </div>
)

export default Earnings
```

- [ ] **Step 5: Commit**

```bash
git add . && git commit -m "feat: Wallet ve Earnings sayfaları"
```

---

## Task 10: Quests & QR & Rating (Ekran 6, 7, 8)

**Files:**
- Create: `src/features/courier/hooks/useQuests.jsx`
- Create: `src/features/courier/hooks/useVerifyPackage.jsx`
- Create: `src/features/courier/hooks/useRateRestaurant.jsx`
- Create: `src/features/courier/components/QuestList/QuestList.jsx`
- Create: `src/components/QRScanner/QRScanner.jsx`
- Create: `src/components/EmojiRating/EmojiRating.jsx`
- Create: `src/pages/quests/Quests.jsx`
- Create: `src/pages/order-verify/OrderVerify.jsx`
- Create: `src/pages/order-rate/OrderRate.jsx`

- [ ] **Step 1: Hook'ları yaz**

`src/features/courier/hooks/useQuests.jsx`:
```jsx
import { useQuery } from '@tanstack/react-query'
import { getQuests } from '@api/courier'

export const useQuests = () =>
  useQuery({
    queryKey: ['courier', 'quests'],
    queryFn: () => getQuests().then((r) => r.data),
  })
```

`src/features/courier/hooks/useVerifyPackage.jsx`:
```jsx
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { verifyPackage } from '@api/courier'

export const useVerifyPackage = (orderId) => {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: (qrCode) => verifyPackage(orderId, qrCode),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['courier', 'active-order'] })
  })
}
```

`src/features/courier/hooks/useRateRestaurant.jsx`:
```jsx
import { useMutation } from '@tanstack/react-query'
import { rateRestaurant } from '@api/courier'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useRateRestaurant = (orderId) => {
  const navigate = useNavigate()
  return useMutation({
    mutationFn: (data) => rateRestaurant(orderId, data),
    onSuccess: () => navigate(Routes.Dashboard)
  })
}
```

- [ ] **Step 2: QuestList.jsx yaz**

```jsx
import { useQuests } from '@features/courier/hooks/useQuests'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { Loading } from '@components/Loading/Loading'

const RARITY_COLORS = { common: 'text-on-surface', rare: 'text-tertiary', epic: 'text-primary' }

export const QuestList = () => {
  const { data, isLoading } = useQuests()

  if (isLoading) return <Loading />

  return (
    <div className="flex flex-col gap-3 p-4">
      {(data?.quests ?? []).map((quest) => (
        <GlassCard key={quest.id}>
          <div className="flex justify-between items-start">
            <div>
              <p className={`font-semibold text-sm ${RARITY_COLORS[quest.rarity] ?? 'text-on-surface'}`}>
                {quest.title}
              </p>
              <p className="text-xs text-on-surface-variant mt-0.5">{quest.description}</p>
            </div>
            <div className="text-right shrink-0 ml-4">
              <p className="font-mono text-sm text-primary">+{quest.reward}₺</p>
              <p className="text-xs text-on-surface-variant">{quest.progress}/{quest.target}</p>
            </div>
          </div>
          <div className="mt-3 h-1.5 bg-surface-highest rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-primary to-primary-container rounded-full"
              style={{ width: `${Math.min(100, (quest.progress / quest.target) * 100)}%` }}
            />
          </div>
        </GlassCard>
      ))}
    </div>
  )
}
```

- [ ] **Step 3: EmojiRating.jsx yaz**

```jsx
import { useState } from 'react'

const EMOJIS = ['😡', '😕', '😐', '😊', '🤩']

export const EmojiRating = ({ onRate }) => {
  const [selected, setSelected] = useState(null)

  const handleSelect = (index) => {
    setSelected(index)
    onRate?.(index + 1)
  }

  return (
    <div className="flex justify-center gap-4">
      {EMOJIS.map((emoji, i) => (
        <button
          key={i}
          onClick={() => handleSelect(i)}
          className={`text-4xl transition-transform ${
            selected === i ? 'scale-125' : 'scale-100 opacity-50 hover:opacity-80'
          }`}
        >
          {emoji}
        </button>
      ))}
    </div>
  )
}
```

- [ ] **Step 4: QRScanner.jsx yaz**

```jsx
import { useEffect, useRef } from 'react'

export const QRScanner = ({ onScan }) => {
  const videoRef = useRef(null)

  useEffect(() => {
    let stream = null
    navigator.mediaDevices?.getUserMedia({ video: { facingMode: 'environment' } })
      .then((s) => {
        stream = s
        if (videoRef.current) videoRef.current.srcObject = s
      })
      .catch(console.error)
    return () => stream?.getTracks().forEach((t) => t.stop())
  }, [])

  return (
    <div className="relative w-full aspect-square bg-surface-container rounded-card overflow-hidden">
      <video ref={videoRef} autoPlay playsInline className="w-full h-full object-cover" />
      <div className="absolute inset-0 flex items-center justify-center">
        <div className="w-48 h-48 border-2 border-tertiary rounded-card shadow-glow animate-pulse_border" />
      </div>
      <button
        onClick={() => onScan?.('mock-qr-code')}
        className="absolute bottom-4 left-1/2 -translate-x-1/2 px-6 py-2 bg-primary text-white rounded-full text-sm"
      >
        Manuel Giriş
      </button>
    </div>
  )
}
```

- [ ] **Step 5: Page'leri yaz**

`src/pages/quests/Quests.jsx`:
```jsx
import { QuestList } from '@features/courier/components/QuestList/QuestList'

const Quests = () => (
  <div className="overflow-y-auto h-full pb-4">
    <div className="px-4 pt-4 pb-2">
      <h1 className="text-xl font-semibold text-on-surface">Görevler & Ödüller</h1>
    </div>
    <QuestList />
  </div>
)

export default Quests
```

`src/pages/order-verify/OrderVerify.jsx`:
```jsx
import { useParams } from 'react-router-dom'
import { QRScanner } from '@components/QRScanner/QRScanner'
import { useVerifyPackage } from '@features/courier/hooks/useVerifyPackage'

const OrderVerify = () => {
  const { id } = useParams()
  const { mutate, isPending, isSuccess } = useVerifyPackage(id)

  if (isSuccess) return (
    <div className="h-full flex items-center justify-center">
      <div className="text-center">
        <p className="text-6xl mb-4">✅</p>
        <p className="text-on-surface font-semibold">Paket Doğrulandı</p>
      </div>
    </div>
  )

  return (
    <div className="p-4 flex flex-col gap-6">
      <h1 className="text-xl font-semibold text-on-surface">Paket Doğrulama</h1>
      <QRScanner onScan={(code) => mutate(code)} />
      {isPending && <p className="text-center text-on-surface-variant text-sm">Doğrulanıyor…</p>}
    </div>
  )
}

export default OrderVerify
```

`src/pages/order-rate/OrderRate.jsx`:
```jsx
import { useParams } from 'react-router-dom'
import { useState } from 'react'
import { EmojiRating } from '@components/EmojiRating/EmojiRating'
import { useRateRestaurant } from '@features/courier/hooks/useRateRestaurant'

const OrderRate = () => {
  const { id } = useParams()
  const [rating, setRating] = useState(null)
  const { mutate, isPending } = useRateRestaurant(id)

  return (
    <div className="p-8 flex flex-col gap-8 items-center">
      <h1 className="text-xl font-semibold text-on-surface text-center">Restoranı Değerlendir</h1>
      <EmojiRating onRate={setRating} />
      {rating && (
        <button
          onClick={() => mutate({ rating })}
          disabled={isPending}
          className="w-full max-w-xs bg-gradient-to-br from-primary to-primary-container text-white py-3 rounded-card font-semibold disabled:opacity-50"
        >
          {isPending ? 'Gönderiliyor…' : 'Gönder'}
        </button>
      )}
    </div>
  )
}

export default OrderRate
```

- [ ] **Step 6: Commit**

```bash
git add . && git commit -m "feat: Quests, QR doğrulama, Restoran puanlama ekranları"
```

---

## Task 11: Support (Ekran 9)

**Files:**
- Create: `src/features/courier/hooks/useSupport.jsx`
- Create: `src/features/courier/components/SupportTicketForm/SupportTicketForm.jsx`
- Create: `src/pages/support/Support.jsx`

- [ ] **Step 1: useSupport.jsx**

```jsx
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
```

- [ ] **Step 2: SupportTicketForm.jsx**

```jsx
import { useState } from 'react'
import { useSupport } from '@features/courier/hooks/useSupport'
import { GlassCard } from '@components/GlassCard/GlassCard'

const CATEGORIES = ['Sipariş Sorunu', 'Ödeme Sorunu', 'Teknik Problem', 'Diğer']

export const SupportTicketForm = () => {
  const [category, setCategory] = useState('')
  const [message, setMessage] = useState('')
  const { mutate, isPending } = useSupport()

  return (
    <GlassCard className="m-4">
      <div className="flex flex-col gap-4">
        <div>
          <label className="text-xs font-label text-on-surface-variant uppercase tracking-wide block mb-2">Kategori</label>
          <div className="flex flex-wrap gap-2">
            {CATEGORIES.map((c) => (
              <button
                key={c}
                onClick={() => setCategory(c)}
                className={`px-3 py-1.5 rounded-full text-xs font-label transition-colors ${
                  category === c ? 'bg-primary text-white' : 'bg-surface-highest text-on-surface-variant'
                }`}
              >
                {c}
              </button>
            ))}
          </div>
        </div>
        <div>
          <label className="text-xs font-label text-on-surface-variant uppercase tracking-wide block mb-2">Mesajınız</label>
          <textarea
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            rows={4}
            className="w-full bg-surface-high rounded-card px-4 py-3 text-on-surface outline-none focus:ring-1 focus:ring-primary/20 resize-none"
            placeholder="Sorununuzu açıklayın…"
          />
        </div>
        <button
          onClick={() => mutate({ category, message })}
          disabled={!category || !message || isPending}
          className="bg-gradient-to-br from-primary to-primary-container text-white py-3 rounded-card font-semibold disabled:opacity-50"
        >
          {isPending ? 'Gönderiliyor…' : 'Talebi Gönder'}
        </button>
      </div>
    </GlassCard>
  )
}
```

- [ ] **Step 3: Support.jsx page**

```jsx
import { SupportTicketForm } from '@features/courier/components/SupportTicketForm/SupportTicketForm'
import { GlassCard } from '@components/GlassCard/GlassCard'

const FAQ = [
  { q: 'Siparişi iptal edemiyorum', a: 'Sipariş teslim aldıktan sonra destek ile iletişime geçin.' },
  { q: 'Ödeme hesabıma geçmedi', a: 'Ödemeler her Pazartesi işlenir, 2 iş günü içinde yansır.' },
]

const Support = () => (
  <div className="overflow-y-auto h-full pb-4">
    <div className="px-4 pt-4 pb-2">
      <h1 className="text-xl font-semibold text-on-surface">Destek Merkezi</h1>
    </div>
    <div className="flex flex-col gap-3 p-4">
      {FAQ.map((item) => (
        <GlassCard key={item.q}>
          <p className="text-sm font-semibold text-on-surface">{item.q}</p>
          <p className="text-xs text-on-surface-variant mt-1">{item.a}</p>
        </GlassCard>
      ))}
    </div>
    <SupportTicketForm />
  </div>
)

export default Support
```

- [ ] **Step 4: Commit**

```bash
git add . && git commit -m "feat: Destek Merkezi — SupportTicketForm, FAQ"
```

---

## Task 12: Onboarding Feature (Ekran 10-13)

**Files:**
- Create: `src/features/onboarding/hooks/useOnboardingStatus.jsx`
- Create: `src/features/onboarding/hooks/useSelectVehicle.jsx`
- Create: `src/features/onboarding/hooks/useUploadDocument.jsx`
- Create: `src/features/onboarding/hooks/useCompleteTraining.jsx`
- Create: `src/features/onboarding/components/VehicleSelector/VehicleSelector.jsx`
- Create: `src/features/onboarding/components/DocumentUploader/DocumentUploader.jsx`
- Create: `src/features/onboarding/components/TrainingModule/TrainingModule.jsx`
- Create: `src/pages/onboarding/VehicleSelection.jsx`
- Create: `src/pages/onboarding/DocumentUpload.jsx`
- Create: `src/pages/onboarding/Training.jsx`
- Create: `src/pages/onboarding/PendingApproval.jsx`

- [ ] **Step 1: Hook'ları yaz**

`src/features/onboarding/hooks/useOnboardingStatus.jsx`:
```jsx
import { useQuery } from '@tanstack/react-query'
import { getOnboardingStatus } from '@api/onboarding'

export const useOnboardingStatus = () =>
  useQuery({
    queryKey: ['onboarding', 'status'],
    queryFn: () => getOnboardingStatus().then((r) => r.data),
    refetchInterval: 30_000,
  })
```

`src/features/onboarding/hooks/useSelectVehicle.jsx`:
```jsx
import { useMutation } from '@tanstack/react-query'
import { selectVehicle } from '@api/onboarding'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useSelectVehicle = () => {
  const navigate = useNavigate()
  return useMutation({
    mutationFn: selectVehicle,
    onSuccess: () => navigate(Routes.OnboardingDocuments)
  })
}
```

`src/features/onboarding/hooks/useUploadDocument.jsx`:
```jsx
import { useMutation } from '@tanstack/react-query'
import { uploadDocument } from '@api/onboarding'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useUploadDocument = () => {
  const navigate = useNavigate()
  return useMutation({
    mutationFn: ({ type, file }) => uploadDocument(type, file),
    onSuccess: () => navigate(Routes.OnboardingTraining)
  })
}
```

`src/features/onboarding/hooks/useCompleteTraining.jsx`:
```jsx
import { useMutation } from '@tanstack/react-query'
import { completeTraining } from '@api/onboarding'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useCompleteTraining = () => {
  const navigate = useNavigate()
  return useMutation({
    mutationFn: completeTraining,
    onSuccess: () => navigate(Routes.OnboardingPending)
  })
}
```

- [ ] **Step 2: VehicleSelector.jsx yaz (Stitch tasarımı: araç tipi kartlar)**

```jsx
import { useState } from 'react'
import { useSelectVehicle } from '@features/onboarding/hooks/useSelectVehicle'
import { GlassCard } from '@components/GlassCard/GlassCard'

const VEHICLES = [
  { type: 'BICYCLE', label: 'Bisiklet', icon: '🚲', desc: 'Şehir içi, çevre dostu' },
  { type: 'MOTORBIKE', label: 'Motor', icon: '🏍️', desc: 'Hızlı teslimat' },
  { type: 'CAR', label: 'Otomobil', icon: '🚗', desc: 'Büyük siparişler' },
]

export const VehicleSelector = () => {
  const [selected, setSelected] = useState(null)
  const { mutate, isPending } = useSelectVehicle()

  return (
    <div className="flex flex-col gap-4 p-4">
      {VEHICLES.map((v) => (
        <button
          key={v.type}
          onClick={() => setSelected(v.type)}
          className="text-left"
        >
          <GlassCard className={`transition-all ${selected === v.type ? 'ring-2 ring-primary' : ''}`}>
            <div className="flex items-center gap-4">
              <span className="text-4xl">{v.icon}</span>
              <div>
                <p className="font-semibold text-on-surface">{v.label}</p>
                <p className="text-xs text-on-surface-variant">{v.desc}</p>
              </div>
            </div>
          </GlassCard>
        </button>
      ))}
      <button
        onClick={() => selected && mutate(selected)}
        disabled={!selected || isPending}
        className="bg-gradient-to-br from-primary to-primary-container text-white py-3 rounded-card font-semibold disabled:opacity-50 mt-2"
      >
        {isPending ? 'Kaydediliyor…' : 'Devam Et'}
      </button>
    </div>
  )
}
```

- [ ] **Step 3: DocumentUploader.jsx yaz**

```jsx
import { useState } from 'react'
import { useUploadDocument } from '@features/onboarding/hooks/useUploadDocument'
import { GlassCard } from '@components/GlassCard/GlassCard'

const DOCS = [
  { type: 'ID_FRONT', label: 'Kimlik Ön Yüz' },
  { type: 'ID_BACK', label: 'Kimlik Arka Yüz' },
  { type: 'DRIVER_LICENSE', label: 'Sürücü Belgesi' },
]

export const DocumentUploader = () => {
  const [uploaded, setUploaded] = useState({})
  const [current, setCurrent] = useState(null)
  const { mutate, isPending } = useUploadDocument()

  const handleFile = (type, file) => {
    setUploaded((prev) => ({ ...prev, [type]: file.name }))
    setCurrent({ type, file })
  }

  const allDone = DOCS.every((d) => uploaded[d.type])

  return (
    <div className="flex flex-col gap-4 p-4">
      {DOCS.map((doc) => (
        <GlassCard key={doc.type} className={uploaded[doc.type] ? 'ring-1 ring-primary/40' : ''}>
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-on-surface">{doc.label}</p>
              {uploaded[doc.type] && (
                <p className="text-xs text-primary mt-0.5">✓ {uploaded[doc.type]}</p>
              )}
            </div>
            <label className="cursor-pointer">
              <span className="px-3 py-1.5 bg-surface-highest text-on-surface-variant text-xs rounded-full hover:bg-primary/10 transition-colors">
                {uploaded[doc.type] ? 'Değiştir' : 'Yükle'}
              </span>
              <input
                type="file"
                accept="image/*"
                className="hidden"
                onChange={(e) => e.target.files?.[0] && handleFile(doc.type, e.target.files[0])}
              />
            </label>
          </div>
        </GlassCard>
      ))}
      <button
        onClick={() => current && mutate(current)}
        disabled={!allDone || isPending}
        className="bg-gradient-to-br from-primary to-primary-container text-white py-3 rounded-card font-semibold disabled:opacity-50 mt-2"
      >
        {isPending ? 'Yükleniyor…' : 'Belgeleri Gönder'}
      </button>
    </div>
  )
}
```

- [ ] **Step 4: TrainingModule.jsx yaz**

```jsx
import { useState } from 'react'
import { useCompleteTraining } from '@features/onboarding/hooks/useCompleteTraining'
import { GlassCard } from '@components/GlassCard/GlassCard'

const MODULES = [
  { id: 1, title: 'Güvenli Teslimat', duration: '5 dk', icon: '🛡️' },
  { id: 2, title: 'Müşteri İletişimi', duration: '3 dk', icon: '💬' },
  { id: 3, title: 'Uygulama Kullanımı', duration: '4 dk', icon: '📱' },
]

export const TrainingModule = () => {
  const [completed, setCompleted] = useState(new Set())
  const { mutate, isPending } = useCompleteTraining()
  const allDone = completed.size === MODULES.length

  return (
    <div className="flex flex-col gap-4 p-4">
      {MODULES.map((mod) => (
        <button key={mod.id} onClick={() => setCompleted((s) => new Set([...s, mod.id]))} className="text-left">
          <GlassCard className={completed.has(mod.id) ? 'ring-1 ring-primary/40' : ''}>
            <div className="flex items-center gap-4">
              <span className="text-3xl">{mod.icon}</span>
              <div className="flex-1">
                <p className="font-semibold text-on-surface">{mod.title}</p>
                <p className="text-xs text-on-surface-variant">{mod.duration}</p>
              </div>
              {completed.has(mod.id) && <span className="text-primary text-lg">✓</span>}
            </div>
          </GlassCard>
        </button>
      ))}
      <button
        onClick={() => mutate()}
        disabled={!allDone || isPending}
        className="bg-gradient-to-br from-primary to-primary-container text-white py-3 rounded-card font-semibold disabled:opacity-50 mt-2"
      >
        {isPending ? 'Tamamlanıyor…' : 'Eğitimi Tamamla'}
      </button>
    </div>
  )
}
```

- [ ] **Step 5: Onboarding page'leri yaz**

`src/pages/onboarding/VehicleSelection.jsx`:
```jsx
import { VehicleSelector } from '@features/onboarding/components/VehicleSelector/VehicleSelector'

const VehicleSelection = () => (
  <div className="flex flex-col flex-1 overflow-y-auto">
    <div className="px-4 pt-4 pb-2">
      <h1 className="text-2xl font-bold text-on-surface">Araç Türün?</h1>
      <p className="text-on-surface-variant text-sm mt-1">Teslimat yapacağın araç türünü seç.</p>
    </div>
    <VehicleSelector />
  </div>
)

export default VehicleSelection
```

`src/pages/onboarding/DocumentUpload.jsx`:
```jsx
import { DocumentUploader } from '@features/onboarding/components/DocumentUploader/DocumentUploader'

const DocumentUpload = () => (
  <div className="flex flex-col flex-1 overflow-y-auto">
    <div className="px-4 pt-4 pb-2">
      <h1 className="text-2xl font-bold text-on-surface">Belgelerini Yükle</h1>
      <p className="text-on-surface-variant text-sm mt-1">Kimlik ve sürücü belgelerini yükle.</p>
    </div>
    <DocumentUploader />
  </div>
)

export default DocumentUpload
```

`src/pages/onboarding/Training.jsx`:
```jsx
import { TrainingModule } from '@features/onboarding/components/TrainingModule/TrainingModule'

const Training = () => (
  <div className="flex flex-col flex-1 overflow-y-auto">
    <div className="px-4 pt-4 pb-2">
      <h1 className="text-2xl font-bold text-on-surface">Eğitim Modülleri</h1>
      <p className="text-on-surface-variant text-sm mt-1">Tüm modülleri tamamla.</p>
    </div>
    <TrainingModule />
  </div>
)

export default Training
```

`src/pages/onboarding/PendingApproval.jsx`:
```jsx
import { useOnboardingStatus } from '@features/onboarding/hooks/useOnboardingStatus'

const PendingApproval = () => {
  const { data } = useOnboardingStatus()

  return (
    <div className="flex flex-col flex-1 items-center justify-center p-8 text-center gap-6">
      <span className="text-7xl animate-pulse">⏳</span>
      <div>
        <h1 className="text-2xl font-bold text-on-surface">Onay Bekleniyor</h1>
        <p className="text-on-surface-variant mt-2 text-sm">
          Belgeleriniz inceleniyor. Genellikle 24 saat içinde sonuçlanır.
        </p>
      </div>
      {data?.submittedAt && (
        <p className="text-xs text-on-surface-variant font-label">
          Başvuru tarihi: {new Date(data.submittedAt).toLocaleDateString('tr-TR')}
        </p>
      )}
    </div>
  )
}

export default PendingApproval
```

- [ ] **Step 6: Commit**

```bash
git add . && git commit -m "feat: Onboarding akışı — VehicleSelector, DocumentUploader, TrainingModule"
```

---

## Task 13: Admin Paneli (Ekran 14)

**Files:**
- Create: `src/features/admin/hooks/useAdminDashboard.jsx`
- Create: `src/features/admin/components/AdminStats/AdminStats.jsx`
- Create: `src/pages/admin/Admin.jsx`

- [ ] **Step 1: useAdminDashboard.jsx**

```jsx
import { useQuery } from '@tanstack/react-query'
import { getAdminDashboard } from '@api/admin'

export const useAdminDashboard = () =>
  useQuery({
    queryKey: ['admin', 'dashboard'],
    queryFn: () => getAdminDashboard().then((r) => r.data),
    refetchInterval: 60_000,
  })
```

- [ ] **Step 2: AdminStats.jsx**

```jsx
import { useAdminDashboard } from '@features/admin/hooks/useAdminDashboard'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { Loading } from '@components/Loading/Loading'
import { formatCurrency } from '@shared/utils/formatters'

export const AdminStats = () => {
  const { data, isLoading } = useAdminDashboard()

  if (isLoading) return <Loading />

  const stats = [
    { label: 'Aktif Kuryeler', value: data?.activeCouriers ?? 0, mono: false },
    { label: 'Bugünkü Siparişler', value: data?.todayOrders ?? 0, mono: false },
    { label: 'Günlük Ciro', value: formatCurrency(data?.dailyRevenue ?? 0), mono: true },
    { label: 'Onay Bekleyenler', value: data?.pendingApprovals ?? 0, mono: false },
  ]

  return (
    <div className="grid grid-cols-2 gap-3 p-4">
      {stats.map(({ label, value, mono }) => (
        <GlassCard key={label} className="p-4">
          <p className="text-xs text-on-surface-variant mb-1">{label}</p>
          <p className={`text-2xl ${mono ? 'font-mono' : 'font-bold'} text-on-surface`}>{value}</p>
        </GlassCard>
      ))}
    </div>
  )
}
```

- [ ] **Step 3: Admin.jsx page**

```jsx
import { AdminStats } from '@features/admin/components/AdminStats/AdminStats'

const Admin = () => (
  <div className="overflow-y-auto h-full pb-4">
    <div className="px-4 pt-4 pb-2">
      <h1 className="text-xl font-semibold text-on-surface">Yönetici Paneli</h1>
    </div>
    <AdminStats />
  </div>
)

export default Admin
```

- [ ] **Step 4: Commit**

```bash
git add . && git commit -m "feat: Admin paneli — AdminStats, useAdminDashboard"
```

---

## Task 14: Tüm Testleri Çalıştır ve Dev Server Başlat

- [ ] **Step 1: Tüm testleri çalıştır**

```bash
cd /Users/emrullah/developer/fullStack/hızla_ye/hızla-web-app && npx vitest run
```
Beklenen: tüm test'ler PASS

- [ ] **Step 2: Dev server başlat ve ekranları manuel kontrol et**

```bash
npm run dev
```

Kontrol et:
- `http://localhost:5173/login` → Login ekranı görünüyor
- `http://localhost:5173/dashboard` → Token yoksa `/login`'e yönlendiriyor (ProtectedRoute çalışıyor)
- Onboarding flow: `/onboarding/vehicle` → `/onboarding/documents` → `/onboarding/training` → `/onboarding/pending`
- BottomNav linkleri doğru yönlendiriyor

- [ ] **Step 3: anatomy.md güncelle**

```
## hızla-web-app/

- `package.json` — bağımlılıklar ve script'ler (~50 tok)
- `vite.config.js` — path alias'lar, React plugin (~30 tok)
- `tailwind.config.js` — Kinetic Nocturne token'ları (~60 tok)

## hızla-web-app/src/

- `main.jsx` — createRoot → Container → App (~15 tok)
[... vb her dosya için kısa satır]
```

- [ ] **Step 4: Son commit**

```bash
git add . && git commit -m "feat: hızla-web-app MVP tamamlandı — 14 ekran, TDD, feature-based mimari"
```

---

## Verification

### Birim Testler
```bash
cd hızla-web-app && npx vitest run
```
Beklenen: `route-paths`, `authStore`, `ProtectedRoute`, `GlassCard`, `useLogin`, `useActiveOrder` — hepsi PASS.

### E2E Manuel Kontrol (Dev Server)
1. `/login` → form submit → mock API → `/onboarding/vehicle` redirect
2. Onboarding stepper 4 adım boyunca ilerliyor
3. `/dashboard` → MapView yükleniyor, BottomNav aktif
4. `/wallet`, `/earnings`, `/quests`, `/support` sayfaları açılıyor
5. `/order/test-id/verify` → QRScanner görünüyor
6. `/order/test-id/rate` → EmojiRating görünüyor
7. `/admin` → AdminStats grid görünüyor

### Dosya Yapısı Doğrulama
```bash
find hızla-web-app/src -name "*.jsx" | sort
```
Beklenen: 60+ dosya, WEB-APPARCHITECTURE.md'deki katmanların tamamı mevcut.
