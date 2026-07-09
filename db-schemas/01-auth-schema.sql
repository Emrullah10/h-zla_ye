-- 01-auth-schema.sql

CREATE TABLE IF NOT EXISTS auth.users (
  user_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_phone      VARCHAR(20) UNIQUE NOT NULL,
  user_password_hash TEXT NOT NULL,
  user_role       shared.user_role NOT NULL DEFAULT 'courier',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Refresh token'lar Redis'te saklanır: rt:{userId} → { token, userId }, TTL=7gün
