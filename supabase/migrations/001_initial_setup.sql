-- 001_initial_setup.sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    photo_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS auth_identities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider VARCHAR(50) NOT NULL,
    provider_user_id VARCHAR(255) NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_auth_identities_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_provider_user
        UNIQUE (provider, provider_user_id)
);

CREATE INDEX IF NOT EXISTS idx_auth_identities_user_id ON auth_identities(user_id);

CREATE TABLE IF NOT EXISTS difficulties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS routines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    difficulty_id UUID NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,

    CONSTRAINT fk_routine_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_routine_difficulty
        FOREIGN KEY (difficulty_id)
        REFERENCES difficulties(id)
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS time_units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    symbol VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS weight_units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    symbol VARCHAR(10) NOT NULL
);

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL
);

CREATE TABLE exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    sets INT,
    reps INT,
    duration NUMERIC,  -- store duration as number (e.g., 30)
    weight NUMERIC,    -- store weight as number (e.g., 20.5)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    time_unit_id UUID,
    weight_unit_id UUID,
    category_id UUID,
    user_id UUID NOT NULL,

    -- Foreign keys
    CONSTRAINT fk_exercise_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_exercise_time_unit
        FOREIGN KEY (time_unit_id)
        REFERENCES time_units(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_exercise_weight_unit
        FOREIGN KEY (weight_unit_id)
        REFERENCES weight_units(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_exercise_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON DELETE SET NULL
);

CREATE TABLE images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description VARCHAR(255),
    path VARCHAR(500) NOT NULL,
    exercise_id UUID NOT NULL,

    -- Foreign key
    CONSTRAINT fk_image_exercise
        FOREIGN KEY (exercise_id)
        REFERENCES exercises(id)
        ON DELETE CASCADE
);

CREATE TABLE muscles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL
);

CREATE TABLE muscle_exercises (
    exercise_id UUID NOT NULL,
    muscle_id UUID NOT NULL,

    PRIMARY KEY (exercise_id, muscle_id),

    CONSTRAINT fk_muscle_exercise_exercise
        FOREIGN KEY (exercise_id)
        REFERENCES exercises(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_muscle_exercise_muscle
        FOREIGN KEY (muscle_id)
        REFERENCES muscles(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS routine_exercises (
    exercise_id UUID NOT NULL,
    routine_id UUID NOT NULL,

    PRIMARY KEY (exercise_id, routine_id),

    CONSTRAINT fk_routine_exercise_routine
        FOREIGN KEY (routine_id)
        REFERENCES routines(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_routine_exercise_exercise
        FOREIGN KEY (exercise_id)
        REFERENCES exercises(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS days (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL
);

CREATE TABLE scheduled_routines (
    day_id UUID NOT NULL,
    routine_id UUID NOT NULL,

    PRIMARY KEY (day_id, routine_id),

    CONSTRAINT fk_scheduled_routines_day
        FOREIGN KEY (day_id)
        REFERENCES days(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_scheduled_routines_routine
        FOREIGN KEY (routine_id)
        REFERENCES routines(id)
        ON DELETE CASCADE
);

CREATE TABLE routine_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    performed_at DATE NOT NULL,
    routine_id UUID NOT NULL,
    user_id UUID NOT NULL,

    -- Foreign keys
    CONSTRAINT fk_routine_history_routine
        FOREIGN KEY (routine_id)
        REFERENCES routines(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_routine_history_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);