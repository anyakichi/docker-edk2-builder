FROM ubuntu:18.04

RUN \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    gcc-5 \
    git \
    gosu \
    iasl \
    nasm \
    software-properties-common \
    sudo \
    uuid-dev \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3.9 python3.9-distutils \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 10 \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 20 \
  && rm -rf /var/lib/apt/lists/*

RUN \
  useradd -ms /bin/bash builder && \
  echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER builder
RUN \
  echo '. <(buildenv init)' >> ~/.bashrc && \
  git config --global user.email "builder@edk2" && \
  git config --global user.name "EDK2 Builder"

USER root
WORKDIR /home/builder

ENV \
  EDK2_BRANCH="" \
  EDK2_ACTIVE_PLATFORM="OvmfPkg/OvmfPkgX64.dsc" \
  EDK2_TARGET="RELEASE" \
  EDK2_TARGET_ARCH="X64" \
  EDK2_TOOL_CHAIN_TAG="GCC5"

COPY buildenv/entrypoint.sh /usr/local/sbin/entrypoint
COPY buildenv/buildenv.sh /usr/local/bin/buildenv

COPY buildenv/buildenv.conf /etc/
COPY buildenv.d/ /etc/buildenv.d/

RUN \
  sed -i -e 's/^#ALIASES=.*/ALIASES="extract setup"/' \
         -e 's/^#DOTCMDS=.*/DOTCMDS=setup/' \
    /etc/buildenv.conf

ENTRYPOINT ["/usr/local/sbin/entrypoint"]
CMD ["/bin/bash"]
