class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    tag:      "v3.5.1",
    revision: "9bf2a36a8deb659d70c3e5675e197af539aad675"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2db1845a0356b6b97f3b59b0fd21264c42b3cc3a2b1a4a9bcd792d26f5594141" => :catalina
    sha256 "b10d423fe179460c1a20da0af629869d848295c8c8d4eb73fbaa12ac389daeaa" => :mojave
    sha256 "20ff81067cd2d40abeb0356f2da97acb75dfec00326416ce99600efe58296369" => :high_sierra
    sha256 "e6b727562114272ff168b647527a2e25470384cad02ba0dab1465adb209a28ed" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      "-trimpath", "-o", bin/"helmsman", "cmd/helmsman/main.go"
    prefix.install_metafiles
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
