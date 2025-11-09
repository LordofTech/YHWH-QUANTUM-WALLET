
# Quantum Wallet — Full Stack (Frontend + Complete Backend)

This bundle merges your **Flutter frontend** with your **Complete Backend (multi-cloud, Prisma/PostGIS/Redis/OTEL/CI/CD)**.

## Structure
- `frontend/` — Flutter app (wired for API via `--dart-define=API_BASE_URL`)
- `backend/`  — Your complete backend from `quantum-wallet-backend-last-multicloud.zip`

## Run Locally

### Backend
```bash
cd backend
npm install
npm run prisma:generate
npm run db:push           # or: npm run prisma:migrate
npm run seed
npm run dev
# -> http://localhost:3000  (Swagger /docs if included)
```

### Frontend
```bash
cd frontend
flutter pub get
# If android/ios/web folders are missing:
flutter create .
# Android emulator -> host:
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
# iOS/same-machine or physical device (adjust IP):
# flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
```

## Notes
- The frontend reads an ID token from SharedPreferences key `firebase_id_token` (if you wire Firebase phone auth). The API client automatically attaches it as `Authorization: Bearer <token>`.
- BLE sync scaffold exists in `lib/services/ble_sync_service.dart`. Extend it to read your firmware GATT characteristics and then POST to `/api/sync/reconcile`.
- All CI/CD, Helm, Terraform, External Secrets, and OIDC workflows remain under `backend/`.
