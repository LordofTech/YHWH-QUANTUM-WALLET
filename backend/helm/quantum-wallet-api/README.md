
# Helm Chart: Quantum Wallet API

## Install
```bash
helm upgrade --install qwa ./helm/quantum-wallet-api   --namespace quantum-wallet --create-namespace   --set image.repository=ghcr.io/owner/quantum-wallet-backend   --set image.tag=latest   --set secrets.DATABASE_URL="postgresql://..."   --set secrets.FIREBASE_PROJECT_ID="..."   --set secrets.REDIS_URL="redis://redis:6379"   --set secrets.ADMIN_UID="your-admin-uid"
```
