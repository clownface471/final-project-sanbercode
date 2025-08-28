# Final Project Flutter Sanbercode - Archi Note

**Archi Note** adalah aplikasi pencatatan cerdas dan minimalis yang dibangun sebagai Proyek Akhir untuk Bootcamp Flutter Sanbercode. Aplikasi ini dirancang untuk membantu pengguna menulis, mengelola, dan menyempurnakan catatan mereka dengan bantuan kecerdasan buatan (AI).

**Anggota Kelompok:**
* Ahmad Fairuz Pratama
* Muhammad Adzkiya Ikhwan Ash-Shofwa
* Fata Adzaky Muhammad

---

## Deskripsi Aplikasi

Aplikasi ini memungkinkan pengguna untuk membuat akun, login, dan mengelola catatan pribadi mereka. Setiap catatan disimpan dengan aman di Cloud Firestore. Keunggulan utama dari Archi Note adalah integrasi dengan Google Generative AI (Gemini) yang menyediakan tiga fitur canggih langsung di editor catatan:

1.  **Ringkas Teks:** Secara otomatis membuat ringkasan poin-poin penting dari catatan yang panjang.
2.  **Lanjutkan Teks:** Memberikan saran kelanjutan tulisan secara natural berdasarkan konteks yang sudah ada.
3.  **Perbaiki Tata Bahasa:** Mengoreksi kesalahan ejaan dan tata bahasa untuk menyempurnakan tulisan.

Selain itu, pengguna dapat mempersonalisasi profil mereka dengan mengubah nama pengguna dan foto profil.

---

## Spesifikasi Teknis

* **Framework:** Flutter 3.x
* **Bahasa Pemrograman:** Dart
* **State Management:** GetX
* **Backend & Database:** Firebase (Authentication, Cloud Firestore, Cloud Storage)
* **API Eksternal:** Google Generative AI API (Gemini 1.5 Flash) untuk fitur-fitur AI.

---

## Fitur Utama

* **Otentikasi Pengguna:** Sistem registrasi dan login yang aman menggunakan Firebase Authentication (Email/Password & Username).
* **Manajemen Catatan (CRUD):** Membuat, membaca, memperbarui, dan menghapus catatan.
* **Editor Teks Cerdas:** Dilengkapi dengan 3 fitur AI untuk membantu penulisan.
* **Manajemen Profil:** Pengguna dapat mengubah nama pengguna dan foto profil.
* **UI Responsif:** Tampilan yang bersih dan dapat beradaptasi untuk platform mobile dan web.
* **Penyimpanan Real-time:** Semua data disinkronkan secara instan menggunakan Cloud Firestore.

---

## Halaman Aplikasi

Aplikasi ini terdiri dari 5 halaman utama sesuai persyaratan:

1.  **Halaman Splash Screen:** Tampilan awal saat aplikasi dimuat.
2.  **Halaman Otentikasi:** Halaman untuk login dan registrasi pengguna.
3.  **Halaman Home:** Menampilkan daftar semua catatan yang telah dibuat pengguna.
4.  **Halaman Editor Catatan:** Halaman untuk menulis dan mengedit catatan, lengkap dengan fitur AI.
5.  **Halaman Profil:** Menampilkan informasi pengguna dan opsi untuk logout.