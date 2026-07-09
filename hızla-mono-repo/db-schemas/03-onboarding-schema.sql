-- 03-onboarding-schema.sql

CREATE TABLE IF NOT EXISTS onboarding.applications (
  app_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID UNIQUE NOT NULL REFERENCES auth.users(user_id),
  status        shared.onboarding_status NOT NULL DEFAULT 'pending',
  vehicle_type  shared.vehicle_type,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS onboarding.documents (
  doc_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id      UUID NOT NULL REFERENCES onboarding.applications(app_id),
  type        shared.document_type NOT NULL,
  file_path   TEXT NOT NULL,
  status      shared.document_status NOT NULL DEFAULT 'pending',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS onboarding.training_completions (
  tc_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id       UUID UNIQUE NOT NULL REFERENCES onboarding.applications(app_id),
  completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
