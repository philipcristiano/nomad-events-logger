FROM rust:1.85-bookworm as builder
WORKDIR /usr/src/app
COPY . .
RUN cargo install --path .

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/nomad_events_logger /usr/local/bin/nomad_events_logger
CMD ["nomad_events_logger"]
