-- 02-courier-schema.sql

CREATE TABLE IF NOT EXISTS courier.couriers (
  courier_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  courier_user_id UUID UNIQUE NOT NULL REFERENCES auth.users(user_id),
  name            VARCHAR(100) NOT NULL,
  phone           VARCHAR(20) NOT NULL,
  status          VARCHAR(20) NOT NULL DEFAULT 'offline',
  vehicle_type    shared.vehicle_type NOT NULL,
  rating          NUMERIC(3,2) NOT NULL DEFAULT 5.00,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS courier.orders (
  order_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  courier_id        UUID REFERENCES courier.couriers(courier_id),
  restaurant_name   VARCHAR(100) NOT NULL,
  pickup_addr       TEXT NOT NULL,
  delivery_addr     TEXT NOT NULL,
  status            shared.order_status NOT NULL DEFAULT 'pending',
  amount            NUMERIC(10,2) NOT NULL DEFAULT 0,
  fee               NUMERIC(10,2) NOT NULL DEFAULT 0,
  distance_meters   INTEGER NOT NULL DEFAULT 0,
  qr_code           VARCHAR(200),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS courier.order_ratings (
  rating_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id          UUID UNIQUE NOT NULL REFERENCES courier.orders(order_id),
  courier_id        UUID NOT NULL REFERENCES courier.couriers(courier_id),
  restaurant_rating SMALLINT NOT NULL CHECK (restaurant_rating BETWEEN 1 AND 5),
  comment           TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS courier.support_tickets (
  ticket_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  courier_id  UUID NOT NULL REFERENCES courier.couriers(courier_id),
  category    shared.support_category NOT NULL,
  subject     VARCHAR(200) NOT NULL,
  message     TEXT NOT NULL,
  status      shared.support_status NOT NULL DEFAULT 'open',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS courier.wallet (
  wallet_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  courier_id  UUID UNIQUE NOT NULL REFERENCES courier.couriers(courier_id),
  balance     NUMERIC(10,2) NOT NULL DEFAULT 0,
  pending     NUMERIC(10,2) NOT NULL DEFAULT 0,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS courier.transactions (
  tx_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  courier_id  UUID NOT NULL REFERENCES courier.couriers(courier_id),
  order_id    UUID REFERENCES courier.orders(order_id),
  amount      NUMERIC(10,2) NOT NULL,
  type        shared.transaction_type NOT NULL,
  description VARCHAR(200),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS courier.quests (
  quest_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         VARCHAR(100) NOT NULL,
  description   TEXT NOT NULL,
  reward        NUMERIC(10,2) NOT NULL DEFAULT 0,
  target_count  INTEGER NOT NULL DEFAULT 1,
  rarity        shared.quest_rarity NOT NULL DEFAULT 'common',
  expires_at    TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS courier.courier_quests (
  cq_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  courier_id   UUID NOT NULL REFERENCES courier.couriers(courier_id),
  quest_id     UUID NOT NULL REFERENCES courier.quests(quest_id),
  progress     INTEGER NOT NULL DEFAULT 0,
  completed_at TIMESTAMPTZ,
  UNIQUE(courier_id, quest_id)
);
