# Overleaf Extended CE — Deployment Config

Cấu hình triển khai Overleaf Extended Community Edition (CE+) với các tính năng mở rộng.

## Tính năng đã bật

- ✅ Template Gallery (12 danh mục)
- ✅ Sandboxed Compiles (TeX Live 2025)
- ✅ Track Changes & Comments
- ✅ Symbol Palette
- ✅ From External URL
- ✅ Admin Tools
- ✅ Autocomplete references

## Thông tin

| Mục | Giá trị |
|---|---|
| Image | `overleafcep/sharelatex:6.1.1-ext-v3.5` |
| Port | `8800` |
| Domain | `overleaf.hoclieu.id.vn` |
| Proxy | Cloudflare (SSL termination) |

## Cài đặt nhanh

```bash
# 1. Clone repo này
git clone https://github.com/xuanhoatrieu/overleaf-extend.git
cd overleaf-extend

# 2. Chạy install
chmod +x install.sh update.sh
./install.sh

# 3. Sửa biến môi trường
nano ~/overleaf-toolkit/config/variables.env

# 4. Khởi động
cd ~/overleaf-toolkit && bin/up -d
```

## Cập nhật phiên bản mới

Khi Extended CE ra phiên bản mới (kiểm tra tại [Docker Hub](https://hub.docker.com/r/overleafcep/sharelatex/tags)):

```bash
# Cách 1: Dùng script
./update.sh 6.2.0

# Cách 2: Manual
# 1. Sửa config/version → phiên bản mới (ví dụ: 6.2.0)
# 2. Sửa config/docker-compose.override.yml → tag image mới
# 3. cd ~/overleaf-toolkit && bin/stop && bin/up -d
```

### Chi tiết quá trình update

1. **Kiểm tra phiên bản mới**: [overleafcep/sharelatex tags](https://hub.docker.com/r/overleafcep/sharelatex/tags)
2. **Cập nhật file `config/version`**: Đổi thành số phiên bản base (ví dụ `6.2.0`)
3. **Cập nhật `config/docker-compose.override.yml`**: Đổi tag image (ví dụ `overleafcep/sharelatex:6.2.0-ext-v3.6`)
4. **Commit & push** → CI/CD tự động deploy (nếu đã cấu hình SSH)

## Cấu trúc file

```
overleaf-extend/
├── config/
│   ├── overleaf.rc                  # Cấu hình chính (port, sandboxed, etc.)
│   ├── variables.env.template       # Template biến môi trường (KHÔNG chứa password)
│   ├── version                      # Phiên bản Overleaf base
│   ├── docker-compose.override.yml  # Override image & volumes
│   ├── 90-git-bridge.sh             # Init script cho Git Bridge
│   └── git-bridge-settings.js       # Git Bridge settings patch
├── install.sh                       # Script cài đặt tự động
├── update.sh                        # Script cập nhật phiên bản
├── .github/workflows/deploy.yml     # CI/CD tự động deploy
└── README.md
```

## CI/CD

GitHub Actions workflow tự động deploy khi push lên `main`:
- Kết nối SSH đến server
- Copy config files mới
- Restart Overleaf services

### Thiết lập CI/CD

Thêm GitHub Secrets:
- `SSH_HOST` — IP server (ví dụ: `10.64.11.109`)
- `SSH_USER` — Username SSH (ví dụ: `moodle`)
- `SSH_KEY` — Private SSH key

## Tài liệu tham khảo

- [Overleaf Extended CE Wiki](https://github.com/yu-i-i/overleaf-cep/wiki)
- [Overleaf Toolkit](https://github.com/overleaf/toolkit)
- [Template Gallery](https://github.com/yu-i-i/overleaf-cep/wiki/Extended-CE:-Template-Gallery)
