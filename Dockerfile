FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd/...


FROM alpine:latest AS development
WORKDIR /app
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/server ./
EXPOSE 80
CMD ["/app/server"]