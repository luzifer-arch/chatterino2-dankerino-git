# Maintainer: Knut Ahlers

pkgname=chatterino2-dankerino-git
pkgver=2025.01.17
pkgrel=1
pkgdesc="Fork of Chatterino 2"
arch=(any)
url=https://github.com/Mm2PL/dankerino
license=('MIT')
depends=('qt6-base' 'qt6-tools' 'boost-libs' 'openssl' 'qt6-imageformats' 'qtkeychain-qt6' 'qt6-5compat' 'qt6-svg')
makedepends=('git' 'boost' 'cmake')
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
sha512sums=('635ada269b9aeb41c4cc3161d6552712c7185ce647c3917c9e831a9d273bd0c5f61985c702e4f17fc7554d21af3e4e88e14b0490a74868b3a5f92181f5255f66')

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
