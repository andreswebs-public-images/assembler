FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8

RUN \
  apt-get update && \
  apt-get install --yes binutils bash gdb nasm file procps python3 && \
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
    --shell /bin/bash \
    "${USERNAME}"

ADD https://gef.blah.cat/py "/home/${USERNAME}/.gdbinit-gef.py"

RUN \
  echo 'source ~/.gdbinit-gef.py' >> "/home/${USERNAME}/.gdbinit" && \
  chown "${PUID}:${PGID}" "/home/${USERNAME}/.gdbinit-gef.py" && \
  chown "${PUID}:${PGID}" "/home/${USERNAME}/.gdbinit"

COPY assembler.sh /usr/local/bin/assembler
RUN chmod +x /usr/local/bin/assembler

RUN \
  mkdir "/${USERNAME}" &&\
  chown "${PUID}:${PGID}" -R "/${USERNAME}"

WORKDIR "/${USERNAME}"
USER "${USERNAME}"

ENTRYPOINT ["/usr/local/bin/assembler"]
