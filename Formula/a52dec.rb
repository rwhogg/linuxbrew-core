class A52dec < Formula
  desc "Library for decoding ATSC A/52 streams (AKA 'AC-3')"
  homepage "https://liba52.sourceforge.io/"
  url "https://liba52.sourceforge.io/files/a52dec-0.7.4.tar.gz"
  sha256 "a21d724ab3b3933330194353687df82c475b5dfb997513eef4c25de6c865ec33"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://liba52.sourceforge.io/downloads.html"
    strategy :page_match
    regex(/href=.*?a52dec[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "a40e7384a64c5d4e22209088af424eeb4a9de3eba4c5451f95a2a1b6732969f6" => :catalina
    sha256 "5186add25fb7aae66c80139b56ea81fb3aff1f87e74354c2cebe022374532286" => :mojave
    sha256 "c7485fae127d02a6628186b821d72fc40bc82019ae30ddee0abfacf2b63701dc" => :high_sierra
    sha256 "150123fdf33421b85f4625d73c015a660300db698a82fd0165475fe8e7081d0b" => :sierra
    sha256 "2feac8f578fd1aa43385ce8714b059c90f4aaf3a0401d8ba825939e8e8ab7b1b" => :el_capitan
    sha256 "cfe0ddcf275b03d9ad0c626174962601ae18d3f77fa35266228425b818ce4a7f" => :yosemite
    sha256 "cb40eed81300fa32069bac07244cf7f56363cc04af853ddb75bada292e8d9912" => :mavericks
    sha256 "1ee3d6cdaaa77669cd10c41de60d933187d83fd792e605eee6e8942201cdc6c2" => :x86_64_linux # glibc 2.19
  end

  def install
    on_linux do
      # Fix error ld: imdct.lo: relocation R_X86_64_32 against `.bss' can not be
      # used when making a shared object; recompile with -fPIC
      ENV.append_to_cflags "-fPIC"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system "#{bin}/a52dec", "-o", "null", "test"
  end
end
