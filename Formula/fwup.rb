class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.8.2/fwup-1.8.2.tar.gz"
  sha256 "84c17348dc7271d871e6adbe12edb0622ed9248a7f828efb3d9f6064d73195aa"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "74af7cfb5ed18a50e9fbd56c4167f7bc3c5ebeec69cc8c7660b80e20020739b8" => :catalina
    sha256 "4e33b196f1f611272cf007528088ac485a19bf0fadbb32b1c4d3b8180540bec6" => :mojave
    sha256 "77a1aa5b48fca51379c19531764e776bd795d4ffbfd61dd2aafbc50bdc33219c" => :high_sierra
    sha256 "5f39088176a553db4141dec54426f096e989a69f32950577be97336f1f283604" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
