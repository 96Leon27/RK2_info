CREATE TABLE students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT,
    group_number TEXT
);

CREATE TABLE subjects (
    subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_name TEXT
);

CREATE TABLE grades (
    grade_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INT REFERENCES students(student_id),
    subject_id INT REFERENCES subjects(subject_id),
    grade INT
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INT REFERENCES students(student_id),
    date_attended DATE,
    status BOOLEAN
);

CREATE TABLE notes (
    note_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INT REFERENCES students(student_id),
    note_text TEXT
);

-- Вставка данных в таблицу students
INSERT INTO students (full_name, group_number) VALUES
('Иванов Петр Сергеевич', 'ГР-101'),
('Смирнова Анна Владимировна', 'ГР-101'),
('Козлов Дмитрий Иванович', 'ГР-102'),
('Новикова Екатерина Андреевна', 'ГР-102'),
('Васильев Алексей Петрович', 'ГР-101'),
('Федорова Мария Сергеевна', 'ГР-103'),
('Морозов Илья Дмитриевич', 'ГР-103'),
('Павлова Ольга Алексеевна', 'ГР-101');

-- Вставка данных в таблицу subjects
INSERT INTO subjects (subject_name) VALUES
('Математика'),
('Физика'),
('История'),
('Информатика'),
('Английский язык');

-- Вставка данных в таблицу grades
INSERT INTO grades (student_id, subject_id, grade) VALUES
(1, 1, 5),
(1, 2, 4),
(1, 4, 5),
(2, 1, 5),
(2, 3, 4),
(2, 5, 5),
(3, 2, 3),
(3, 4, 4),
(4, 1, 5),
(4, 5, 4),
(5, 2, 3),
(5, 3, 4),
(6, 1, 5),
(6, 4, 4),
(7, 3, 3),
(7, 5, 4),
(8, 1, 5),
(8, 2, 4);

-- Вставка данных в таблицу attendance
INSERT INTO attendance (student_id, date_attended, status) VALUES
(1, '2024-01-10', 1),
(1, '2024-01-12', 1),
(1, '2024-01-15', 0),
(2, '2024-01-10', 1),
(2, '2024-01-12', 1),
(3, '2024-01-10', 0),
(3, '2024-01-15', 1),
(4, '2024-01-10', 1),
(4, '2024-01-12', 1),
(5, '2024-01-15', 1),
(6, '2024-01-10', 0),
(7, '2024-01-12', 1),
(8, '2024-01-15', 1);

-- Вставка данных в таблицу notes
INSERT INTO notes (student_id, note_text) VALUES
(1, 'Активно участвует на занятиях по математике'),
(2, 'Отличные лидерские качества'),
(3, 'Пропустил 2 занятия информатики без уважительной причины'),
(4, 'Показывает высокие результаты по английскому'),
(5, 'Нужно улучшить успеваемость по физике'),
(6, 'Победитель олимпиады по информатике'),
(7, 'Стабильная успеваемость');

CREATE INDEX idx_group ON students(group_number);
CREATE INDEX idx_grades ON grades(student_id);
CREATE INDEX idx_notes ON notes USING gin(to_tsvector('russian', note_text));

CREATE VIEW student_avg AS
SELECT s.student_id, s.full_name, AVG(g.grade) as avg_grade
FROM students s JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id, s.full_name;

BEGIN;
INSERT INTO students (full_name, group_number) VALUES ('Новенький', 'ГР-101');
INSERT INTO grades (student_id, subject_id, grade) 
VALUES (7,1,4), (7,2,5), (7,3,4);
COMMIT;

SELECT * FROM students 
WHERE group_number='ГР-101' AND student_id BETWEEN 1 AND 6
ORDER BY student_id
LIMIT 5;

SELECT avg_grade FROM student_avg WHERE student_id=1;

SELECT AVG(grade) FROM grades 
WHERE subject_id=(SELECT subject_id FROM subjects WHERE subject_name='Информатика');

SELECT * FROM notes WHERE note_text LIKE '%информатик%';

BEGIN;
UPDATE attendance SET status=0 
WHERE student_id=2 AND date_attended='2024-01-10';
COMMIT;
