-- 002_index_triggers.sql

-- Users
CREATE INDEX IF NOT EXISTS idx_users_name ON users(name);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Auth Identities
CREATE INDEX IF NOT EXISTS idx_auth_identities_provider ON auth_identities(provider);

-- Routines
CREATE INDEX IF NOT EXISTS idx_routines_user_id ON routines(user_id);
CREATE INDEX IF NOT EXISTS idx_routines_difficulty_id ON routines(difficulty_id);

-- Exercises
CREATE INDEX IF NOT EXISTS idx_exercises_user_id ON exercises(user_id);
CREATE INDEX IF NOT EXISTS idx_exercises_category_id ON exercises(category_id);
CREATE INDEX IF NOT EXISTS idx_exercises_time_unit_id ON exercises(time_unit_id);
CREATE INDEX IF NOT EXISTS idx_exercises_weight_unit_id ON exercises(weight_unit_id);

-- Routine History
CREATE INDEX IF NOT EXISTS idx_routine_history_user_id ON routine_history(user_id);
CREATE INDEX IF NOT EXISTS idx_routine_history_routine_id ON routine_history(routine_id);
CREATE INDEX IF NOT EXISTS idx_routine_history_performed_at ON routine_history(performed_at);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach triggers to tables with updated_at column
CREATE TRIGGER trg_update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_update_routines_updated_at
BEFORE UPDATE ON routines
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_update_exercises_updated_at
BEFORE UPDATE ON exercises
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();