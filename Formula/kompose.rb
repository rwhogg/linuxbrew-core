class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.22.0.tar.gz"
  sha256 "b12e866958da8bec9f5fcd936f99686967475643009692ccc52b875df581edc8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "34da28575e40dd6c1bb1fcb36e073aa7d8236f4d8c16a33876cdaa2bcd4f7af2" => :catalina
    sha256 "2f6bf388c3aa7d51a9151f39378911b7d1a6cd16505ada04eba05b7b65e7ec78" => :mojave
    sha256 "8f727cb8dce4e8f5090c856ef6725f000d3618d6129868a0057293e449f1c79a" => :high_sierra
    sha256 "8cd49588d70aac2e3e42bf53c3ce802fe47850a4d83bcd058f983a9c8e821247" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    output = Utils.safe_popen_read("#{bin}/kompose", "completion", "bash")
    (bash_completion/"kompose").write output

    output = Utils.safe_popen_read("#{bin}/kompose", "completion", "zsh")
    (zsh_completion/"_kompose").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
