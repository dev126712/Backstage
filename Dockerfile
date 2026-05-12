# Stage 1: Build
FROM node:20-bookworm-slim AS build

# Install build essentials for native modules (like sqlite3/pg)
RUN apt-get update && apt-get install -y \
    python3 g++ make libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

USER node
WORKDIR /app

# Copy the dependency files first (optimizes caching)
COPY --chown=node:node package.json yarn.lock .yarnrc.yml ./
COPY --chown=node:node packages/app/package.json packages/app/
COPY --chown=node:node packages/backend/package.json packages/backend/

# Force the standard node_modules layout
RUN yarn config set nodeLinker node-modules
RUN yarn install --network-timeout 1000000

# Copy the rest of the source code
COPY --chown=node:node . .

# Build the app (this might take a while)
RUN yarn build:all

# Stage 2: Final Run
FROM node:20-bookworm-slim
WORKDIR /app

COPY --from=build /app .

EXPOSE 3000 7007
CMD ["yarn", "dev"]
