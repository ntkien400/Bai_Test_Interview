--a) Hãy viết câu lệnh để tạo 1 csdl sql bao gồm các bảng trên
CREATE TABLE HocVien (
    MaHV INT IDENTITY(1,1) PRIMARY KEY,
    TenHV VARCHAR(255),
    Lop VARCHAR(3)
);

CREATE TABLE MonHoc (
    MaMH INT IDENTITY(1,1) PRIMARY KEY,
    TenMH VARCHAR(255)
);

CREATE TABLE BangDiem (
    MaHP INT IDENTITY(1,1) PRIMARY KEY,
    MaHV INT,
    MaMH INT,
    Diem FLOAT,
    HeSo INT,
    NamHoc INT,
    FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV),
    FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
);
--Them du lieu bang HocVien
INSERT INTO HocVien (TenHV, Lop) VALUES ('Nguyen Van A', '7A1');
INSERT INTO HocVien (TenHV, Lop) VALUES ('Nguyen Van B', '7A1');
INSERT INTO HocVien (TenHV, Lop) VALUES ('Nguyen Van C', '7A1');
INSERT INTO HocVien (TenHV, Lop) VALUES ('Nguyen Van D', '7A1');
INSERT INTO HocVien (TenHV, Lop) VALUES ('Nguyen Van E', '7A1');
--Them du lieu bang MonHoc
INSERT INTO MonHoc(TenMH) VALUES ('Toan');
INSERT INTO MonHoc(TenMH) VALUES ('Van');
--Them du lieu bang BangDiem
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (1, 1, 4, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (1, 1, 7, 2, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (2, 1, 8, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (2, 1, 8, 2, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (3, 1, 6, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (3, 1, 9, 2, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (4, 1, 8, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (4, 1, 3, 2, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (5, 1, 8, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (5, 1, 9, 2, 2023);

INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (1, 3, 8, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (1, 3, 7, 2, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (2, 3, 4, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (2, 3, 3, 2, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (3, 3, 5, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (3, 3, 6, 2, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (4, 3, 7, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (4, 3, 6, 2, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (5, 3, 8, 1, 2023);
INSERT INTO BangDiem(MaHV, MaMH, Diem, HeSo, NamHoc) VALUES (5, 3, 7.5, 2, 2023);

----b)Viết câu lệnh truy vấn lấy ra Danh sách các học viên phải học lại trong năm học
--2023 và điểm trung bình theo môn học (DiemTBMon) đó của học viên, Biết nếu
--điểm trung bình theo môn học dưới 5.0 thì học viên phải học lại. Thông tin lấy ra
--bao gồm (MaHV, TenHV, TenMH, DiemTBMon). Với DiemTBMon = Diem *
--HeSo / Tổng HeSo.

WITH CTETBMon AS(
	SELECT MaHV, MaMH, ROUND(SUM(Diem * Heso) / sum(Heso),2) AS DiemTBMon
	FROM BangDiem
	GROUP BY MaHV, MaMH
)
SELECT hv.MaHV, hv.TenHV, mh.TenMH, DiemTBMon
FROM  HocVien hv, MonHoc mh, CTETBMon c
WHERE c.DiemTBMon < 5 and hv.MaHV = c.MaHV and mh.MaMH = c.MaMH

--c) Tìm ra người có điểm trung bình năm học (DiemTBNH) 2023 cao nhất của lớp 7A1
--bao gồm (MaHV, TenHV, DiemTBNH, NamHoc). Với DiemTBNH = Tổng
--DiemTBMon / Tổng số môn học.

WITH CTETBMon AS(
	SELECT MaHV, MaMH, ROUND(SUM(Diem * Heso) / sum(Heso),2) AS DiemTBMon
	FROM BangDiem
	GROUP BY MaHV, MaMH
),
CTEMaxTBNH AS(
	SELECT TOP 1 MaHV, ROUND(SUM(DiemTBMon)/ COUNT(MaMH),2) AS DiemTBNH
	FROM CTETBMon
	GROUP BY MaHV
	ORDER BY DiemTBNH DESC
)
SELECT DISTINCT hv.MaHV, hv.TenHV, DiemTBNH, NamHoc
FROM  HocVien hv, MonHoc mh, CTEMaxTBNH c, BangDiem bd
WHERE c.MaHV = hv.MaHV
