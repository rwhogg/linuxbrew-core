class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.51.3.tar.gz"
  sha256 "0c287d17f52729440b2bdc28edf4d19b2d5ea5869983d78e780d501c5866914b"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  livecheck do
    url "https://github.com/bcpierce00/unison/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:v\d+)?)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cea7b5893ed3a5f39b599b98f244e8d6146cb7700fb19883667e61f9a4390b4c" => :catalina
    sha256 "3c49a17f14f649b88c1188e43a6f82b05e233b79ba567b1ca702c147ba1e5950" => :mojave
    sha256 "1cdf5ae09de5f39426ef22f01284d7b4a1a5a792812b5fa14f76ba188b33ed55" => :high_sierra
    sha256 "33c31f3e17ba8ea40a8c994bb5f37fc1f8fc5790c265f9604a29bb76ab1be2dd" => :x86_64_linux
  end

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
