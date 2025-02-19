class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  license "Zlib"
  revision OS.mac? ? 1 : 2

  stable do
    url "https://libsdl.org/release/SDL2-2.0.12.tar.gz"
    sha256 "349268f695c02efbc9b9148a70b85e58cefbbf704abd3e91be654db7f1e2c863"

    # Fix library extension in CMake config file.
    # https://bugzilla.libsdl.org/show_bug.cgi?id=5039
    patch do
      url "https://bugzilla.libsdl.org/attachment.cgi?id=4263"
      sha256 "07ea066e805f82d85e6472e767ba75d265cb262053901ac9a9e22c5f8ff187a5"
    end
  end

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/SDL2[._-]v?(\d+(?:\.\d+)*)/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "7ee842d81f00d7cc3943854e99535d177b0b0bc4edb84aa957e6980975d281d5" => :big_sur
    sha256 "4a074d422e597b6f68c61cff5ee7d212264f3392b1c40a185a01cf180fe34516" => :catalina
    sha256 "7d757169bb95da1477e01a4704e8ad204fccfb1cabb3292cee3449885e14e6b8" => :mojave
    sha256 "5c7aa312b1a5d7fb8fe3fcd2112a8a74250bb84954024794333b465acafbee4f" => :high_sierra
    sha256 "a00ff5d341355661fdacf093e140f52288f64d2d7781aa86b4ae91680729f1fd" => :x86_64_linux
  end

  head do
    url "https://hg.libsdl.org/SDL", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  unless OS.mac?
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "linuxbrew/xorg/xinput"
    depends_on "pulseaudio"
  end

  def install
    # we have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = if OS.mac?
      %W[--prefix=#{prefix} --without-x]
    else
      %W[--prefix=#{prefix} --with-x]
    end

    args << "--enable-hidapi"

    unless OS.mac?
      args += %w[
        --enable-pulseaudio
        --enable-pulseaudio-shared
        --enable-video-dummy
        --enable-video-opengl
        --enable-video-opengles
        --enable-video-x11
        --enable-video-x11-scrnsaver
        --enable-video-x11-xcursor
        --enable-video-x11-xinerama
        --enable-video-x11-xinput
        --enable-video-x11-xrandr
        --enable-video-x11-xshape
        --enable-x11-shared
      ]
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
