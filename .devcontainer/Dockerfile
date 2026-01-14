FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc-arm-linux-gnueabi libc6-dev-armel-cross \
    qemu-user gdb-multiarch curl ca-certificates procps git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fLo /root/.gdbinit https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit
