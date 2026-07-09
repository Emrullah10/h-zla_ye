-- 04-admin-schema.sql

CREATE TABLE IF NOT EXISTS admin.admin_actions (
  action_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id    UUID NOT NULL REFERENCES auth.users(user_id),
  action_type shared.admin_action_type NOT NULL,
  target_id   UUID NOT NULL,
  notes       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
