class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.20.tar.gz"
  sha256 "af51fe73b88be67536aca68ce8aaa30f523a95cc369652a6071d66beef8708ff"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "61d144264132e25c31f347dbdf3c44595be790e851d671159ffaa3d6027b0f04" => :catalina
    sha256 "0fb3b38c1c385bdfd8bbe930c3eb64b8b9d3cf4451715325e0f3717c9ade0b69" => :mojave
    sha256 "d6b3bda389b8d94685f47611d4abfa578d9b2166a2e9603ff07a6961a99f70c4" => :high_sierra
    sha256 "7c677291a95ecf35d0acd8f43716873975416ce318b8632ae89b7473ba1f0853" => :x86_64_linux
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
