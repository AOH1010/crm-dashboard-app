FROM node:22-bookworm-slim

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3001
ENV HOST=0.0.0.0
ENV PREBUILD_DASHBOARD_DB=true

COPY UIUX/package.json UIUX/package-lock.json ./UIUX/
RUN cd UIUX && npm ci --omit=dev --legacy-peer-deps

COPY UIUX/server ./UIUX/server
COPY data/crm.db.gz ./data/crm.db.gz
RUN node -e "const fs=require('fs'); const zlib=require('zlib'); const { pipeline } = require('stream/promises'); fs.mkdirSync('./data', { recursive: true }); pipeline(fs.createReadStream('./data/crm.db.gz'), zlib.createGunzip(), fs.createWriteStream('./data/crm.db')).then(() => fs.unlinkSync('./data/crm.db.gz')).catch((error) => { console.error(error); process.exit(1); });"

EXPOSE 3001

CMD ["npm", "--prefix", "UIUX", "run", "start"]
