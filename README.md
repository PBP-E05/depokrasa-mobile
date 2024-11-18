# Depokrasa Mobile
---
## URL APK
- [DepokRasa Mobile]()
---
## Daftar Anggota
- Muhammad Wendy Fyfo Anggara (2306223906)
- Laurentius Farel Arlana Mahardika (2306244892)
- Farrel Athalla Muljawan (2306223925)
- Joe Mathew Rusli (2306152310)
- Philip Halomoan Sampenta Manurung (2306240130)
---
## Deskripsi Aplikasi
Sebagai mahasiswa di Universitas Indonesia, kami semua memiliki satu masalah yang sama, yaitu menu makanan yang itu-itu saja. Di kota Depok yang besar ini kami kebingunngan dalam memilih makanan yang akan kami makan dan tempat untuk mendapatkannya. Sehingga, kami muncul dengan ide untuk menciptakan DepokRasa. 

DepokRasa adalah aplikasi yang bertujuan untuk memberikan informasi tentang berbagai jenis makanan atau minuman yang ditemukan di Kota Depok. Tujuan aplikasi ini adalah untuk membantu penduduk lokal dan turis yang datang ke Depok menemukan toko makanan atau minuman tertentu yang mereka cari. Dengan menggunakan aplikasi ini, pengguna dapat dengan mudah menemukan toko atau restoran di Depok yang menjual makanan atau minuman yang beragam, sehingga pengguna dapat menyicipi keberagaman rasa yang ada di Depok.

### Manfaat
- Temukan kuliner baru
   - DepokRasa memudahkan pengguna untuk menemukan berbagai macam kuliner baru dan unik di Depok.
- Cari makanan berdasarkan kategori
   - Pengguna dapat mencari kuliner berdasarkan kategori yang disediakan. Memudahkan pengguna mencari makanan yang mereka mau.
- Dapatkan rekomendasi kuliner
   - Pengguna dapat menemukan kuliner favorit di Depok dengan menggunakan *featured news* dan artikel dalam DepokRasa.


---
## Daftar Modul 
1. [Authentication (auth) and User Management](#1-authentication-auth-and-user-management)(Joe Mathew Rusli)
2. [Menu Management](#2-menu-management)(Philip Halomoan Sampenta Manurung)
3. [Information on Promotions and Discounts](#3-information-on-promotions-and-discounts)(Laurentius Farel Arlana Mahardika)
4. [Articles](#4-articles)(Muhammad Wendy Fyfo Anggara)
5. [Feedback and Support](#5-feedback-and-support)(Farrel Athalla Muljawan)

### 1. Authentication (auth) and User Management
**Features:**
- Food wishlist
- User registration (sign up)
- Login and logout functionality

**Views:**
- Dashboard page
- Order details page

### 2. Menu Management
**Features:**
- Food item listing (CRUD operations)
- Food ratings and reviews

**Models:**
- Food
- Shop (one-to-many relationship with Food)

### 3. Information on Promotions and Discounts
**Features:**
- Promo codes
- Category-specific discounts

**Models:**
- Promotion
- Discount

### 4. Articles
**Features:**
- Articles about Depok's culinary scene
- Food tips and recommendations

**Model:**
- Article
- Category
- Comment

### 5. Feedback and Support
**Features:**
- Feedback form
- FAQ section

**Model:**
- Feedback

---
## Peran
1. **Pengguna Umum**: Pengguna yang dapat menelusuri produk makanan, menandai favorit, dan memberikan ulasan serta peringkat.
   - **Fitur Utama**: Registrasi, login/logout, melihat menu, dan membuat wishlist.
   - **Views**: Halaman dashboard pengguna, halaman profil, halaman wishlist.

2. **Admin**: Administrator yang dapat mengelola pengguna, memoderasi daftar produk, dan memastikan kelancaran operasi platform.
   - **Fitur Utama**: Mengelola pengguna, melihat dan mengelola menu makanan, mengelola dan memoderasi artikel.
   - **Views**: Admin Panel (menggunakan Django Admin)
---
## Alur Integrasi Web Service
Langkah yang kami lakukan untuk mengintegrasikan DepokRasa mobile dengan web service DepokRasa adalah:
1.  Menambahkan dependensi http ke proyek; dependensi ini digunakan untuk bertukar HTTP request antara aplikasi dengan web service.

2.  Membuat model sesuai dengan respons dari data yang berasal dari web service DepokRasa.

3.  Membuat http request ke web service menggunakan dependensi http.

4.  Mengkonversikan objek yang didapatkan dari web service ke model yang telah dibuat sebelumnya.

5.  Menampilkan data yang telah dikonversi ke aplikasi dengan  `FutureBuilder`

6. Menggunakan dependensi `pbp_django_auth` untuk mengintegrasi *authentication* dari django web service

7. Memanfaatkan method class CookieRequest dari `pbp_django_auth`, seperti `.login()`, dan `.register()` untuk mengurus request login dan register akun baru melalui aplikasi *mobile*.

---

