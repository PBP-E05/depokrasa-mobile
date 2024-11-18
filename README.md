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
1. [Authentication (auth) and User Management (Joe Mathew Rusli)](#1-authentication-auth-and-user-management)
2. [Menu Management (Philip Halomoan Sampenta Manurung)](#3-menu-management)
3. [Information on Promotions and Discounts (Laurentius Farel Arlana Mahardika)](#5-information-on-promotions-and-discounts)
4. [Articles (Muhammad Wendy Fyfo Anggara)](#6-blogarticles)
5. [Feedback and Support (Farrel Athalla Muljawab)](#7-feedback-and-support)

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


---

