function prerequisites() {
    mkdir -p /usr/local/bin
}

function install() {
  curl -s https://raw.githubusercontent.com/koolwithk/parallelx.sh/main/parallelx.sh -o /usr/local/bin/parallelx
  chmod +x /usr/local/bin/parallelx
  echo "Installed parallelx at /usr/local/bin/parallelx"
  echo 'set PATH="$PATH:/usr/local/bin" if not set'
}

#call functions
prerequisites
install