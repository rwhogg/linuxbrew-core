class Lha < Formula
  desc "Utility for creating and opening lzh archives"
  homepage "https://lha.osdn.jp/"
  # Canonical: https://osdn.net/dl/lha/lha-1.14i-ac20050924p1.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/lha/22231/lha-1.14i-ac20050924p1.tar.gz"
  version "1.14i-ac20050924p1"
  sha256 "b5261e9f98538816aa9e64791f23cb83f1632ecda61f02e54b6749e9ca5e9ee4"
  license "MIT"

  # OSDN releases pages use asynchronous requests to fetch the archive
  # information for each release, rather than including this information in the
  # page source. As such, we identify versions from the release names instead.
  # The portion of the regex that captures the version is looser than usual
  # because the version format is unusual and may change in the future.
  livecheck do
    url "https://osdn.net/projects/lha/releases/"
    regex(%r{href=.*?/projects/lha/releases/[^>]+?>\s*?v?(\d+(?:[.-][\da-z]+)+)}im)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "27d0090517f08c929e062ea580515f38297ac00ff403830bc78c2b85caea0447" => :catalina
    sha256 "2b5e8d256e2d232014ee9b4dc08a52188dc8e5369f61290f5cdb7381e78b3561" => :mojave
    sha256 "f1dac02888773ade3d6c35eeb69c6cb25e08bf91584ae66fec7a362f80583e78" => :high_sierra
    sha256 "450fa8188af44eef619302c402860dfd2debab864487424211fbbfa7ff065955" => :sierra
    sha256 "35f3e193c1bf0d26c62ea6897721c559191fea64f27d71781a90f670d9a23557" => :el_capitan
    sha256 "9cb516a73d1d117c39f63d16b3211df626783c9bb1a7038f524dd9c36045b1ac" => :yosemite
    sha256 "bd26a5a48396d06019f7998f4c9bf511a74ef237814fee5f5c8ba9df31b30a37" => :mavericks
    sha256 "3c3a36157f2adf1bab2014add505dee8b0a0f7b87a8c4b7f37a16fbbe43e2349" => :x86_64_linux # glibc 2.19
  end

  head do
    url "https://github.com/jca02266/lha.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  conflicts_with "lhasa", because: "both install a `lha` binary"

  def install
    system "autoreconf", "-is" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/lha", "c", "foo.lzh", "foo"
    assert_equal "::::::::\nfoo\n::::::::\ntest",
      shell_output("#{bin}/lha p foo.lzh")
  end
end
