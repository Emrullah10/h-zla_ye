-- 00-enums-schema.sql

CREATE SCHEMA IF NOT EXISTS shared;
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS courier;
CREATE SCHEMA IF NOT EXISTS onboarding;
CREATE SCHEMA IF NOT EXISTS admin;

CREATE TYPE shared.user_role AS ENUM ('courier', 'admin');
CREATE TYPE shared.vehicle_type AS ENUM ('bicycle', 'motorcycle', 'car');
CREATE TYPE shared.order_status AS ENUM ('pending', 'accepted', 'picked_up', 'delivered', 'rejected', 'cancelled');
CREATE TYPE shared.onboarding_status AS ENUM ('pending', 'documents_uploaded', 'training_complete', 'approved', 'rejected');
CREATE TYPE shared.document_type AS ENUM ('id_front', 'id_back', 'license_front', 'license_back', 'vehicle_registration');
CREATE TYPE shared.document_status AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE shared.support_category AS ENUM ('payment', 'order', 'technical', 'other');
CREATE TYPE shared.support_status AS ENUM ('open', 'in_progress', 'resolved', 'closed');
CREATE TYPE shared.transaction_type AS ENUM ('credit', 'debit');
CREATE TYPE shared.quest_rarity AS ENUM ('common', 'rare', 'epic', 'legendary');
CREATE TYPE shared.admin_action_type AS ENUM ('approve_driver', 'reject_driver', 'suspend_driver', 'unsuspend_driver');
