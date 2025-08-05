# 多阶段构建
FROM --platform=$BUILDPLATFORM golang:1.20 as builder

WORKDIR /app
COPY . .

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ENV CGO_ENABLED=0

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH GOARM=7 go build -o /komari-agent -trimpath -ldflags="-s -w" main.go

# 运行阶段
FROM --platform=$TARGETPLATFORM alpine
COPY --from=builder /komari-agent /usr/local/bin/komari-agent
ENTRYPOINT ["komari-agent"]


