# luxo-env 🌴

Use my development environment!

### Setup

```bash
cat luxo-example.conf > luxo.conf
```

Update `luxo.conf` with the following environment variables:

```bash
GIT_NAME=
GIT_EMAIL=
```

### Usage
```bash
./setup.sh --help

Usage: ./setup.sh [OPTIONS]

Options:
  --no-vim               Skip Vim setup.
  --no-bin               Skip Binary setup.
  --no-haskell           Skip Haskell setup.
  --no-js                Skip JavaScript setup.
  --no-python            Skip Python setup.
  --no-zsh               Skip Zsh setup.
  --no-git               Skip Git setup.
  --skip-signed-commits  Skip GPG signed commits setup.
  -h, --help             Show this help message and exit.
```
