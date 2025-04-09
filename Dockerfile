FROM ubuntu:22.04
LABEL \
    org.opencontainers.image.title="OpenWrt v24.10.0" \
    org.opencontainers.image.vendor="Ubuntu22 build system" \
    org.opencontainers.image.licenses="Apache" \
    org.opencontainers.image.created="2025-04-09" \
    maintainer="slackman.cn"

ENV DEBIAN_FRONTEND=noninteractive \
    FORCE_UNSAFE_CONFIGURE=1 \
    TZ=Asia/Shanghai 

RUN apt-get update && apt-get install -y --no-install-recommends tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata 

# Install build base
RUN apt-get update && apt-get install -y \
    build-essential clang flex bison g++ gawk \
    gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev \
    python3-distutils python3-setuptools rsync swig unzip zlib1g-dev file wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# cannot use clone depth=1, revision checks on updating
RUN git clone -b v24.10.0 --single-branch https://git.openwrt.org/openwrt/openwrt.git /openwrt
WORKDIR /openwrt
COPY config/x64.config /openwrt/.config
RUN ./scripts/feeds update -a \
 && ./scripts/feeds install -a \
 && make download


CMD ["bash"]
