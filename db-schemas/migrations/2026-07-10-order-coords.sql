-- 2026-07-10-order-coords.sql
-- Sipariş ve kurye konum koordinatları + platform alanı ekler.

ALTER TABLE courier.orders
  ADD COLUMN IF NOT EXISTS platform      VARCHAR(30) NOT NULL DEFAULT 'unknown',
  ADD COLUMN IF NOT EXISTS pickup_lat    DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS pickup_lng    DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS delivery_lat  DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS delivery_lng  DOUBLE PRECISION;

ALTER TABLE courier.couriers
  ADD COLUMN IF NOT EXISTS last_lat            DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS last_lng            DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS location_updated_at TIMESTAMPTZ;

UPDATE courier.orders
SET platform = 'yemeksepeti',
    pickup_lat = 41.0430,
    pickup_lng = 29.0090,
    delivery_lat = 41.0480,
    delivery_lng = 29.0150
WHERE order_id = 'd0000000-0000-0000-0000-000000000001';
