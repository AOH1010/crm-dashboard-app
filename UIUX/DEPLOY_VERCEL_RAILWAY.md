# Deploy Vercel + Railway

Muc tieu:
- `Railway` chay backend API Node/Express va dung snapshot hien tai cua `crm.db`.
- `Vercel` chay frontend Vite/React.

## Kien truc sau khi deploy

- Frontend: `Vercel`
- Backend API: `Railway`
- Frontend goi backend qua `VITE_API_BASE_URL`
- Railway build tu `Dockerfile` o root repo
- Docker image giai nen `data/crm.db.gz` thanh `data/crm.db` luc build
- Backend tu tao `dashboard_sales.db` khi khoi dong

Ghi chu:
- Cach nay phu hop de len web nhanh voi code hien tai.
- Repo GitHub phai de `private` vi snapshot DB nam trong repo.

## 1. Deploy Railway Backend

Trong Railway dashboard:

1. `New Project`
2. `Deploy from GitHub repo`
3. Chon repo `AOH1010/crm-dashboard-app`
4. Railway se build tu `Dockerfile` o root repo

Sau do set variables:

- `GEMINI_API_KEY`
- `CRM_AGENT_MODEL=gemini-2.5-flash`
- `PREBUILD_DASHBOARD_DB=true`

Tiep theo:
- Mo service backend
- Vao `Settings`
- Bam `Generate Domain`

Ban se nhan duoc URL dang:

```text
https://your-backend-name.up.railway.app
```

Kiem tra nhanh:

```text
https://your-backend-name.up.railway.app/api/health
```

Neu thay `{"ok":true}` la backend da chay.

## 2. Deploy Vercel Frontend

Trong thu muc `UIUX`:

```powershell
cd "d:\Project\CRM 1\UIUX"
npx vercel login
```

Set environment variable:

```powershell
npx vercel env add VITE_API_BASE_URL production --value "https://your-backend-name.up.railway.app" --yes
npx vercel env add VITE_API_BASE_URL preview --value "https://your-backend-name.up.railway.app" --yes
```

Deploy:

```powershell
npx vercel --prod
```

## 3. Kiem tra sau deploy

- Mo domain Vercel
- Vao cac tab `Dashboard`, `Leads`, `Conversion`
- Kiem tra request `/api/...` da tro toi domain Railway

## 4. Luong cap nhat khi ban build tiep

- Sua UI: push repo, redeploy Vercel
- Sua backend/API: push repo, redeploy Railway
- Neu update du lieu: tao lai `data/crm.db.gz`, push repo, redeploy Railway

## 5. Nang cap sau nay

Khi muon Railway giu DB ben vung hon thay vi dung snapshot trong image:

1. Tao Railway Volume
2. Mount vao vi du `/data`
3. Set env:

```text
CRM_DATA_DIR=/data
CRM_DB_PATH=/data/crm.db
DASHBOARD_DB_PATH=/data/dashboard_sales.db
```

4. Copy `crm.db` len volume
5. Redeploy backend
