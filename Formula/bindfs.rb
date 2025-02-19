class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.8.tar.gz"
  sha256 "e5ca5aff55204b993a025a77c3f8c0e2ee901ba8059d71bea11de2cc685ec497"
  license "GPL-2.0"

  deprecate! because: "requires FUSE"

  bottle do
    cellar :any
    sha256 "bf4fb90d788651299973a3f48300824ae6b4ec4ce1441dd94d544180f54379bd" => :catalina
    sha256 "cc9d4950a1b74a27307bac429892fd85ad439f5707f53a66e800a39b23a32fdf" => :mojave
    sha256 "50df08ee8d3cc6f141d8488341f12c32ce478f02dfb8016f533bfeababfe4537" => :high_sierra
    sha256 "fb4b84127bac0e1c7559e5f0b8d3b8d62aea5e0d1192d8f516aec5e9eee0cfe1" => :x86_64_linux
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  if OS.mac?
    depends_on :osxfuse
  else
    depends_on "libfuse"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
