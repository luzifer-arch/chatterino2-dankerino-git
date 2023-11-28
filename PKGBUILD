# Maintainer: Knut Ahlers

pkgname=chatterino2-dankerino-git
pkgver=2023.11.28
pkgrel=1
pkgdesc="Fork of Chatterino 2"
arch=(any)
url=https://github.com/Mm2PL/dankerino
license=('MIT')
depends=('qt5-base' 'qt5-tools' 'boost-libs' 'openssl' 'qt5-imageformats' 'qtkeychain-qt5')
makedepends=('git' 'qt5-svg' 'boost' 'cmake')
optdepends=(
  'streamlink: For piping streams to video players'
  'pulseaudio: For audio output'
)
provides=('chatterino')
conflicts=('chatterino')

source=("git+${url}.git#tag=nightly-build")
sha512sums=('SKIP')

build() {
  cd "${srcdir}/dankerino"

  mkdir -p build
  cd build

  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_SYSTEM_QTKEYCHAIN=ON \
    -DUSE_PRECOMPILED_HEADERS=OFF \
    ..

  if [ -z "$CCACHE_SLOPPINESS" ]; then
    # We need to set the ccache sloppiness for the chatterino build to use it properly
    # This is due to our use of precompiled headers
    # See https://ccache.dev/manual/3.3.5.html#_precompiled_headers
    CCACHE_SLOPPINESS="pch_defines,time_macros"
    export CCACHE_SLOPPINESS
  fi

  make
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
