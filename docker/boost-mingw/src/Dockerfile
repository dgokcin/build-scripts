#
# Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
#
# Distributed under the MIT License (see accompanying LICENSE)
#

FROM abrarov/mingw:2.8.0

ENV BOOST_VERSION="1.72.0" \
    BOOST_RELEASE_URL="https://dl.bintray.com/boostorg/release" \
    B2_OPTIONS="--without-python --without-mpi --without-graph_parallel"

ADD ["app", "C:/app/"]

VOLUME ["C:/target"]

CMD ["powershell", "-ExecutionPolicy", "Bypass", "-File", "C:\\app\\start.ps1"]

ARG image_version=""
ARG image_revision=""

LABEL name="abrarov/boost-mingw" \
    version="${image_version}" \
    revision="${image_revision}" \
    description="Builder of Boost C++ Libraries with MinGW"
