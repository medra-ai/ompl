#!/usr/bin/env bash

set -eux

build_os="$(uname)"

if [ "${build_os}" == "Linux" ]; then
    yum -y install \
        sudo \
        eigen3 \
        llvm-devel \
        clang-devel

    # manylinux ships with a pypy installation. Make it available on the $PATH
    # so the OMPL build process picks it up and can make use of it during the
    # Python binding generation stage.
    ln -s /opt/python/pp310-pypy310_pp73/bin/pypy /usr/bin
elif [ "${build_os}" == "Darwin" ]; then
    export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
    export HOMEBREW_NO_AUTO_UPDATE=1

    env

    # Overwrite whatever Python binaries are shipped in our CI image.
    # see: https://github.com/orgs/Homebrew/discussions/3895
    brew install --force --overwrite python@3.12

    brew install \
        eigen \
        pypy3 \
        castxml \
        llvm@16
fi
