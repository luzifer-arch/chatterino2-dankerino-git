# Maintainer: Knut Ahlers

pkgname=chatterino2-dankerino-git
pkgver=2025.03.21
pkgrel=1
pkgdesc="Fork of Chatterino 2"
arch=(any)
url=https://github.com/Mm2PL/dankerino
license=('MIT')
depends=(
  'boost-libs'
  'libnotify'
  'openssl'
  'qt6-5compat'
  'qt6-base'
  'qt6-imageformats'
  'qt6-svg'
  'qt6-tools'
  'qtkeychain-qt6'
)
makedepends=(
  'boost'
  'cmake'
  'git'
)
optdepends=(
  'streamlink: For piping streams to video players'
  'pulseaudio: For audio output'
)
provides=('chatterino')
conflicts=('chatterino')

# We temporarily disable LTO since we get an ICE when compiling with gcc since this commit https://github.com/Chatterino/chatterino2/commit/ed20e71db4c957d3b2a8ce9350b847f4c805cb83
# Bug report tracking https://gcc.gnu.org/bugzilla/show_bug.cgi?id=114501
options=('!lto')

source=("git+${url}.git#tag=nightly-build")
sha512sums=('efffbeb05391c4855299e3e643ca8e4a0997bb4538626382bd08af1ad08360c6a127d891687a6572e90aec68924da188f7c088d98d51bbcc5e97f9753dff190c')

build() {
  cd "${srcdir}/dankerino"

  mkdir -p build
  cd build

  declare -a flags
  if [[ $CXXFLAGS == *"-flto"* ]]; then
    flags+=("-DCHATTERINO_LTO=ON")
  fi

  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_SYSTEM_QTKEYCHAIN=ON \
    -DUSE_PRECOMPILED_HEADERS=OFF \
    -DBUILD_WITH_QT6=ON \
    -DCHATTERINO_UPDATER=OFF \
    -DCHATTERINO_PLUGINS=ON \
    "${flags[@]}" \
    ..

  cmake --build .
}

package() {
  cd "$srcdir/dankerino"

  if [ -f "build/bin/chatterino" ] && [ -x "build/bin/chatterino" ]; then
    echo "Getting chatterino binary from bin folder"
    install -Dm755 "build/bin/chatterino" "$pkgdir/usr/bin/chatterino"
  else
    echo "Getting chatterino binary from NON-BIN folder"
    # System ccache is enabled, causing the binary file to not fall into the bin folder
    # Temporary solution until we have figured out a way to stabilize the ccache output
    install -Dm755 "build/chatterino" "$pkgdir/usr/bin/chatterino"
  fi

  install -Dm644 "resources/com.chatterino.chatterino.desktop" "$pkgdir/usr/share/applications/com.chatterino.chatterino.desktop"
  install -Dm644 "resources/icon.png" "$pkgdir/usr/share/pixmaps/chatterino.png"
}

pkgver() {
  cd "${srcdir}/dankerino"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

prepare() {
  cd "${srcdir}/dankerino"
  git submodule update --init --recursive
}
