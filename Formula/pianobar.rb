class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2020.04.05.tar.bz2"
  sha256 "6c173b6b29ccc1f432e0013fb425e8f9cb4261539b58d344e0b2274963726480"
  license "MIT"
  revision 5
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "bb43c7eadad494186e61ce06e888bfeec4c6bd993717af1ea0a9d60bd6ab8173" => :catalina
    sha256 "085dabff36a1f1169f54240f79d055e967dc2c8fb3407b422cef4b2e05ee938d" => :mojave
    sha256 "9338d01743aaa72e9086056b43fa04e53f737d7e390fd04293ccfb0476ffc7ad" => :high_sierra
    sha256 "25c231c7eabda22476f80aa9ced86b9a2cead0af45dbe627179553f5a7f36e79" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if ENV["CI"]

    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
