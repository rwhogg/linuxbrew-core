class Yh < Formula
  desc "YAML syntax highlighter to bring colours where only jq could"
  homepage "https://github.com/andreazorzetto/yh"
  url "https://github.com/andreazorzetto/yh/archive/v0.4.0.tar.gz"
  sha256 "78ef799c500c00164ea05aacafc5c34dccc565e364285f05636c920c2c356d73"
  license "Apache-2.0"
  head "https://github.com/andreazorzetto/yh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a2425d399a63df18758dfabf9d50da2559fb489c32bfb4462d7437f64fc0817" => :catalina
    sha256 "69f1ab9c740906f04924c780cb512ea26fa0c51bdf66be85c71c4cbaa9dc6ca1" => :mojave
    sha256 "184eb9a41954f7a3d11f3065dfab42085a724c617ec635681e05784eeebe6329" => :high_sierra
    sha256 "bb931efbbdf0b82803769d855550c979a6a7406813c5da5035de3fe0f3e42489" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_equal "\e[91mfoo\e[0m: \e[33mbar\e[0m\n", pipe_output("#{bin}/yh", "foo: bar")
  end
end
