class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2020/sqlite-src-3330000.zip"
  version "3.33.0"
  sha256 "90bf7604a5aa26deece551af7a665fd4ce3d854ea809899c0e4bb19a69d609b8"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f19d9c0de62635d0bf72503ac50034b6ac7e35435dfb472ee26f7d7312687c92" => :catalina
    sha256 "b15a0707f6f59fe6ce472d0d7ae6ebd023087e86a24f5fdc176add7c7729c37a" => :mojave
    sha256 "bde4f49fa6c7ff36ce787f26638625e9f88b2735148ffe4f57e9b2aee286d516" => :high_sierra
    sha256 "55259bbd9fa1a68c0974d18d5a250111744104c7d7118197609804256dd60d56" => :x86_64_linux
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlite = OS.mac? ? "/usr/bin/sqlite3" : Formula["sqlite"].bin/"sqlite3"
    sqlpath.write "create table test (name text);"
    system "#{sqlite} #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
