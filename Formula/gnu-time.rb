class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftp.gnu.org/gnu/time/time-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/time/time-1.9.tar.gz"
  sha256 "fbacf0c81e62429df3e33bda4cee38756604f18e01d977338e23306a3e3b521e"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "f4fc9d2c49b65130d04a476d4cd887b1e1033a7870df9805be28aba09be901f0" => :big_sur
    sha256 "9a1d1160f85f46b3022dc4d978dfafe6b3a02fc97446bc51f8b1ae4580b7c69a" => :catalina
    sha256 "dc007b95e2f9fb0df3380da55d3c9337529b1a4a3cd762972eb88512f567ea1c" => :mojave
    sha256 "ad5d776c38e43f16fad8976770eeaa18e40562c166fa65fdaa12af61981c7b90" => :high_sierra
    sha256 "d51ef948a5a87281175fef771cb28469cbdb3085e3c51ad325d780ff921cc013" => :sierra
    sha256 "413f9b0ff0050c2bdd9bd4cbbd581078e44f5f7aec43ac20958a89a1200d26fe" => :x86_64_linux
  end

  depends_on "ruby" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --info=#{info}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gtime" => "time" if OS.mac?
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      GNU "time" has been installed as "gtime".
      If you need to use it as "time", you can add a "gnubin" directory
      to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    if OS.mac?
      system bin/"gtime", "ruby", "--version"
      system opt_libexec/"gnubin/time", "ruby", "--version"
    end

    system bin/"time", "ruby", "--version" unless OS.mac?
  end
end
