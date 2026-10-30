-- Опис таблиць системи BallAR-Tracker

CREATE TABLE Users ( -- Опис користувачів
    user_id NUMERIC(8), -- Ідентифікатор користувача
    username VARCHAR(30), -- Логін користувача
    email VARCHAR(255), -- Електронна пошта
    password_hash VARCHAR(255), -- Хеш пароля
    created_date DATE -- Дата реєстрації
);

CREATE TABLE ExercisePrograms ( -- Опис програм тренувань
    program_id NUMERIC(8), -- Ідентифікатор програми
    program_name VARCHAR(50), -- Назва програми
    difficulty_level_name VARCHAR(10), -- Рівень складності
    target_reps_num NUMERIC(4), -- Цільова кількість повторень
    description VARCHAR(255) -- Опис вправи
);

CREATE TABLE TrainingSessions ( -- Опис сесій тренувань
    session_id NUMERIC(8), -- Ідентифікатор сесії
    user_id NUMERIC(8), -- Ідентифікатор користувача
    program_id NUMERIC(8), -- Ідентифікатор програми
    session_date DATE, -- Дата проведення
    duration_seconds_num NUMERIC(6), -- Тривалість у секундах
    total_reps_num NUMERIC(4), -- Кількість повторень
    success_rate_num NUMERIC(5,2) -- Відсоток успішності
);

CREATE TABLE ARMarkerTrackings ( -- Опис точок трекінгу AR-маркера
    tracking_id NUMERIC(8), -- Ідентифікатор запису
    session_id NUMERIC(8), -- Ідентифікатор сесії
    frame_timestamp DATE, -- Точний час кадру
    coord_x_num NUMERIC(8,3), -- Координата X
    coord_y_num NUMERIC(8,3), -- Координата Y
    coord_z_num NUMERIC(8,3), -- Координата Z (глибина)
    rotation_angle_num NUMERIC(5,2) -- Кут обертання
);

CREATE TABLE FeedbackNotifiers ( -- Опис сповіщень зворотного зв'язку
    feedback_id NUMERIC(8), -- Ідентифікатор сповіщення
    session_id NUMERIC(8), -- Ідентифікатор сесії
    feedback_type_name VARCHAR(10), -- Тип сповіщення (Visual/Audio)
    sensitivity_threshold_num NUMERIC(3,2), -- Поріг чутливості
    message_text VARCHAR(255) -- Текст підказки
);


/* Команди обмеження цілісності даних */

-- Встановлення обов'язкових полів (NOT NULL) та унікальності (UNIQUE)
ALTER TABLE Users ALTER COLUMN username SET NOT NULL;
ALTER TABLE Users ALTER COLUMN email SET NOT NULL;
ALTER TABLE Users ADD CONSTRAINT Users_username_unique UNIQUE (username);
ALTER TABLE Users ADD CONSTRAINT Users_email_unique UNIQUE (email);

ALTER TABLE ExercisePrograms ALTER COLUMN program_name SET NOT NULL;
ALTER TABLE TrainingSessions ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE TrainingSessions ALTER COLUMN program_id SET NOT NULL;
ALTER TABLE ARMarkerTrackings ALTER COLUMN session_id SET NOT NULL;
ALTER TABLE FeedbackNotifiers ALTER COLUMN session_id SET NOT NULL;


-- Встановлення обмеження первинного ключа (PRIMARY KEY)
ALTER TABLE Users ADD CONSTRAINT Users_pk PRIMARY KEY (user_id);
ALTER TABLE ExercisePrograms ADD CONSTRAINT ExercisePrograms_pk PRIMARY KEY (program_id);
ALTER TABLE TrainingSessions ADD CONSTRAINT TrainingSessions_pk PRIMARY KEY (session_id);
ALTER TABLE ARMarkerTrackings ADD CONSTRAINT ARMarkerTrackings_pk PRIMARY KEY (tracking_id);
ALTER TABLE FeedbackNotifiers ADD CONSTRAINT FeedbackNotifiers_pk PRIMARY KEY (feedback_id);


-- Встановлення обмеження зовнішнього ключа (FOREIGN KEY)
ALTER TABLE TrainingSessions ADD CONSTRAINT TrainingSessions_user_fk
    FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE TrainingSessions ADD CONSTRAINT TrainingSessions_program_fk
    FOREIGN KEY (program_id) REFERENCES ExercisePrograms(program_id);

ALTER TABLE ARMarkerTrackings ADD CONSTRAINT ARMarkerTrackings_session_fk
    FOREIGN KEY (session_id) REFERENCES TrainingSessions(session_id);

ALTER TABLE FeedbackNotifiers ADD CONSTRAINT FeedbackNotifiers_session_fk
    FOREIGN KEY (session_id) REFERENCES TrainingSessions(session_id);


-- Встановлення обмежень змісту стовпців таблиць (CHECK)
ALTER TABLE ExercisePrograms ADD CONSTRAINT ExercisePrograms_difficulty_check
    CHECK (difficulty_level_name IN ('Easy', 'Medium', 'Hard'));

ALTER TABLE TrainingSessions ADD CONSTRAINT TrainingSessions_success_rate_range
    CHECK (success_rate_num BETWEEN 0.0 AND 100.0);

ALTER TABLE FeedbackNotifiers ADD CONSTRAINT FeedbackNotifiers_type_check
    CHECK (feedback_type_name IN ('Visual', 'Audio'));


-- Перевірка за допомогою регулярних виразів
ALTER TABLE Users ADD CONSTRAINT Users_username_template
    CHECK (username ~ '^[a-zA-Z0-9_]{3,30}$');

ALTER TABLE Users ADD CONSTRAINT Users_email_template
    CHECK (email ~ '^([a-z0-9][a-z0-9._-]*@[a-z][a-z0-9._-]*\.[a-z]{2,4})$');
