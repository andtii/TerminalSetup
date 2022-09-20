podman machine start
podman stop keydb
podman rm keydb
podman run -p 6379:6379 --name keydb -d eqalpha/keydb