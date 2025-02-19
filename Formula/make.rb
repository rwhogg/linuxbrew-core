class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.3.tar.lz"
  mirror "https://ftpmirror.gnu.org/make/make-4.3.tar.lz"
  sha256 "de1a441c4edf952521db30bfca80baae86a0ff1acd0a00402999344f04c45e82"
  license "GPL-3.0-only"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 "2019ba646e4471d42e09c28a0992c59dd82e292bf8275b0b3bfcce3220ef9c1b" => :big_sur
    sha256 "39fc5ebff5ff708c2e3eea597b9f2eb79b910a122d30c3ac9bb93ebe313f030c" => :catalina
    sha256 "0c0a08eef68bcd78b0345f5f57a6efffcc7be877bcb3b803f39ac8916b882477" => :mojave
    sha256 "429177235322c3209e1657bea36364cd84222075b636939f6ed93a1cd04aeb21" => :high_sierra
    sha256 "25cd50df4aeaca83d76d545b8b6b3b180a9af28a19c279463bf22d1d648462b6" => :x86_64_linux
  end

  conflicts_with "remake", because: "both install texinfo files for make"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gmake" =>"make"
      (libexec/"gnuman/man1").install_symlink man1/"gmake.1" => "make.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      GNU "make" has been installed as "gmake".
      If you need to use it as "make", you can add a "gnubin" directory
      to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    (testpath/"Makefile").write <<~EOS
      default:
      \t@echo Homebrew
    EOS
    if OS.mac?
      assert_equal "Homebrew\n", shell_output("#{bin}/gmake")
      assert_equal "Homebrew\n", shell_output("#{opt_libexec}/gnubin/make")
    else
      assert_equal "Homebrew\n", shell_output("#{bin}/make")
    end
  end
end
