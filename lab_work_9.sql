-- Практична робота 9. Варіант 1 — Бібліотека
-- Продовження lab_work_8.db. Структура таблиць не змінюється.
PRAGMA foreign_keys = ON;

-- Завдання 1. Групування фактової таблиці за FK book_id.
SELECT book_id, COUNT(*) AS loans_count
FROM loans
GROUP BY book_id
ORDER BY book_id;
-- Результат (book_id | loans_count):
-- 1 | 1
-- 2 | 1
-- 3 | 2
-- 4 | 1
-- 5 | 1
-- 6 | 1

-- Завдання 2. Зрозумілий звіт: назва книги замість book_id.
-- LEFT JOIN зберігає книги без жодної видачі.
SELECT b.title AS book_title,
       COUNT(l.id) AS loans_count
FROM books AS b
LEFT JOIN loans AS l ON l.book_id = b.id
GROUP BY b.id
ORDER BY b.id;
-- Результат (book_title | loans_count):
-- Тигролови | 1
-- Кобзар | 1
-- Лісова пісня | 2
-- Місто | 1
-- Захар Беркут | 1
-- Чорна рада | 1
-- Кайдашева сім'я | 0

-- Завдання 3. Кількість видач і середня тривалість повернутих видач
-- (числова міра обчислюється як різниця Julian day для двох дат).
SELECT b.title AS book_title,
       COUNT(l.id) AS loans_count,
       AVG(julianday(l.return_date) - julianday(l.loan_date)) AS avg_loan_days
FROM books AS b
LEFT JOIN loans AS l ON l.book_id = b.id
GROUP BY b.id
ORDER BY b.id;
-- Результат (book_title | loans_count | avg_loan_days):
-- Тигролови | 1 | 31.0
-- Кобзар | 1 | 10.0
-- Лісова пісня | 2 | NULL
-- Місто | 1 | 14.0
-- Захар Беркут | 1 | NULL
-- Чорна рада | 1 | 8.0
-- Кайдашева сім'я | 0 | NULL

-- Завдання 4. Групування за двома колонками: читач і стан повернення.
SELECT reader_id,
       CASE WHEN return_date IS NULL THEN 'не повернено' ELSE 'повернено' END AS loan_status,
       COUNT(*) AS records_count
FROM loans
GROUP BY reader_id, loan_status
ORDER BY reader_id, loan_status;
-- Результат (reader_id | loan_status | records_count):
-- NULL | не повернено | 1
-- 1 | повернено | 1
-- 2 | повернено | 2
-- 3 | не повернено | 1
-- 4 | повернено | 1
-- 5 | не повернено | 1
-- Унікальних reader_id (COUNT DISTINCT, NULL не враховується): 5
-- Унікальних статусів: 2
-- Груп: 6; це кількість наявних комбінацій, не обов'язково
-- добуток 5 × 2.

-- Завдання 5. Навмисна пастка: loan_date не входить у GROUP BY
-- і не є аргументом агрегатної функції. У SQLite запит дозволений.
SELECT reader_id, loan_date, COUNT(*) AS loans_count
FROM loans
GROUP BY reader_id
ORDER BY reader_id;
-- Перший запуск (reader_id | loan_date | loans_count):
-- NULL | 2026-10-17 | 1
-- 1 | 2026-10-01 | 1
-- 2 | 2026-10-02 | 2
-- 3 | 2026-10-04 | 1
-- 4 | 2026-10-06 | 1
-- 5 | 2026-10-08 | 1

-- Повторний запуск того самого запиту:
SELECT reader_id, loan_date, COUNT(*) AS loans_count
FROM loans
GROUP BY reader_id
ORDER BY reader_id;
-- Другий запуск (reader_id | loan_date | loans_count):
-- NULL | 2026-10-17 | 1
-- 1 | 2026-10-01 | 1
-- 2 | 2026-10-02 | 2
-- 3 | 2026-10-04 | 1
-- 4 | 2026-10-06 | 1
-- 5 | 2026-10-08 | 1
-- В цій базі значення loan_date збіглися між запусками: True.
-- Збіг не є гарантією SQL: вибране значення з групи не визначене.

-- Перевірка цілісності.
PRAGMA foreign_key_check;
-- Результат: []
