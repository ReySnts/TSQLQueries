--3a
BEGIN TRAN
	INSERT INTO
		PENERBIT
	VALUES
		(
			'ER',
			'Erlangga',
			'Jakarta'
		),
		(
			'YG',
			'Yudhistira Galia',
			'Jakarta'
		),
		(
			'SJ',
			'Sentosa Jaya',
			'Bali'
		),
		(
			'AG',
			'Anggora',
			'Surakarta'
		)
	INSERT INTO
		PENGARANG
	VALUES
		(
			'M-002',
			'Akbar Tanjung'
		),
		(
			'M-003',
			'Titiek Suryaningsih'
		),
		(
			'M-004',
			'Reynaldy Sentosa'
		),
		(
			'P-001',
			'Ruslan'
		)
ROLLBACK
	COMMIT
--3b
BEGIN TRAN
	UPDATE
		PENERBIT
	SET
		Lokasi = 'Yogyakarta'
	WHERE
		Lokasi LIKE 'Yogya'
ROLLBACK
	COMMIT
--3c
SELECT
	Judul,
	Nama_Pengarang,
	Nama_Penerbit
FROM
	BUKU1,
	PENGARANG,
	PENERBIT
WHERE
	BUKU1.Kode_Buku = PENGARANG.Kode_Buku AND
	BUKU1.Kode_Penerbit = PENERBIT.Kode_Penerbit
--3d
SELECT
	DISTINCT
		Judul
FROM
	BUKU1 b1 JOIN
	BUKU2 b2 ON
	b1.Kode_Buku = b2.Kode_Buku
WHERE
	YEAR(Tgl_Masuk) > 1997
--3e
SELECT
	Judul,
	Nama_Pengarang,
	Nama_Penerbit
FROM
	BUKU1 b1 JOIN
	BUKU2 b2 ON
	b1.Kode_Buku = b2.Kode_Buku JOIN
	PENGARANG ON
	b1.Kode_Buku = PENGARANG.Kode_Buku JOIN
	PENERBIT ON
	b1.Kode_Penerbit = PENERBIT.Kode_Penerbit
WHERE
	Kode_Rinci LIKE 'C2'
--3f
SELECT
	Judul
FROM
	BUKU1 b JOIN
	PENERBIT p ON
	b.Kode_Penerbit = p.Kode_Penerbit
WHERE
	Edisi = 1 AND
	Nama_Penerbit LIKE 'Gramedia'