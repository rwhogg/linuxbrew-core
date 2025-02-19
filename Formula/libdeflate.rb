class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.7.tar.gz"
  sha256 "a5e6a0a9ab69f40f0f59332106532ca76918977a974e7004977a9498e3f11350"
  license "MIT"

  bottle do
    cellar :any
    sha256 "e270c74afc8fbd5171ba5b5e9cecd2c429e4934a6db9b0da1830b0a2a4298b8f" => :catalina
    sha256 "02fb406299f342554d4c236955b6c0cf0e917afb76ed7c8bfe622b03fd6a2b55" => :mojave
    sha256 "1c16f650b82c5e7b910b98249e635353d9beee3a3a0cd4f0c841b0d8d19e19c6" => :high_sierra
    sha256 "a95dd72a6636853ef9a343ffc5f0c268b871be19309b7b2f278ddff3ec70bc77" => :x86_64_linux
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", File.read(testpath/"foo")
  end
end
