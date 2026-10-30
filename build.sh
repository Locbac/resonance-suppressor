#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_TYPE="Release"
TARGET=""
BUILD_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -Debug|--debug)
      BUILD_TYPE="Debug"
      shift
      ;;
    -Target|--target)
      TARGET="$2"
      shift 2
      ;;
    *)
      BUILD_ARGS+=("$1")
      shift
      ;;
  esac
done

BUILD_SUBDIR="$(echo "${BUILD_TYPE}" | tr '[:upper:]' '[:lower:]')"
BUILD_DIR="${ROOT_DIR}/build/${BUILD_SUBDIR}"

cmake -S "${ROOT_DIR}" -B "${BUILD_DIR}" -G Ninja \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
  -DRS_VST3_DIR="${BUILD_DIR}"

if [[ -n "${TARGET}" ]]; then
  cmake --build "${BUILD_DIR}" --target "${TARGET}" "${BUILD_ARGS[@]+"${BUILD_ARGS[@]}"}"
else
  cmake --build "${BUILD_DIR}" "${BUILD_ARGS[@]+"${BUILD_ARGS[@]}"}"
fi

if [[ "$(uname -s)" == "Darwin" ]] && [ -d "${BUILD_DIR}/resonance-suppressor.vst3" ] && [ -x /usr/bin/codesign ]; then
  /usr/bin/codesign -f -s - "${BUILD_DIR}/resonance-suppressor.vst3" >/dev/null 2>&1 || true
fi
