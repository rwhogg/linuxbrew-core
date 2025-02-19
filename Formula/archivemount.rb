class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://www.cybernoia.de/software/archivemount.html"
  url "https://www.cybernoia.de/software/archivemount/archivemount-0.9.1.tar.gz"
  sha256 "c529b981cacb19541b48ddafdafb2ede47a40fcaf16c677c1e2cd198b159c5b3"

  deprecate! because: "requires FUSE"

  livecheck do
    url :homepage
    regex(/href=.*?archivemount[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "68c3994948be590e8ee5e9a9de00182162135a76b0a5dd780c7d8b067a480062" => :catalina
    sha256 "439cdd8d7c962cf9a5144e20206ddaeaabc15c1752c58acd059e31976e254f6a" => :mojave
    sha256 "428113b60673b6bb8be9467587f1d82bf4c9447c7f0bbdea47749bed3ec86798" => :high_sierra
    sha256 "ee2773fc8e07405e24007dcb9351f89e455f7533eea3d2b878c67af5473a3006" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  if OS.mac?
    depends_on :osxfuse
  else
    depends_on "libfuse"
  end

  def install
    ENV.append_to_cflags "-I/usr/local/include/osxfuse"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
