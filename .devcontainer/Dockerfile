FROM elixir:1.17

RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends inotify-tools
rm -rf /var/lib/apt/lists/*
EOF

WORKDIR /code
