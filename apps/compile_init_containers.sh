cd -e backend
docker build . -t cubos_backend:latest
cd ..
cd -e frontend
docker build . -t cubos_frontend:latest
cd ..
docker compose up -d