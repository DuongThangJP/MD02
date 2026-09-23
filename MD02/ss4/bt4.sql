SELECT * FROM student_manage_database.students;

UPDATE students
SET email = NULL
WHERE email = 'lehoangd@gmail.com';

SELECT * FROM students
WHERE email IS NULL;

SELECT * FROM students
WHERE email IS NOT NULL;

SELECT * FROM students
WHERE  full_name LIKE 'Ng%';

SELECT * FROM students
WHERE gender <> 'male';