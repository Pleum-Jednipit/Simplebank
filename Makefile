postgres:
	docker run --name postgres14 --network bank-network -p 5000:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5000/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5000/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5000/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5000/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	docker run --rm -v "$(CURDIR):/src" -w //src kjconroy/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

add_migrate:
	migrate create -ext sql -dir db/migration -seq add_users

mock:
	mockgen -package mockdb -destination db/mock/store.go  github.com/Pleum-Jednipit/simplebank/db/sqlc Store

network:
	docker network create bank-network

server-docker:
	docker run --name simplebank --network bank-network -p 8082:8082 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@172.18.0.2:5432/simple_bank?sslmode=disable" simplebank:latest