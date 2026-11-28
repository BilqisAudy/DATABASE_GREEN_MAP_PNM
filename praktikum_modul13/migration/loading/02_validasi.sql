// ============================================================
// Validasi hasil migrasi: bandingkan dengan data sumber di MySQL
// ============================================================

// 1. Jumlah node. Harapan dari MySQL: Tanaman 4, Pengguna 4, Perawatan 4, Laporan 3, Kategori 3 (jenis_tanaman berbeda)
MATCH (n)
WHERE any(l IN labels(n) WHERE l IN ['Tanaman', 'Pengguna', 'Perawatan', 'Laporan', 'Kategori'])
RETURN labels(n)[0] AS node, count(*) AS jumlah
ORDER BY node;

// 2. Jumlah relasi. Harapan: MELAKUKAN 4, PADA 4, MELAPORKAN 3, TENTANG 3, TERMASUK_KATEGORI 4
MATCH ()-[r]->()
WHERE type(r) IN ['MELAKUKAN', 'PADA', 'MELAPORKAN', 'TENTANG', 'TERMASUK_KATEGORI']
RETURN type(r) AS relasi, count(*) AS jumlah
ORDER BY relasi;

// 3. Pembanding total_laporan di MySQL (Trembesi 1, Mahoni 0, Bougainvillea 2, Jahe 0)
MATCH (t:Tanaman)
RETURN t.nama AS tanaman, COUNT { (t)<-[:TENTANG]-(:Laporan) } AS total_laporan_graf
ORDER BY tanaman;

// 4. Pemeriksaan data menggantung. Setiap query harus menghasilkan 0.
MATCH (r:Perawatan) WHERE NOT EXISTS { (r)-[:PADA]->(:Tanaman) }
RETURN count(r) AS perawatan_tanpa_tanaman;

MATCH (l:Laporan) WHERE NOT EXISTS { (l)-[:TENTANG]->(:Tanaman) }
RETURN count(l) AS laporan_tanpa_tanaman;

MATCH (t:Tanaman) WHERE NOT EXISTS { (t)-[:TERMASUK_KATEGORI]->(:Kategori) }
RETURN count(t) AS tanaman_tanpa_kategori;

// 5. Kelengkapan atribut khusus (dari tanaman_objek): Trembesi, Bougainvillea, Jahe punya atribut; Mahoni tidak
MATCH (t:Tanaman)
RETURN t.nama AS tanaman, t.tinggi_m AS tinggi_m, t.warna_bunga AS warna_bunga, t.khasiat AS khasiat, t.bagian_dipakai AS bagian_dipakai
ORDER BY tanaman;
