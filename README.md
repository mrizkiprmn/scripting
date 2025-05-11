📦 **scripting** kumpulan skrip otomatisasi dan konfigurasi infrastruktur yang digunakan untuk kebutuhan operasional dan pengelolaan sistem di berbagai lingkungan (development, staging, production).

## 📁 Struktur Direktori

| Folder        | Deskripsi                                                                 |
|---------------|---------------------------------------------------------------------------|
| `ansible`     | Kumpulan playbook dan skrip Ansible untuk provisioning dan deployment.    |
| `database`    | Helper script untuk manajemen database (contoh: MongoDB, PostgreSQL).         |
| `docker-swarm`| Konfigurasi dan skrip untuk deploy stack menggunakan Docker Swarm.        |
| `karpenter`   | Manifest dan skrip terkait auto-scaling menggunakan Karpenter di Kubernetes.|
| `kube`        | Helper script untuk monitoring pods, nodes, dan resources di K8s.  |
| `metabase`    | Konfigurasi deploy Metabase dan automasi integrasi terkait.               |
| `openvpn`     | Skrip instalasi dan konfigurasi OpenVPN.                                  |
| `python`      | Skrip Python utilitas, automasi, atau pengolahan data/log.                |

## 🚀 Tujuan

Repositori ini dibuat untuk:
- Menstandarisasi automasi operasional.
- Mempercepat provisioning dan deployment.
- Menyediakan alat bantu (helper scripts) untuk monitoring dan debugging.
- Meningkatkan efisiensi tim DevOps/SRE/Infra.

## 📦 Prasyarat

Beberapa skrip memerlukan tool berikut:
- `kubectl`
- `docker` / `docker-compose`
- `ansible`
- `openvpn`
- `python3`
- `helm` (opsional untuk beberapa deployment)

## ⚠️ Catatan

- Pastikan environment Anda sesuai sebelum menjalankan skrip.
- Beberapa konfigurasi sensitif (seperti IP, token, credential) **tidak** disertakan dan perlu disesuaikan manual.

## 🛠 Kontribusi

Untuk menambahkan skrip baru, pastikan untuk:
1. Memberi nama file secara deskriptif.
2. Menambahkan deskripsi singkat di awal file skrip.
3. Menguji fungsionalitas sebelum mengajukan pull request.

---