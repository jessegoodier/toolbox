# Toolbox

A debug container for Kubernetes. Because `kubectl exec` into an alpine container with nothing but `sh` is not fun.

## What's Inside

**Common base image** (`toolbox-common`):
- `openssl`, `kubectl`, `curl`, `wget`, `jq`, `yq`
- `dig`, `nslookup`, `doggo`, `mtr`, `ping`, `netcat`, `tcpdump`
- `htop`, `strace`, `lsof`, `ps`
- `ripgrep`, `rclone`, `tree`, `less`, `file`
- `neovim`, `git`
- `bash` + `zsh` with completions and syntax highlighting
- Python 3.14 + `uv`

**Cloud-specific images** (built on top of common):
- `toolbox-aws` - AWS CLI
- `toolbox-gcp` - Google Cloud SDK
- `toolbox-azure` - Azure CLI

All images are multi-arch (`amd64`/`arm64`) and rebuilt daily.

## Usage

```bash
# One-off debug pod
kubectl run debug --rm -it --image=ghcr.io/jessegoodier/toolbox-common -- zsh

# Or with cloud tools
kubectl run debug --rm -it --image=ghcr.io/jessegoodier/toolbox-aws -- zsh
```

## Images

| Image | Description |
|-------|-------------|
| `ghcr.io/jessegoodier/toolbox-common` | Base image with common tools |
| `ghcr.io/jessegoodier/toolbox-aws` | + AWS CLI |
| `ghcr.io/jessegoodier/toolbox-gcp` | + gcloud |
| `ghcr.io/jessegoodier/toolbox-azure` | + az CLI |

## Building Locally

```bash
# Dry run (no push)
./build_images.sh

# Push to registry
PUSH=true ./build_images.sh
```

## License

Do whatever you want with it. If it breaks your cluster, you get to keep both pieces.
