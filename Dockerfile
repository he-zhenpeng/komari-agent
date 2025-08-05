# 构建阶段
FROM --platform=$BUILDPLATFORM golang:1.20 AS builder
WORKDIR /app
COPY . .
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ENV CGO_ENABLED=0
RUN go mod tidy && GOOS=$TARGETOS GOARCH=$TARGETARCH GOARM=7 go build -o /komari-agent -trimpath -ldflags="-s -w" main.go

# 运行阶段
FROM alpine:3.22.1
COPY --from=builder /komari-agent /usr/local/bin/komari-agent
ENTRYPOINT ["komari-agent"]
