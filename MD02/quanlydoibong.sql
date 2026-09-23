CREATE DATABASE quanlydoibong;
USE quanlydoibong;

CREATE TABLE football_teams (
team_id INT PRIMARY KEY auto_increment,
team_name VARCHAR(100) NOT NULL,
team_code VARCHAR(20) NOT NULL unique,
home_area VARCHAR(100) NOT NULL,
founded_date DATE NOT NULL
);

CREATE TABLE players (
player_id INT PRIMARY KEY auto_increment,
full_name VARCHAR(100) NOT NULL,
preferred_position VARCHAR(30) CHECK (preferred_position IN ('Thủ môn', 'Hậu vệ', 'Tiền vệ', 'Tiền đạo')),
phone_number VARCHAR(15) NOT NULL UNIQUE,
skill_rating DECIMAL(3,1) DEFAULT 5.0, CHECK (skill_rating between 0.0 and 10.0)
);

CREATE TABLE matches (
match_id INT PRIMARY KEY auto_increment,
team_id INT,
opponent_name VARCHAR(100) NOT NULL,
venue VARCHAR(150) NOT NULL,
match_time DATETIME NOT NULL,
pitch_fee DECIMAL(10,2) CHECK (pitch_fee >= 0),
status VARCHAR(30) CHECK ( status IN ('Scheduled','Completed','Cancelled')),

constraint fk_matches_footballteams
foreign key (team_id) references football_teams(team_id)
);

CREATE TABLE match_registrations (
registration_id INT PRIMARY KEY auto_increment,
match_id INT,
player_id INT,
attendance_status VARCHAR(30) CHECK (attendance_status IN ('Registered', 'Played','Absent')),
goals INT DEFAULT 0 CHECK (goals >= 0),
registered_at DATETIME DEFAULT current_timestamp,

constraint fk_matchregistrations_matches
foreign key (match_id) references matches(match_id),
constraint fk_matchregistrations_players
foreign key (player_id) references players(player_id)

);

CREATE TABLE team_logs (
log_id INT PRIMARY KEY auto_increment,
registration_id INT,
player_id INT,
log_time DATETIME NOT NULL,
note TEXT NOT NULL,

constraint fk_teamlogs_matchregistrations
foreign key (registration_id) references match_registrations(registration_id),
constraint fk_teamlogs_players
foreign key (player_id) references players(player_id)
);

INSERT INTO football_teams (team_name, team_code, home_area, founded_date)
VALUES 
('Sài Gòn Strikers', 'SGS', 'Quận 1', '2018-03-10'),
('Thunder FC', 'TFC', 'TP Thủ Đức', '2021-06-15'),
('Brothers United', 'BRU', 'Bình Thạnh', '2016-09-20'),
('Weekend Warriors', 'WKW', 'Quận 7', '2022-01-08'),
('Office Eleven', 'O11', 'Gò Vấp', '2019-11-30');

INSERT INTO players (full_name, preferred_position, phone_number, skill_rating)
VALUES 
('Nguyễn Minh Khang', 'Tiền đạo', '901112233', 8.2),
('Trần Hoàng Nam', 'Tiền vệ', '902223344', 7.5),
('Lê Quốc Huy', 'Hậu vệ', '903334455', 7.8),
('Phạm Gia Bảo', 'Thủ môn', '904445566', 8.2),
('Võ Thành Công', 'Tiền vệ', '905556677', 7.0);

INSERT INTO matches (match_id, team_id, opponent_name, venue, match_time, pitch_fee, status) 
VALUES 
(7001, 1, 'Black Cats', 'Sân Tao Đàn', '2026-05-20 18:00:00', 1200000, 'Scheduled'),
(7002, 3, 'Blue Sharks', 'Sân Gia Định', '2026-05-21 19:30:00', 1500000, 'Completed'),
(7003, 2, 'Bình Minh FC', 'Sân Linh Trung', '2026-05-22 18:30:00', 1000000, 'Completed'),
(7004, 5, 'Red Bulls', 'Sân Kỳ Hòa', '2026-05-23 20:00:00', 1300000, 'Cancelled'),
(7005, 4, 'Young Boys', 'Sân Hoàng Văn Thụ', '2026-05-24 17:30:00', 1100000, 'Scheduled');

INSERT INTO match_registrations (registration_id, match_id, player_id, attendance_status, goals, registered_at)
VALUES 
(8001, 7002, 1, 'Played', 2, '2026-05-19 09:00:00'),
(8002, 7002, 3, 'Played', 0, '2026-05-19 09:15:00'),
(8003, 7001, 2, 'Registered', 0, '2026-05-18 20:00:00'),
(8004, 7003, 5, 'Played', 1, '2026-05-20 08:30:00'),
(8005, 7004, 4, 'Absent', 0, '2026-05-21 10:00:00');

INSERT INTO team_logs (log_id, registration_id, player_id, log_time, note)
VALUES 
(1, 8003, 2, '2026-05-18 20:05:00', 'Xác nhận tham gia trận'),
(2, 8001, 1, '2026-05-19 09:05:00', 'Đăng ký đá chính'),
(3, 8002, 3, '2026-05-19 09:20:00', 'Xác nhận tham gia'),
(4, 8004, 5, '2026-05-20 08:35:00', 'Đã có mặt tại sân'),
(5, 8005, 4, '2026-05-23 20:05:00', 'Vắng mặt không báo trước');

UPDATE matches SET pitch_fee = pitch_fee + 100000 WHERE status = 'Completed';
DELETE FROM team_logs 
WHERE log_time < '2026-05-20';

SELECT full_name, preferred_position, skill_rating FROM players
WHERE skill_rating > 7.8 OR preferred_position = 'Tiền vệ';

SELECT opponent_name, venue, match_time FROM matches
WHERE match_time between '2026-05-20' and '2026-05-22' 
AND opponent_name LIKE 'B%';

SELECT registration_id, goals, registered_at FROM match_registrations
ORDER BY goals DESC, registration_id ASC
LIMIT 2 OFFSET 2;

SELECT football_teams.team_name,
matches.opponent_name,
players.full_name,
players.preferred_position,
match_registrations.goals,
matches.match_time
FROM match_registrations 
JOIN players ON match_registrations.player_id = players.player_id
JOIN matches ON match_registrations.match_id = matches.match_id
JOIN football_teams ON matches.team_id = football_teams.team_id;

SELECT players.full_name,
SUM(match_registrations.goals) AS tong_so_ban_thang
FROM match_registrations
JOIN players ON match_registrations.player_id = players.player_id
WHERE match_registrations.attendance_status = 'Played'
GROUP BY players.player_id, players.full_name
HAVING SUM(match_registrations.goals) > 1;

SELECT player_id, full_name, skill_rating 
FROM players
WHERE skill_rating = (SELECT MAX(skill_rating) FROM players);

CREATE INDEX idx_match_registrations
ON match_registrations(attendance_status,goals);

CREATE VIEW v_player AS
SELECT players.player_id,players.full_name,
COUNT(match_registrations.match_id) AS tong_so_tran_dang_ky,
COALESCE(SUM(match_registrations.goals),0) AS tong_so_ban_thang
FROM players
LEFT JOIN match_registrations
ON players.player_id = match_registrations.player_id 
AND match_registrations.attendance_status <> 'Absent'
GROUP BY players.player_id, players.full_name;