class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.3.tar.gz"
  sha256 "bd6e740fb78cd3be4f92eb50359242a4e028c126143a320b6bf3f8ca717b7983"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "dac0a326cfff5070dd3c7fc6148859c6030bbefe253fa5ca9214ba61d80f8ee2" => :catalina
    sha256 "4058b540d3e20f3b37b3ef412bede3cf562aa2f5d8d50029f07ae5e579b70dd1" => :mojave
    sha256 "237a4ac97ad834d7f821183e71f29861d78a60dfa723e0eddb233ef85147df3a" => :high_sierra
    sha256 "35074160fcc0069362b267df0b81a116da5308b833fd3b5a82fb7c1fe80c0c35" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
