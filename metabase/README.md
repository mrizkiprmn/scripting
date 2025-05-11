# 🚀 Panduan Instalasi Metabase v0.53.10 dengan systemd

Dokumen ini berisi panduan lengkap untuk menginstal Metabase versi 0.53.10 secara manual di server Linux menggunakan systemd, dengan penyimpanan konfigurasi menggunakan database MySQL.

---

## 🧩 Persyaratan
- OS: Ubuntu 20.04 / 22.04
- Java: Versi 21
- MySQL: Telah terinstal dan user database telah dikonfigurasi
- Port yang tidak umum untuk akses Metabase (misal: 4242)
- Spesifikasi minimum disarankan: 4 CPU, 8GB RAM

---

## 🛠 Langkah Instalasi

### 1. Install Java
Install Java 21:
```bash
sudo apt update
sudo apt install openjdk-21-jre-headless -y
```

### 2. Buat user khusus Metabase
Buat user untuk menjalankan Metabase dan atur folder instalasi:
```bash
sudo useradd -r -s /bin/false metabase
sudo mkdir -p /opt/metabase
sudo chown metabase:metabase /opt/metabase
```

### 3. Download Metabase Jar
Untuk mengunduh versi Metabase terbaru, kamu bisa mengunjungi halaman [Metabase Downloads](https://www.metabase.com/download/). Jika ingin mengunduh versi tertentu, gunakan URL berikut:
```bash
cd /opt/metabase
sudo wget https://downloads.metabase.com/v0.53.10.x/metabase.jar
sudo chown metabase:metabase metabase.jar
```

Jika kamu ingin mencari versi lainnya, kunjungi [halaman versi Metabase](https://github.com/metabase/metabase/releases).

### 4. Konfigurasi systemd untuk menjalankan Metabase
Buat file layanan systemd untuk Metabase dengan perintah berikut:
```bash
sudo nano /etc/systemd/system/metabase.service
```

Tambahkan konfigurasi berikut ke dalam file `metabase.service`:

### 5. Reload systemd dan mulai layanan Metabase
```bash
sudo systemctl daemon-reload
sudo systemctl start metabase
sudo systemctl enable metabase
```

### 6. Akses Metabase
Metabase sekarang dapat diakses melalui port yang telah kamu tentukan (misalnya `4242`), buka browser dan akses:
```
http://<alamat-ip-server>:4242
```

Ikuti petunjuk untuk menyelesaikan setup awal Metabase.