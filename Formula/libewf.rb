class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  url "https://github.com/libyal/libewf-legacy/releases/download/20140808/libewf-20140808.tar.gz"
  sha256 "dfe29b5f2f1841ff1fe11979780d710a660dbc4727af82ec391f398e6b49e5fd"
  license "LGPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "90d6e46a7b6e0590c80da6d9316ff7ab61bf2b143a254542ae134101b3c11290" => :big_sur
    sha256 "43d8ba6c2441f65080f257a7239fe468be70cb2578ec2106230edd1164e967b6" => :catalina
    sha256 "4c5482f8f1c97f9c3f3687bccd9c3628b314699bc26743e641f2ae573bf95eeb" => :mojave
    sha256 "cae6fd2f38855fd15f8a50b644d0817181fed055aef85b7793759d7703a833d4" => :high_sierra
    sha256 "235d0916edc7a6877b4993ea9d89d59810f11d024118bea0826f347268fd6f2a" => :x86_64_linux
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Workaround bug in gcc-5 that causes the following error:
    # undefined reference to `libuna_ ...
    ENV.append_to_cflags "-std=gnu89" if ENV.cc == "gcc-5"

    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libfuse=no
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
