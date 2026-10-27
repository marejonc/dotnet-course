#!/usr/bin/env bash
# Seeds the dev database (docker compose "db" service) with dummy Stocks and Comments.
# Usage: ./scripts/seed.sh   (run from the api/ folder or anywhere)
set -euo pipefail

cd "$(dirname "$0")/.."

docker compose exec -T db psql -v ON_ERROR_STOP=1 -U myapi -d myapi < scripts/seed.sql

echo "Seeded Stocks and Comments."
