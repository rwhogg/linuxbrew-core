class Sword < Formula
  desc "Cross-platform tools to write Bible software"
  homepage "https://www.crosswire.org/sword/index.jsp"
  url "https://www.crosswire.org/ftpmirror/pub/sword/source/v1.9/sword-1.9.0.tar.gz"
  sha256 "42409cf3de2faf1108523e2c5ac0745d21f9ed2a5c78ed878ee9dcc303426b8a"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.crosswire.org/ftpmirror/pub/sword/source/"
    regex(%r{href=.*?sword[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 "65d2da4bfbc5517b4fba2d4da6a4b57ff2429126041c59ee83ad29886df71d70" => :catalina
    sha256 "84420513bcd1215cfcee1737022551b86d80059a0dfb1de6fc82dcec050280a2" => :mojave
    sha256 "42b2dfd8162cd7b96efeba4da340df7dafae5f581be6c6bbb47f37a07bd9f66a" => :high_sierra
    sha256 "aac335148a7b35a5c53b27acb0744ab778cb33fccfc85f55223c8dabd5f60385" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-profile
      --disable-tests
      --with-curl
      --without-icu
      --without-clucene
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    # This will call sword's module manager to list remote sources.
    # It should just demonstrate that the lib was correctly installed
    # and can be used by frontends like installmgr.
    system "#{bin}/installmgr", "-s"
  end
end
