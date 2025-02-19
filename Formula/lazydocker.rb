class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.10",
      revision: "ff0a53bfadfb1bfef5a0e3db023d57fed36fe4eb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "beb117f1a6967c87d619fb493ba6a4ec03b528ff55e568b8f740245e0679d1aa" => :catalina
    sha256 "0caabdbda1ce740c6a76952d40c8b8dc28acf936860d5f117113a9c3370ba84c" => :mojave
    sha256 "129c5552e5b09b98e170878c7713e52310daa8c3ab507200935415e4621ee1ce" => :high_sierra
    sha256 "8b90e220bae9ee3ca6bc79e68c354b7ff848c5d001749a7853a659d84e6990d8" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
