class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.6.0.tar.gz"
  sha256 "6496b43c933d2f93ff6be80f5029d37e9576a5d5eacb90900e6b28c90405037f"
  license "MIT"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4a26eb7603d38d0f67db4edbde56334fce2024c1c78fd5f49a7b8b69ba48683" => :catalina
    sha256 "f095caaf1f01dd0611afcdfc77252dc2f21a3d89f8e41210e4d00307b835eb2d" => :mojave
    sha256 "308d597802afebc412f38df92dda2b98cef91845bb0e9c8e27d1bd2d38ee9d56" => :high_sierra
    sha256 "654f13a821746761963bdda5fee4a508c5fd87365ee4d9f7973c1bea71483f56" => :x86_64_linux
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", because: "both install `mmd` binaries"
  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "discount", because: "both install `markdown` binaries"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "multimarkdown"
    end

    bin.install Dir["scripts/*"].reject { |f| f.end_with?(".bat") }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
