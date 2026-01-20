# Elian Portfolio (Flutter Web)

A modern, animated, multi-page Flutter web portfolio (Home / Experience / Projects / Contact) designed for GitHub Pages.

## 1) Run locally

```bash
flutter pub get
flutter run -d chrome
```

> If you created this folder without `flutter create`, run this once:

```bash
flutter create . --platforms=web
```

## 2) Build for GitHub Pages

Replace `<repo>` with your repo name:

```bash
flutter build web --release --base-href "/<repo>/"
```

The output is in `build/web`.

## 3) Deploy

### Option A — GitHub Actions (recommended)
This repo includes a ready workflow at `.github/workflows/deploy.yml`.

### Option B — Manual
Push `build/web` to a `gh-pages` branch.

## Notes for routing on GitHub Pages
This project uses hash routing (e.g. `/#/projects`) so deep links work reliably on GitHub Pages.
