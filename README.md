# 🌌 neweraseOS

**neweraseOS** — высокопроизводительный дистрибутив Linux на базе Arch Linux с рабочим столом KDE Plasma 6 и игровым стеком технологий SteamOS.

---

## ⚡ Особенности neweraseOS

1. **Ядро Linux-Zen:**
   - Низкие задержки ввода (low latency).
   - Поддержка `fsync`, `futex2` и оптимизированных очередей задач для максимального FPS в играх.

2. **Игровой стек SteamOS прямо на рабочем столе:**
   - **`gamescope`** — микрокомпозитор Valve с поддержкой аппаратного FSR, HDR, фиксации частоты кадров и целочисленного масштабирования.
   - **`gamemode`** — автоматическая оптимизация приоритетов CPU/GPU во время запуска игр.
   - **`mangohud`** — стильный HUD с телеметрией температур, частоты кадров и задержек кадра (frametime).
   - **ZRAM сжатие (zstd)** — оперативная память работает быстрее, исключая зависания при нехватке RAM.

3. **KDE Plasma 6 (Wayland):**
   - Полная поддержка VRR (Variable Refresh Rate / G-Sync / FreeSync).
   - Аппаратное ускорение графики и жестов.
   - Глубокая кастомизация, тёмный киберпанк/минималистичный стиль.

4. **Графический установщик Calamares:**
   - Быстрая и понятная установка системы на диск за несколько кликов с поддержкой Btrfs и Ext4.

---

## 📁 Структура проекта

```text
neweraseOS/
├── .github/workflows/
│   └── build-iso.yml          # Облачная сборка ISO через GitHub Actions
├── archiso/
│   ├── profiledef.sh          # Конфигурация дистрибутива (имя, метка диска, права)
│   ├── packages.x86_64        # Пакетная база (KDE Plasma, Mesa, Vulkan, SteamOS стек)
│   ├── pacman.conf            # Репозитории пакетов (Arch, Multilib, Chaotics/Cachy)
│   └── airootfs/              # Файловая система Live-образа
│       ├── etc/
│       │   ├── os-release     # Идентификация neweraseOS
│       │   ├── sysctl.d/      # Игровые твики ядра (vm.max_map_count, swappiness)
│       │   └── calamares/     # Брендинг и конфиги установщика
│       └── usr/local/bin/     # Фирменные утилиты neweraseOS
├── scripts/
│   ├── build.sh               # Локальная сборка образа через archiso
│   └── test-qemu.sh           # Запуск образа в эмуляторе QEMU
└── README.md
```

---

## 🛠 Как собрать образ ISO

### Способ 1: Автоматически в GitHub Actions (Рекомендуется)
1. Создайте репозиторий на GitHub (например, `neweraseOS`).
2. Запушьте содержимое этой папки в репозиторий:
   ```bash
   git init
   git add .
   git commit -m "feat: initial neweraseOS archiso profile"
   git remote add origin https://github.com/<ваш-логин>/neweraseOS.git
   git branch -M main
   git push -u origin main
   ```
3. Перейдите во вкладку **Actions** в репозитории на GitHub.
4. Сборщик автоматически соберет `.iso` и прикрепит его к релизу или артефактам сборки!

### Способ 2: Локальная сборка (в любом Linux / WSL2)
```bash
sudo ./scripts/build.sh
```
Готовый ISO-образ появится в папке `out/`.
