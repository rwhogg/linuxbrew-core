class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archiver"
  url "https://github.com/mholt/archiver/archive/v3.5.0.tar.gz"
  sha256 "8f2e3ad68553f6b58bf99e8635ff0953f62ff0a7804da7658954ffaa7d0aaa0a"
  license "MIT"
  head "https://github.com/mholt/archiver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a61d7f77c7e3a291af4afa1edc6a6059c3f48c4c9828303c805e51e69902caf0" => :catalina
    sha256 "eb27d3455b2ef6e30317f9be5d54e3c15196b8736209ebc5cc8ac95f3058d1ee" => :mojave
    sha256 "50d359a1201e04663c8a42b3736c11c9d0f046a814d3ec5af00d0326822474ff" => :high_sierra
    sha256 "be9f7c24425223b5362d9da0a092adedfebd31a061699c1c74afd9765b08843b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"arc", "cmd/arc/main.go"
  end

  test do
    output = shell_output("#{bin}/arc --help 2>&1")
    assert_match "Usage: arc {archive|unarchive", output

    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Moien!"

    system "#{bin}/arc", "archive", "test.zip",
           "test1", "test2", "test3"

    assert_predicate testpath/"test.zip", :exist?
    assert_match "application/zip",
                 shell_output("file -b --mime #{testpath}/test.zip")

    output = shell_output("#{bin}/arc ls test.zip")
    names = output.lines.map do |line|
      columns = line.split(/\s+/)
      File.basename(columns.last)
    end
    assert_match "test1 test2 test3", names.join(" ")
  end
end
