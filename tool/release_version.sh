#!/usr/bin/env bash
# Prints the app's version for the stores from a release tag (docs/STORE.md, Release CI), as
# key=value lines for $GITHUB_OUTPUT:
#
#   name        Android versionName: the tag without the v (1.2.0-alpha.3)
#   ios_name    iOS CFBundleShortVersionString: X.Y.Z only, Apple refuses anything else
#   code        build number of both stores (Android versionCode, iOS CFBundleVersion)
#   prerelease  true for -alpha.N, -beta.N, -rc.N
#
# code = ((X*100 + Y)*100 + Z)*100 + S, where S is N for alpha.N (1-29), 30+N for beta.N, 60+N
# for rc.N and 99 for a release: it follows the version order (alpha < beta < rc < release) and
# a tag always gives the same code, so a rerun finds the build it already uploaded. A tag is
# never moved, so a code is never needed twice.
#
#   tool/release_version.sh v1.2.0-alpha.3
set -euo pipefail

tag=${1:?usage: release_version.sh vX.Y.Z[-alpha.N|-beta.N|-rc.N]}

# The versions release-tools' create-release accepts
version_re='^v([0-9]+)\.([0-9]+)\.([0-9]+)(-(alpha|beta|rc)\.([0-9]+))?$'
if [[ ! "$tag" =~ $version_re ]]; then
  echo "$tag is not vX.Y.Z or vX.Y.Z-alpha.N, -beta.N, -rc.N" >&2
  exit 1
fi
major=$((10#${BASH_REMATCH[1]}))
minor=$((10#${BASH_REMATCH[2]}))
patch=$((10#${BASH_REMATCH[3]}))
stage=${BASH_REMATCH[5]}
n=${BASH_REMATCH[6]:+$((10#${BASH_REMATCH[6]}))}

if [ "$minor" -gt 99 ] || [ "$patch" -gt 99 ]; then
  echo "$tag: the build number has room for minor and patch versions up to 99" >&2
  exit 1
fi
case $stage in
alpha) offset=0 ;;
beta) offset=30 ;;
rc) offset=60 ;;
*) offset=99 n=0 ;;
esac
if [ -n "$stage" ] && { [ "$n" -lt 1 ] || [ "$n" -gt 29 ]; }; then
  echo "$tag: the build number has room for $stage.1 to $stage.29" >&2
  exit 1
fi

code=$(((((major * 100 + minor) * 100 + patch) * 100) + offset + n))
# Google Play's limit
if [ "$code" -gt 2100000000 ]; then
  echo "$tag: the build number $code is above Google Play's 2100000000" >&2
  exit 1
fi

echo "name=${tag#v}"
echo "ios_name=$major.$minor.$patch"
echo "code=$code"
echo "prerelease=$([ -n "$stage" ] && echo true || echo false)"
