# Stage 1 - build
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main ./cmd/api/main.go

# Stage 2 - run
FROM alpine:latest
RUN adduser -D appuser
WORKDIR /app
COPY --from=builder /app/main .
USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s CMD wget -qO- http://localhost:8080/health || exit 1
CMD ["./main"]
