-- 05-seed-data.sql
-- Şifreler bcrypt hash: 'admin123' ve 'test123'

-- Admin kullanıcı
INSERT INTO auth.users (user_id, user_phone, user_password_hash, user_role)
VALUES (
  'a0000000-0000-0000-0000-000000000001',
  '+905550000001',
  '$2b$10$ZKnF1t4heDOCRwjVqcRJTOX9YYxwUQeBqO9QSKx8qDYg6rPsWKExe', -- admin123
  'admin'
) ON CONFLICT DO NOTHING;

-- Test kurye kullanıcı
INSERT INTO auth.users (user_id, user_phone, user_password_hash, user_role)
VALUES (
  'a0000000-0000-0000-0000-000000000002',
  '+905550000002',
  '$2b$10$tDvMZMV.huyo/ILbwQANg.f.cPdAg0swJd6rcyRW2/ER7.bK4ReZ.', -- test123
  'courier'
) ON CONFLICT DO NOTHING;

-- Test kurye profili
INSERT INTO courier.couriers (courier_id, courier_user_id, name, phone, vehicle_type)
VALUES (
  'b0000000-0000-0000-0000-000000000001',
  'a0000000-0000-0000-0000-000000000002',
  'Test Kurye',
  '+905550000002',
  'motorcycle'
) ON CONFLICT DO NOTHING;

-- Test kurye cüzdanı
INSERT INTO courier.wallet (courier_id, balance, pending)
VALUES (
  'b0000000-0000-0000-0000-000000000001',
  250.00,
  75.00
) ON CONFLICT DO NOTHING;

-- Questler
INSERT INTO courier.quests (quest_id, title, description, reward, target_count, rarity)
VALUES
  ('c0000000-0000-0000-0000-000000000001', 'İlk 5 Sipariş', '5 sipariş tamamla', 50.00, 5, 'common'),
  ('c0000000-0000-0000-0000-000000000002', 'Hız Ustası', '10 dakikada 3 teslimat yap', 100.00, 3, 'rare'),
  ('c0000000-0000-0000-0000-000000000003', 'Efsane Kurye', '50 sipariş tamamla', 500.00, 50, 'legendary')
ON CONFLICT DO NOTHING;

-- Test sipariş
INSERT INTO courier.orders (order_id, courier_id, restaurant_name, pickup_addr, delivery_addr, status, amount, fee, distance_meters, qr_code)
VALUES (
  'd0000000-0000-0000-0000-000000000001',
  'b0000000-0000-0000-0000-000000000001',
  'Burger Palace',
  'Bağcılar Mah. Atatürk Cad. No:1',
  'Güneşli Mah. 1234 Sok. No:5',
  'accepted',
  85.00,
  12.50,
  2300,
  'QR-TEST-001'
) ON CONFLICT DO NOTHING;
