class Libxp < Formula
  desc "X Print Client Library"
  homepage "https://gitlab.freedesktop.org/xorg/lib/libxp"
  url "https://gitlab.freedesktop.org/xorg/lib/libxp/-/archive/libXp-1.0.3/libxp-libXp-1.0.3.tar.bz2"
  sha256 "bd1e449572359921dd5fa20707757f57d7535aff1772570ab2c29c6b49b86266"
  license "MIT"

  livecheck do
    url :stable
    regex(/^libXp[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "e70342d93c5cf690582f559318b05b26da9175fc7620493fa15a224a847ec1da" => :catalina
    sha256 "1cc823e7fe3acb64e58b554e5e956302959f28cb5737eea5c6d15655128aee15" => :mojave
    sha256 "8e904b533b4c4264232ae6391e7d4bc37dade77d5d20539ed3d42900ab3950ce" => :high_sierra
    sha256 "96c3bde8db1c0a717f1c2f02db4a81a595a59b96d483894d40461e6b43728704" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxext"

  resource "printproto" do
    url "https://gitlab.freedesktop.org/xorg/proto/printproto/-/archive/printproto-1.0.5/printproto-printproto-1.0.5.tar.bz2"
    sha256 "f2819d05a906a1bc2d2aea15e43f3d372aac39743d270eb96129c9e7963d648d"
  end

  def install
    resource("printproto").stage do
      system "sh", "autogen.sh"
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
    system "sh", "autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xp").chomp
  end
end
