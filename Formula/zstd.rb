class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.5.tar.gz"
  sha256 "734d1f565c42f691f8420c8d06783ad818060fc390dee43ae0a89f86d0a4f8c2"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "4143146aa691738893d19f6dc7de4ae983dbbf7023717094df8ff2d36cb839b5" => :big_sur
    sha256 "2375c206a934090c4ba53362d038e4e191d8dd09eec734e8e72106089aa24e9d" => :catalina
    sha256 "86b04bfd318315486d772b29d30b361e734a74269ae48805eeb3eae1d562b984" => :mojave
    sha256 "61de5a45183f4d029c66024d645ad44b0a625d58f9f583b47af42346a7c90fe5" => :high_sierra
    sha256 "3b6354ada22830f32dd0ed5a6c0cc6f1e1c8de50833db6004c58874533495df7" => :x86_64_linux
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    # Build parallel version
    system "make", "-C", "contrib/pzstd", "googletest"
    system "make", "-C", "contrib/pzstd", "PREFIX=#{prefix}"
    bin.install "contrib/pzstd/pzstd"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
