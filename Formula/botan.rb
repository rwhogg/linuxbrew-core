class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.17.1.tar.xz"
  sha256 "741358b3f1638ed7d9b2f59b4e344aa46f4966b15958b5434c0ac1580df0c0c1"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "4cde1c6011c08b45a5575e4312bc9198b7efaaca5adbd5cc36f842df6319c5ab" => :catalina
    sha256 "a5a84df8d31f299f38bebd2701ad9458eaa3fdd1dca30a22bcaca7ef58beca3d" => :mojave
    sha256 "6d9f9c0f4b83a2e4b3462a16d9de3fe349eb544abf3f86d86b1f625d3260403c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cc=#{OS.mac? ? ENV.compiler : "gcc"}
      --os=#{OS.mac? ? "darwin" : "linux"}
      --os=darwin
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --with-python-versions=3.9
    ]

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
