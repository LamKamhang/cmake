#!/usr/bin/env bash

PROJ_ROOT="$(dirname "$(dirname "$(realpath "$0")")")"
CPM_VERSION=${CPM_VERSION:-0.38.2}
echo "fetch CPM.cmake@${CPM_VERSION}"
wget -O "${PROJ_ROOT}"/core/CPM.cmake "https://github.com/cpm-cmake/CPM.cmake/releases/download/v${CPM_VERSION}/CPM.cmake"
