class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.13.tar.xz"
  sha256 "ada945ab8d519102bb632f197273b3326ded25b38c003b0cf3861d1d6d4a9bb9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "64ace78142e59a05032fc65e683c1a36d2c28e457be1f22718519ca37c1e90c2" => :catalina
    sha256 "6e529ebbebd56ef337ab4099d39d17adf2792d5d3c827d348fd1c23ac04fa7fe" => :mojave
    sha256 "63abd352182e42ae21a6c143db533446e1bc9c8fc6cfcf4c60a69f630558a189" => :high_sierra
    sha256 "2d23dc5c8fed26fa10c9dae2c191ae515be45cfbb5207cae15eef6941e0f1f92" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "libsecret"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-macosx-keyring
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
