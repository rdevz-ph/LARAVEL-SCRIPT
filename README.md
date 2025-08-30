# Laravel One-Click Setup

This project includes a **PowerShell setup script** and simple launchers to make running your Laravel dev environment easy with one click.

## 📂 Files

- **setup-laravel.ps1**  
  PowerShell script that runs all the setup steps:
  - `composer install`
  - `npm install`
  - Copy `.env.example` → `.env` (if missing)
  - Generate `APP_KEY` (if missing)
  - `php artisan storage:link`
  - `php artisan migrate --force`
  - `php artisan db:seed --force`
  - `php artisan optimize`
  - Starts:
    - `npm run build` in a new terminal
    - `npm run dev` in a new terminal
    - `php artisan serve` in a new terminal
  - Opens browser to `http://127.0.0.1:8000`

- **run-system.cmd**  
  A simple batch wrapper that launches the PowerShell script so you can double-click it instead of typing commands.

- **index.hta**  
  A lightweight HTML Application with a **Run System** button that triggers `run-system.cmd`.  
  This gives a user-friendly “GUI button” feel.

---

## 🚀 How to Use

### Method 1 – PowerShell (direct)
Run from project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-laravel.ps1
```

### Method 2 – Batch Wrapper
Double-click:

```
run-system.cmd
```

This will call the PowerShell script with the proper flags.

### Method 3 – HTML Launcher
1. Double-click `index.hta`.  
2. Click the **Run System** button.  
   - This will run `run-system.cmd`, which in turn executes the PowerShell script.

---

## 📝 Notes
- Make sure `php`, `composer`, and `npm` are available in your system PATH.
- If `storage:link` fails on Windows, run the script as **Administrator**.
- The `.hta` file works only on Windows (uses `WScript.Shell`).
- The scripts are idempotent:
  - They won’t re-run `composer install` or `npm install` if already done.
  - They won’t overwrite `.env` or `APP_KEY` if they exist.

---

## ⚡ Tips
- Create a **desktop shortcut** to `run-system.cmd` or `index.hta` and assign a custom icon for true one-click convenience.
- You can pin the shortcut to your **Taskbar** or **Start Menu** for easy access.

---

## 📜 License
MIT License © 2025 **Romel Brosas**
