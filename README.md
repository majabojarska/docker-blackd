# Docker Black Daemon

<p align="left">
    <a href="https://hub.docker.com/r/majabojarska/blackd">
        <img alt="Docker Image Version (tag latest semver)" src="https://img.shields.io/docker/v/majabojarska/blackd/latest">
    </a>
    <a href="https://hub.docker.com/r/majabojarska/blackd">
        <img alt="Docker Image Size (tag)" src="https://img.shields.io/docker/image-size/majabojarska/blackd/latest">
    </a>
    <a href="https://hub.docker.com/r/majabojarska/blackd">
        <img alt="Docker Automated build" src="https://img.shields.io/docker/automated/majabojarska/blackd">
    </a>
</p>

[Black](https://github.com/psf/black) formatter HTTP server daemon in a Docker container. 

Comes preinstalled with additional `python2` and `uvloop` extras by default. Provides support for Python 2 and 3. Runs on [uvloop](https://github.com/MagicStack/uvloop), the blazing fast replacement of the [asyncio](https://docs.python.org/3/library/asyncio.html) event loop. 

## Quick Start

Run the latest image as a daemon, bind port `45484` from host to container.

```bash
docker run -d -p 45484:45484 majabojarska/blackd:latest
```

## Building the image

### Docker Build Arguments

| Argument        | Default          | Value                     | Description                                                                               |
| --------------- | ---------------- | ------------------------- | ----------------------------------------------------------------------------------------- |
| `BLACK_VERSION` | unset            | `<VERSION>`               | Black version to install in the target Docker image.                                      |
| `BLACK_EXTRAS`  | `python2,uvloop` | `<Extras delimited by ,>` | Additional black extas to install. The daemon extra (`d`) is always installed by default. |
| `BLACKD_PORT`   | `45484`          | `<PORT>`                  | TCP port number for blackd                                                                |
| `MAINTAINER`    | unset            | `<MAINTAINER>`            | Maintainer name                                                                           |
| `NAME`          | unset            | `<NAME>`                  | Image name                                                                                |

### Build for local platform 

Run `docker build` from the project's root directory.

```bash
docker build \
    --build-arg BLACK_VERSION=<VERSION> \
    [--build-arg BLACK_EXTRAS=<EXTRAS>] \
    [--build-arg BLACKD_PORT=<PORT>] \
    [--build-arg MAINTAINER=<MAINTAINER>] \
    [--build-arg NAME=<NAME>] \
    --tag <TAG> .
```

### Build for multiple platforms

Multiplatform, non-native builds can be created via [qemu](https://github.com/qemu/QEMU) and [buildx](https://github.com/docker/buildx).

```bash
docker buildx build --push \
    --platform linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/s390x \
    --build-arg BLACK_VERSION=<VERSION> \
    [--build-arg BLACK_EXTRAS=<EXTRAS>] \
    [--build-arg BLACKD_PORT=<PORT>] \
    [--build-arg MAINTAINER=<MAINTAINER>] \
    [--build-arg NAME=<NAME>] \
    --tag <TAG> .
```

