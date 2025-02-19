class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    tag:      "v0.34.0",
    revision: "9abd6a60fab90aed3e2196e17b228fe1045d758f"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "46305f2330fc44b896d093ea784fff0dba2e8d7287b4d6f56e55ad45760c59df" => :catalina
    sha256 "079056d8d962c9a16227d0c7e0b66e5b930c285b91b7f59d623153e9205bffa5" => :mojave
    sha256 "b29318bb00155fa79aed26ff3d9b48dd7bec475a42e549c971b536de9159119a" => :high_sierra
    sha256 "a0425af80cdcbaf6499600776fd809f504e70d3720b436e7b57a7a9c71a49f3b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{Time.now.iso8601}
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/"wtfutil"
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~EOS
      wtf:
        colors:
          background: "red"
          border:
            focusable: "darkslateblue"
            focused: "orange"
            normal: "gray"
          checked: "gray"
          highlight:
            fore: "black"
            back: "green"
          text: "white"
          title: "white"
        grid:
          # How _wide_ the columns are, in terminal characters. In this case we have
          # six columns, each of which are 35 characters wide
          columns: [35, 35, 35, 35, 35, 35]

          # How _high_ the rows are, in terminal lines. In this case we have five rows
          # that support ten line of text, one of three lines, and one of four
          rows: [10, 10, 10, 10, 10, 3, 4]
        navigation:
          shortcuts: true
        openFileUtil: "open"
        sigils:
          checkbox:
            checked: "x"
            unchecked: " "
          paging:
            normal: "*"
            selected: "_"
        term: "xterm-256color"
    EOS

    begin
      pid = fork do
        exec "#{bin}/wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end
