#!/usr/bin/env bash

CPM_VERSION=${CPM_VERSION:-0.38.1}
echo "fetch CPM.cmake@${CPM_VERSION}"
wget -O core/CPM.cmake "https://github.com/cpm-cmake/CPM.cmake/releases/download/v${CPM_VERSION}/CPM.cmake"
