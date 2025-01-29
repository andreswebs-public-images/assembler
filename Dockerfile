FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install --yes binutils bash gdb nasm && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ARG PUID=1000
ARG PGID=1000
ARG USERNAME=code

RUN \
  addgroup \
    --gid "${PGID}" "${USERNAME}" && \
  adduser \
    --gid "${PGID}" \
    --uid "${PUID}" \
    --gecos "" \
    --disabled-password \
    --shell /bin/sh \
    --home "/${USERNAME}" \
    "${USERNAME}"

COPY assembler.sh /usr/local/bin/assembler
RUN chmod +x /usr/local/bin/assembler

WORKDIR "/${USERNAME}"
USER "${USERNAME}"

ENTRYPOINT ["/usr/local/bin/assembler"]
