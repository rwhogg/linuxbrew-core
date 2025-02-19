class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.56.0.tar.gz"
  sha256 "2f0a6273a2971df62b783cbdae787c306f59250d9d52ad466242152406d1d006"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d30b95db8de59f1bdeb25cc5dce634d7b33a4e27f67092e349dc2e468f2c4eb" => :catalina
    sha256 "9aedf4a705ae17ffacf901735f14c9d831b4684588e8cca20e56f34f17407b82" => :mojave
    sha256 "0290db070ad96f26e51a57346a0ea6118d5cfb877eadcda206674bed30dba1fc" => :high_sierra
    sha256 "754b46606d358064e2295f25425260f53790b1a0ffc8937c39509cd4afd4fd47" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "./scripts/build.sh", OS.mac? ? "OSX" : "linux"
    bin.install "dbdeployer-#{version}.#{OS.mac? ? "osx" : "linux"}" => "dbdeployer"
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
