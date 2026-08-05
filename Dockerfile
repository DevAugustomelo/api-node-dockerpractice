# Build stage: install dependencies in a clean layer
FROM node:24-alpine AS deps

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --omit=dev

# Final runtime image with minimal footprint
FROM node:24-alpine AS release

WORKDIR /usr/src/app
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --chown=node:node . .

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

USER node
CMD ["node", "index.js"]
