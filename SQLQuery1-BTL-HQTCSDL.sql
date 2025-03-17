use QuanLySinhVien
go
--- Dem sinh vien trong lop -> inner join
select Class.ClassId, Class.ClassCode, COUNT(Student.StudentId) TotalStudent
from Class, Student
where Class.ClassId = Student.ClassId
group by Class.ClassId, Class.ClassCode

--> Tuong tu code sau
select Class.ClassId, Class.ClassCode, COUNT(Student.StudentId) TotalStudent
from Class inner join Student on Class.ClassId = Student.ClassId
group by Class.ClassId, Class.ClassCode

-- Su dung left join => hien thi tat ca ban ghi trong Class
select Class.ClassId, Class.ClassCode, COUNT(Student.StudentId) TotalStudent
from Class left join Student on Class.ClassId = Student.ClassId
group by Class.ClassId, Class.ClassCode

--- Hien thi tong diem cua sinh vien
select Student.StudentId 'Ma Sinh Vien', Student.StudentName 'Ten Sinh Vien', SUM(Result.Mark) TotalMark
from Student left join Result on Student.StudentId = Result.StudentId
group by Student.StudentId, Student.StudentName
having SUM(Result.Mark) > 10
order by TotalMark desc

CREATE TABLE Teacher (
    TeacherID INT IDENTITY(1,1) PRIMARY KEY, -- Mã giảng viên (tự động tăng)
    FullName NVARCHAR(100) NOT NULL, -- Họ và tên
    DOB DATE, -- Ngày sinh
    Gender BIT, -- Giới tính (1: Nam, 0: Nữ)
    Phone VARCHAR(15), -- Số điện thoại
    Email VARCHAR(100) UNIQUE, -- Email (không trùng lặp)
    Address NVARCHAR(255), -- Địa chỉ
    Department NVARCHAR(100) -- Khoa/Bộ môn
);

ALTER TABLE Subject ADD TeacherId INT;
ALTER TABLE Subject ADD CONSTRAINT FK_Subject_Teacher FOREIGN KEY (TeacherId) REFERENCES Teacher(TeacherId);


INSERT INTO Teacher (FullName, DOB, Gender, Phone, Email, Address, Department) 
VALUES 
('Nguyen Van A', '1980-05-10', 1, '0901234567', 'nguyenvana@dntu.edu.vn', 'Bien Hoa, Dong Nai', 'CNTT'),
('Tran Thi B', '1985-08-15', 0, '0912345678', 'tranthib@dntu.edu.vn', 'Ho Chi Minh City', 'Toan'),
('Le Hoang C', '1979-12-20', 1, '0987654321', 'lehoangc@dntu.edu.vn', 'Ha Noi', 'Kinh Te');
-- Cập nhật TeacherId cho các môn học
UPDATE Subject SET TeacherId = 1 WHERE SubjectId = 1; -- C Programming do GV có ID 1 dạy
UPDATE Subject SET TeacherId = 2 WHERE SubjectId = 2; -- Web Design do GV có ID 2 dạy
UPDATE Subject SET TeacherId = 3 WHERE SubjectId = 3; -- Database Management do GV có ID 3 dạy


ALTER TABLE Class
ADD CONSTRAINT PK_Class PRIMARY KEY (ClassId);

ALTER TABLE Student
ADD CONSTRAINT PK_Student PRIMARY KEY (StudentId);

ALTER TABLE Subject
ADD CONSTRAINT PK_Subject PRIMARY KEY (SubjectId);

ALTER TABLE Teacher
ADD CONSTRAINT PK_Teacher PRIMARY KEY (TeacherId);

ALTER TABLE Result
ADD CONSTRAINT PK_Result PRIMARY KEY (SubjectId, StudentId);

ALTER TABLE Student
ADD CONSTRAINT FK_Student_Class FOREIGN KEY (ClassId) REFERENCES Class (ClassId);

ALTER TABLE Subject
ADD CONSTRAINT FK_Subject_Teacher FOREIGN KEY (TeacherId) REFERENCES Teacher (TeacherId);

ALTER TABLE Result
ADD CONSTRAINT FK_Result_Student FOREIGN KEY (StudentId) REFERENCES Student (StudentId);

ALTER TABLE Result
ADD CONSTRAINT FK_Result_Subject FOREIGN KEY (SubjectId) REFERENCES Subject (SubjectId);

-- Số buổi học phải lớn hơn 0
ALTER TABLE Subject
ADD CONSTRAINT CH_Subject_SessionCount CHECK (SessionCount > 0);

-- Điểm số phải từ 0 đến 10
ALTER TABLE Result
ADD CONSTRAINT CH_Result_Mark CHECK (Mark >= 0 AND Mark <= 10);

-- Giới tính chỉ nhận giá trị 0 (Nữ) hoặc 1 (Nam)
ALTER TABLE Teacher
ADD CONSTRAINT CH_Teacher_Gender CHECK (Gender IN (0,1));

-- Số điện thoại phải có độ dài từ 10 đến 15 ký tự
ALTER TABLE Teacher
ADD CONSTRAINT CH_Teacher_PhoneLength CHECK (LEN(Phone) BETWEEN 10 AND 15);

ALTER TABLE Teacher
ADD CONSTRAINT UQ_Teacher_Email UNIQUE (Email);

-- Mặc định giới tính là 1 (Nam)
ALTER TABLE Teacher
ADD CONSTRAINT DF_Teacher_Gender DEFAULT 1 FOR Gender;


INSERT INTO Class (ClassId, ClassCode)
VALUES
(6, 'C1111KV'),
(7, 'C1112KV'),
(8, 'C1113KV'),
(9, 'C1114KV'),
(10, 'C1115KV'),
(11, 'C1116KV'),
(12, 'C1117KV'),
(13, 'C1118KV'),
(14, 'C1119KV'),
(15, 'C1120KV');

INSERT INTO Student (StudentId, StudentName, BirthDate, ClassId)
VALUES
(11, 'Bui Van Duc', '1993-05-20', 1),
(12, 'Nguyen Thi Hoa', '1992-12-12', 2),
(13, 'Tran Van Hai', '1994-04-22', 3),
(14, 'Vu Minh Tien', '1993-09-14', 1),
(15, 'Nguyen Ngoc Lan', '1995-06-10', 2);


INSERT INTO Subject (SubjectId, SubjectName, SessionCount)
VALUES

(4, 'Data Structures', 20),
(5, 'Machine Learning', 25),
(6, 'Artificial Intelligence', 30),
(7, 'Computer Networks', 24),
(8, 'Cyber Security', 26),
(9, 'Software Engineering', 21),
(10, 'Cloud Computing', 28),
(11, 'Operating Systems', 19),
(12, 'Mobile Development', 22),
(13, 'Game Development', 27),
(14, 'Embedded Systems', 23),
(15, 'Blockchain Technology', 25);

INSERT INTO Result (StudentId, SubjectId, Mark)
VALUES
(2, 11, 9),
(3, 12, 8),
(1, 13, 7),
(4, 4, 9.1),
(5, 5, 7.6),
(6, 6, 8.0),
(7, 7, 6.5),
(8, 8, 9.3),
(9, 9, 5.4),
(10, 10, 8.8),
(11, 11, 7.9),
(12, 12, 6.7),
(13, 13, 9.5),
(14, 14, 8.2),
(15, 15, 7.4);

SELECT * FROM Class
SELECT * FROM Result
SELECT * FROM Student
SELECT * FROM Subject
SELECT * FROM Teacher

--View danh sách sinh viên và lớp

ALTER VIEW v_StudentClass AS
SELECT s.StudentId, s.StudentName, s.BirthDate, c.ClassCode
FROM Student s
JOIN Class c ON s.ClassId = c.ClassId;

SELECT * FROM v_StudentClass;


--điểm trung bình của mỗi sinh viên
CREATE VIEW v_AverageMark AS
SELECT 
    s.StudentId, 
    s.StudentName, 
    AVG(r.Mark) AS AverageMark
FROM Student s
LEFT JOIN Result r ON s.StudentId = r.StudentId
GROUP BY s.StudentId, s.StudentName;

SELECT * FROM v_AverageMark;



--danh sách môn học có số buổi học nhiều hơn 20
CREATE VIEW v_LongSubjects AS
SELECT SubjectId, SubjectName, SessionCount
FROM Subject
WHERE SessionCount > 20;

SELECT * FROM v_LongSubjects;

 --sinh viên có điểm cao nhất mỗi môn
 CREATE VIEW v_TopStudents AS
SELECT r.SubjectId, sub.SubjectName, s.StudentId, s.StudentName, r.Mark
FROM Result r
JOIN Student s ON r.StudentId = s.StudentId
JOIN Subject sub ON r.SubjectId = sub.SubjectId
WHERE r.Mark = (SELECT MAX(Mark) FROM Result WHERE SubjectId = r.SubjectId);

SELECT * FROM v_TopStudents;

--danh sách sinh viên có tổng điểm trên 15
CREATE VIEW v_HighScoreStudents AS
SELECT s.StudentId, s.StudentName, SUM(r.Mark) AS TotalMark
FROM Student s
JOIN Result r ON s.StudentId = r.StudentId
GROUP BY s.StudentId, s.StudentName
HAVING SUM(r.Mark) > 15;

SELECT * FROM v_HighScoreStudents;

--sinh viên không có điểm
CREATE VIEW v_StudentsWithoutMarks AS
SELECT s.StudentId, s.StudentName, c.ClassCode
FROM Student s
JOIN Class c ON s.ClassId = c.ClassId
LEFT JOIN Result r ON s.StudentId = r.StudentId
WHERE r.StudentId IS NULL;

SELECT * FROM v_StudentsWithoutMarks;

-- điểm trung bình của từng môn
CREATE VIEW v_SubjectAverage AS
SELECT r.SubjectId, sub.SubjectName, AVG(r.Mark) AS AvgMark
FROM Result r
JOIN Subject sub ON r.SubjectId = sub.SubjectId
GROUP BY r.SubjectId, sub.SubjectName;

SELECT * FROM v_SubjectAverage;

--danh sách sinh viên học lớp "C1106KV"
CREATE VIEW v_StudentsInC1106KV AS
SELECT s.StudentId, s.StudentName, s.BirthDate
FROM Student s
JOIN Class c ON s.ClassId = c.ClassId
WHERE c.ClassCode = 'C1106KV';

SELECT * FROM v_StudentsInC1106KV;

--các sinh viên có điểm dưới 5
CREATE VIEW v_LowScoreStudents AS
SELECT s.StudentId, s.StudentName, r.SubjectId, sub.SubjectName, r.Mark
FROM Result r
JOIN Student s ON r.StudentId = s.StudentId
JOIN Subject sub ON r.SubjectId = sub.SubjectId
WHERE r.Mark < 5;

SELECT * FROM v_LowScoreStudents;

--danh sách môn học cùng giáo viên phụ trách
CREATE VIEW v_SubjectsWithTeachers AS
SELECT 
    sub.SubjectId, 
    sub.SubjectName, 
    t.FullName AS TeacherName
FROM Subject sub
JOIN Teacher t ON sub.TeacherId = t.TeacherID;

SELECT * FROM v_SubjectsWithTeachers;

--Xây dựng các procedure

--cập nhật sinh viên
CREATE PROCEDURE UpdateStudent
    @StudentId INT,
    @StudentName NVARCHAR(100),
    @BirthDate DATE,
    @ClassId INT
AS
BEGIN
    UPDATE Student
    SET StudentName = @StudentName, BirthDate = @BirthDate, ClassId = @ClassId
    WHERE StudentId = @StudentId;
END;

EXEC UpdateStudent 1, 'Pham Van A', '2000-08-25', 2;


--xóa sinh vien
CREATE PROCEDURE DeleteStudent
    @StudentId INT
AS
BEGIN
    DELETE FROM Student WHERE StudentId = @StudentId;
END;

EXEC DeleteStudent 5;

--Lấy danh sách sinh viên trong lớp
CREATE PROCEDURE GetStudentsByClass
    @ClassId INT
AS
BEGIN
    SELECT * FROM Student WHERE ClassId = @ClassId;
END;

EXEC GetStudentsByClass 1;

-- Lấy điểm trung bình của sinh viên
CREATE PROCEDURE GetStudentAverageMark
    @StudentId INT
AS
BEGIN
    SELECT s.StudentName, AVG(r.Mark) AS AverageMark
    FROM Student s
    JOIN Result r ON s.StudentId = r.StudentId
    WHERE s.StudentId = @StudentId
    GROUP BY s.StudentName;
END;

EXEC GetStudentAverageMark 3;

--Danh sách sinh viên có điểm trung bình trên 8.0
CREATE PROCEDURE GetTopStudents
AS
BEGIN
    SELECT s.StudentId, s.StudentName, AVG(r.Mark) AS AverageMark
    FROM Student s
    JOIN Result r ON s.StudentId = r.StudentId
    GROUP BY s.StudentId, s.StudentName
    HAVING AVG(r.Mark) > 8.0;
END;

EXEC GetTopStudents;

--Thêm môn mới
CREATE PROCEDURE AddSubject
    @SubjectName NVARCHAR(100),
    @SessionCount INT,
    @TeacherId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @NewId INT;

    -- Lấy giá trị lớn nhất của SubjectId và tăng thêm 1
    SELECT @NewId = ISNULL(MAX(SubjectId), 0) + 1 FROM Subject;

    -- Thêm dữ liệu mới vào bảng Subject
    INSERT INTO Subject (SubjectId, SubjectName, SessionCount, TeacherId)
    VALUES (@NewId, @SubjectName, @SessionCount, @TeacherId);
END;

EXEC AddSubject 'Mark', 30, 2;


--Cập nhật số buổi học của môn
CREATE PROCEDURE UpdateSubject
    @SubjectId INT,
    @SessionCount INT
AS
BEGIN
    UPDATE Subject
    SET SessionCount = @SessionCount
    WHERE SubjectId = @SubjectId;
END;
EXEC UpdateSubject 2, 25;

--DS Sinh viên không có điểm
CREATE PROCEDURE GetStudentsWithoutMarks
AS
BEGIN
    SELECT s.StudentId, s.StudentName
    FROM Student s
    LEFT JOIN Result r ON s.StudentId = r.StudentId
    WHERE r.StudentId IS NULL;
END;
EXEC GetStudentsWithoutMarks;


--Lấy danh sách sinh viên theo giáo viên phụ trách
CREATE PROCEDURE GetStudentsByTeacher
    @TeacherId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.StudentId, 
        s.StudentName, 
        s.BirthDate, 
        sub.SubjectName,
        t.FullName AS TeacherName
    FROM Student s
    JOIN Result r ON s.StudentId = r.StudentId  -- Liên kết sinh viên với kết quả học tập
    JOIN Subject sub ON r.SubjectId = sub.SubjectId  -- Liên kết môn học
    JOIN Teacher t ON sub.TeacherId = t.TeacherID  -- Liên kết giáo viên
    WHERE t.TeacherID = @TeacherId;
END;

EXEC GetStudentsByTeacher @TeacherID = 1;


--Thống kê số lượng sinh viên theo từng lớp
CREATE PROCEDURE GetStudentCountByClass
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.ClassId, 
        c.ClassCode, 
        COUNT(s.StudentId) AS StudentCount
    FROM Class c
    LEFT JOIN Student s ON c.ClassId = s.ClassId
    GROUP BY c.ClassId, c.ClassCode;
END;

EXEC GetStudentCountByClass;
