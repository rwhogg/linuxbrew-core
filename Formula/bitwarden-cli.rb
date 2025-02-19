require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.13.1.tgz"
  sha256 "da58b260a4d517ed371ca28c3a3c4b44b8cdd57f186cbdf04d6ed28b10e6e721"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d7e2975a83f08bfb62624f6262791c9d41f68df4b145d52b5455226fbbbe40ad" => :catalina
    sha256 "9731c7b2a21aaf40ce860661c419ed317c5c4e41d7ffd8f4f756ba5083e86dd6" => :mojave
    sha256 "ff9a35a1b90c030fbcc82f8d59c964eda9ab5d7048fe6408c16d14071f56c718" => :high_sierra
    sha256 "63111e29a7e2e1940d0a86a82ef0768eb3cb05caf6b4fc5654743c799d5e034e" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
