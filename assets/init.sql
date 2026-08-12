-- NoKoDo Database Initialization Script for SQLite (Flutter App)

PRAGMA foreign_keys = ON;

-- 1. Create Tables
CREATE TABLE IF NOT EXISTS teacher (
    uid TEXT PRIMARY KEY,
    firstname TEXT NOT NULL,
    lastname TEXT,
    email TEXT UNIQUE NOT NULL,
    passwordHash TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS class (
    id TEXT PRIMARY KEY,
    className TEXT NOT NULL,
    teacherid TEXT NOT NULL REFERENCES teacher(uid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS student (
    uid TEXT PRIMARY KEY,
    firstname TEXT NOT NULL,
    lastname TEXT,
    email TEXT UNIQUE NOT NULL,
    passwordHash TEXT NOT NULL,
    classid TEXT NOT NULL DEFAULT '1' REFERENCES class(id),
    totalTime INTEGER NOT NULL DEFAULT 0,
    gender TEXT,
    dateOfBirth INTEGER
);

CREATE TABLE IF NOT EXISTS lesson (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    type INTEGER NOT NULL,
    description TEXT NOT NULL,
    content TEXT NOT NULL DEFAULT '{}',
    difficulty INTEGER NOT NULL,
    dateCreated INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS test (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    dateCreated INTEGER NOT NULL,
    timeLimit INTEGER NOT NULL,
    allowedAttempts INTEGER NOT NULL,
    difficulty INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS question (
    id TEXT PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    isMultipleChoice INTEGER NOT NULL,
    choices TEXT NOT NULL,
    testid TEXT NOT NULL REFERENCES test(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS student_lesson (
    studentid TEXT NOT NULL REFERENCES student(uid) ON DELETE CASCADE,
    lessonid TEXT NOT NULL REFERENCES lesson(id) ON DELETE CASCADE,
    results TEXT NOT NULL,
    PRIMARY KEY (studentid, lessonid)
);

CREATE TABLE IF NOT EXISTS student_test_status (
    studentid TEXT NOT NULL REFERENCES student(uid) ON DELETE CASCADE,
    testid TEXT NOT NULL REFERENCES test(id) ON DELETE CASCADE,
    dateCreated INTEGER NOT NULL,
    dateFinished INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    result REAL NOT NULL,
    PRIMARY KEY (studentid, testid, dateCreated)
);

CREATE TABLE IF NOT EXISTS student_answer (
    studentid TEXT NOT NULL,
    testid TEXT NOT NULL,
    dateCreated INTEGER NOT NULL,
    questionid TEXT NOT NULL REFERENCES question(id) ON DELETE CASCADE,
    answer TEXT,
    PRIMARY KEY (studentid, testid, dateCreated, questionid),
    FOREIGN KEY (studentid, testid, dateCreated) REFERENCES student_test_status(studentid, testid, dateCreated) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS class_lesson (
    classid TEXT NOT NULL REFERENCES class(id) ON DELETE CASCADE,
    lessonid TEXT NOT NULL REFERENCES lesson(id) ON DELETE CASCADE,
    PRIMARY KEY (classid, lessonid)
);

CREATE TABLE IF NOT EXISTS class_test (
    testid TEXT NOT NULL REFERENCES test(id) ON DELETE CASCADE,
    classid TEXT NOT NULL REFERENCES class(id) ON DELETE CASCADE,
    PRIMARY KEY (testid, classid)
);

CREATE TABLE IF NOT EXISTS dictionary_entry (
    id TEXT PRIMARY KEY,
    word TEXT NOT NULL,
    description TEXT NOT NULL,
    imageName TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS system_config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

-- 2. Insert Teachers
INSERT OR IGNORE INTO teacher (uid, firstname, lastname, email, passwordHash) VALUES
('teacher_mock_123', 'Alex', 'Smith', 'teacher@nokodo.edu.vn', '$argon2id$v=19$m=65536,t=3,p=4$MockHashTeacher1'),
('teacher_mock_456', 'Alex', 'Stevehehe', 'teacher2@nokodo.edu.vn', '$argon2id$v=19$m=65536,t=3,p=4$MockHashTeacher2');

-- 3. Insert Classes
INSERT OR IGNORE INTO class (id, className, teacherid) VALUES
('1', 'Lop 1', 'teacher_mock_123'),
('2', 'Lop 2', 'teacher_mock_123'),
('3', 'Lop trong', 'teacher_mock_456');

-- 4. Insert Students
INSERT OR IGNORE INTO student (uid, firstname, lastname, email, passwordHash, classid, gender, dateOfBirth, totalTime) VALUES
('ZgDTxfh7uWgYIdxcX0zEK2acvuD2', 'Hung', 'CaoXuan', 'hung@nokodo.edu.vn', '$argon2id$v=19$m=65536,t=3,p=4$MockHashStudent1', '1', 'Nam', 100000, 0),
('RFIST5LFObX3pl7v55fzABuWqNC3', 'Bob', 'Vietnam', 'bob@nokodo.edu.vn', '$argon2id$v=19$m=65536,t=3,p=4$MockHashStudent2', '1', 'Nữ', 100000, 0),
('MrBq1EAfvoYAswZZfJrbGSM2jIj1', 'John', 'Doe', 'john@nokodo.edu.vn', '$argon2id$v=19$m=65536,t=3,p=4$MockHashStudent3', '2', 'Nam', 100000, 0);

-- 5. Insert Lessons
INSERT OR IGNORE INTO lesson (id, name, type, description, content, difficulty, dateCreated) VALUES
('1', 'Giới thiệu về vần a, ă, â', 0, 'Bài tập đọc nho nhỏ dành cho các em', '{"text": "Ba bà cháu gây dựng trang trại mật ong. Mọi người ăn mật ong thật ngon lành."}', 1, 1778412562),
('2', 'Giới thiệu về vần b, d, p, q', 0, 'Bài tập đọc nho nhỏ dành cho các em thứ 2', '{"text": "Pa pa pi po, bo ba bo bo, do di de do, bo ho bo ho. Pa pa pi po, bo ba bo bo, do di de do, bo ho bo ho."}', 1, 1778412562),
('3', 'Trò chơi tìm chữ a', 1, 'Trò chơi tìm chữ hi hi hi', '{"cases":[{"height":7,"width":9,"target":"d","noise":["b","p","q"],"chance":0.35,"gap":0,"spacing":0.0,"size":42.0},{"height":7,"width":9,"target":"t","noise":["f","l","i"],"chance":0.40,"gap":0,"spacing":6.0,"size":28.0},{"height":7,"width":9,"target":"n","noise":["u","m","h"],"chance":0.45,"gap":0,"spacing":2.0,"size":56.0},{"height":5,"width":7,"target":"ă","noise":["a","ã","â"],"chance":0.80,"gap":0,"spacing":1.0,"size":40.0},{"height":5,"width":11,"target":"ê","noise":["ẽ","è","é"],"chance":0.80,"gap":0,"spacing":3.0,"size":66.0}]}', 1, 1778412562);

-- 6. Insert Tests
INSERT OR IGNORE INTO test (id, name, dateCreated, timeLimit, allowedAttempts, difficulty) VALUES
('123', 'Test 1', 100000, 180, 3, 0),
('456', 'Test 2', 101000, 300, 3, 1),
('789', 'Bài kiểm tra thử', 1000000, 300, 3, 2);

-- 7. Insert ClassTest Mappings
INSERT OR IGNORE INTO class_test (classid, testid) VALUES
('1', '123'),
('1', '456'),
('1', '789'),
('2', '456'),
('2', '789');

-- 8. Insert ClassLesson Mappings
INSERT OR IGNORE INTO class_lesson (classid, lessonid) VALUES
('1', '1'),
('1', '2'),
('2', '1'),
('2', '2'),
('2', '3');

-- 9. Insert Questions
INSERT OR IGNORE INTO question (id, question, answer, isMultipleChoice, choices, testid) VALUES
('1231', 'Con vet la con gi?', 'Con chim', 1, '["Con trung", "Con chim", "Nam", "C"]', '123'),
('1232', 'Tren troi co con gi?', 'Con chim', 1, '["Con chim", "Con bo", "Con ho", "Ca"]', '123'),
('1233', 'Tren troi co con gi?', 'Con chim', 1, '["Con chim", "Con cho", "Con meo", "Con"]', '123'),
('1234', 'Mot con vit xoe ra hai cai canh, no', 'quac quac quac quac quac quac', 0, '[]', '123'),
('4561', 'Mot con vit xoe ra hai cai canh, no', 'quac quac quac quac quac quac', 0, '[]', '456'),
('4562', 'Placeholder', '3', 1, '["1", "2", "3", "4"]', '456'),
('7891', 'Đây là câu hỏi 1 (đáp án là "đáp án đúng")', 'đáp án đúng', 0, '[]', '789'),
('7892', 'Đây là câu hỏi 2', 'đáp án đúng', 1, '["Đáp án 1", "Đáp án 2", "Đáp án đúng", "A"]', '789'),
('7893', 'Đây là câu hỏi 3', 'đáp án đúng', 1, '["Đáp án 1", "Đáp án 2", "Đáp án đúng", "A"]', '789'),
('7894', 'Đây là câu hỏi 4', 'đáp án đúng', 0, '[]', '789'),
('7895', 'Đây là câu hỏi 5', 'đáp án đúng', 1, '["Đáp án 1", "Đáp án 2", "Đáp án đúng", "A"]', '789'),
('7896', 'Đây là câu hỏi 6', 'đáp án đúng', 1, '["Đáp án 1", "Đáp án 2", "Đáp án đúng", "A"]', '789'),
('7897', 'Đây là câu hỏi 7', 'đáp án đúng', 0, '[]', '789'),
('7898', 'Đây là câu hỏi 8', 'đáp án đúng', 1, '["Đáp án 1", "Đáp án 2", "Đáp án đúng", "as"]', '789');

-- 10. Insert Dictionary Entries
INSERT OR IGNORE INTO dictionary_entry (id, word, description, imageName) VALUES
('1', 'cây bàng', 'Tropical Almond tree.', 'cây_bàng.jpg'),
('2', 'cây bưởi', 'Pomelo tree.', 'cây_bưởi.jpg'),
('3', 'cây dứa', 'Pineapple plant.', 'cây_dứa.jpg'),
('4', 'con chim', 'Generic word for a bird.', 'con_chim.jpg'),
('5', 'con cún', 'Affectionate term for a puppy.', 'con_cún.jpg'),
('6', 'con trâu', 'Water buffalo.', 'con_trâu.jpg');

-- 11. Insert System Configs
INSERT OR IGNORE INTO system_config (key, value) VALUES
('dictVersion', 'v1');
