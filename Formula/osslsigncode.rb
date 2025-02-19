class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.1.tar.gz"
  sha256 "1d142f4e0b9d490d6d7bc495dc57b8c322895b0e6ec474d04d5f6910d61e5476"
  license "GPL-3.0"

  bottle do
    sha256 "964162e471801ec6335e1cb88fa7d71145a09acd7507f71d049af1edc6375f9e" => :catalina
    sha256 "6ce5ae481bea9b92e4baaf795dfbdaf6cb29d574189978012f641857ffe39113" => :mojave
    sha256 "2a70933b296047d0042df4e1c1361cab8d588ff70c36ef44f63ac01105ce32f6" => :high_sierra
    sha256 "98541a57f790363fbd5efa26dbeb7a7b485a0109da5aa4683788c5a40479fd44" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libgsf"
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    system "./autogen.sh"
    system "./configure", "--with-gsf", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version", 255)
  end
end
