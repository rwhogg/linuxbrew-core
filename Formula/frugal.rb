class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.5.tar.gz"
  sha256 "8fff38f7ff2317614dce124a788f76a809eb0beceff90a31c1f021cf1e66c6d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0acdc08e59fe3be4262274de5a59cd56cc8e5408e86cbfb09de08ca298871d1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4cc0a9dabaec0d9c8410d4232f6ca7f7794fc998f2734416c82b17160a16ef8"
    sha256 cellar: :any_skip_relocation, catalina:      "a4cc0a9dabaec0d9c8410d4232f6ca7f7794fc998f2734416c82b17160a16ef8"
    sha256 cellar: :any_skip_relocation, mojave:        "a4cc0a9dabaec0d9c8410d4232f6ca7f7794fc998f2734416c82b17160a16ef8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
