class Slrn < Formula
  desc "Powerful console-based newsreader"
  homepage "https://slrn.sourceforge.io/"
  url "https://jedsoft.org/releases/slrn/slrn-1.0.3a.tar.bz2"
  sha256 "3ba8a4d549201640f2b82d53fb1bec1250f908052a7983f0061c983c634c2dac"
  license "GPL-2.0-or-later"
  revision 1
  head "git://git.jedsoft.org/git/slrn.git"

  livecheck do
    url "https://jedsoft.org/releases/slrn/"
    regex(/href=.*?slrn[._-]v?(\d+(?:\.\d+)+(?:[a-z]?\d*)?)\.t/i)
  end

  bottle do
    sha256 "de190a3f3793acd7d8e50dc82231e7ad94535621bc4c37a34efcc1907c295296" => :catalina
    sha256 "9dcfea5ecabef7b65a480fec81ab5b1dcc7a67d45bb8fab0d35821684ab56d0e" => :mojave
    sha256 "417197dcbd30a8330f2a3a1e5171b2f3c2ed7869cca8d2fb302108ae391f4072" => :high_sierra
    sha256 "dac0b018eb8f1d53b69ae27ca121510806f0eb9bbdcdbdd119295bd022a8faaf" => :sierra
    sha256 "a86b359e069d47034f6cffd5df3d4198c79360b10411023c8f1da4b86b9616c2" => :x86_64_linux
  end

  depends_on "openssl@1.1"
  depends_on "s-lang"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-slrnpull=#{var}/spool/news/slrnpull",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "all", "slrnpull"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s, shell_output("#{bin}/slrn --show-config")
  end
end
