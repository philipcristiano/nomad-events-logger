FROM rust:1.72 as builder
WORKDIR /usr/src/app
COPY . .
RUN cargo install --path .

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/nomad-events-logger /usr/local/bin/nomad-events-logger
CMD ["nomad-events-logger"]
