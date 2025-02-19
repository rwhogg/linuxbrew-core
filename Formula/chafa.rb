class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.4.1.tar.xz"
  sha256 "46d34034f4c96d120e0639f87a26590427cc29e95fe5489e903a48ec96402ba3"
  license "GPL-3.0"
  revision 1

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "040dab4ba89bdd45f5fc1429fd40f4952b0b1b1365e7143f0a8f2fab9f14d60f" => :catalina
    sha256 "d102685671b1816d8c7b79e530d960778dc58655593721e0fdcd69a99b29fed1" => :mojave
    sha256 "f75d4bbd7bfe8caaec6b386b8217c70ee432c17d7dd9ebf42ae04c0c58a88ca2" => :high_sierra
    sha256 "983c9156edacebadd8f0a07aa7d85fec48284acbb18f6223c36f7ba1f646957d" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "imagemagick"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 4, output.lines.count
  end
end
