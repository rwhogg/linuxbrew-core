class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.26.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.3/mpg123-1.26.3.tar.bz2"
  sha256 "30c998785a898f2846deefc4d17d6e4683a5a550b7eacf6ea506e30a7a736c6e"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "eaca212bd2fbd93cae9dff2142868c8ab2ba63c8f757657fa0f24a780f21b555" => :big_sur
    sha256 "95a40afc24b7ab30eff21a988421d9b172f5b073fe3291cf01db8b42531f5ca4" => :catalina
    sha256 "9b4f0e5aa8a80ff30ffa01c4076f76112d7252015416c5b58a7e5b4a5862d786" => :mojave
    sha256 "426a0e2c5650cd89be77a3aa78f8ebcb7bd5a2fd220675dc58c630be0ab0ec15" => :high_sierra
    sha256 "d7d9519895f1551580708a1e673448ef46b8cbf2f57e057f2fb512c21c8d4fe0" => :x86_64_linux
  end

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
      --with-cpu=x86-64
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
