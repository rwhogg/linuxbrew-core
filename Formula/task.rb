class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.1.tar.gz"
  sha256 "d87bcee58106eb8a79b850e9abc153d98b79e00d50eade0d63917154984f2a15"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "2.6.0", shallow: false

  livecheck do
    url "https://taskwarrior.org/download/"
    regex(/href=.*?task[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "24c80011867aa34766864a4bbac071493fb45c93bd3e08b3e9979b3ba4780fa2" => :catalina
    sha256 "bba98b6bdfb3f79f1434229d8ade4b0622119320353da0eb8fec39809d66947d" => :mojave
    sha256 "6a651be957b736bef14633efedef011a81c49ee37178eae4d8ef863549d7c584" => :high_sierra
    sha256 "d1cb582ab9ee211ec154690634b5988f8058ead31000c74d5cdfa949d319d0ed" => :sierra
    sha256 "07aa2c19ae6d7a9a46b286bfc48fa970aa9a9e0237e034bbaab354dcfc4f6848" => :el_capitan
    sha256 "113fc7ce057c51ea14021006a4106c25d29e361e4b70113e33fb7a83e57ee8d1" => :yosemite
    sha256 "7888e42210edb6691ff57d056585536abd318d62b43a898bb98e286373519164" => :mavericks
    sha256 "8ef84bc6520fe829996effd80d992c4ea192fa5199e29603a0a4ca35ad2d1b1c" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gnutls"
  unless OS.mac?
    depends_on "util-linux" # for libuuid
    depends_on "linux-headers"
    depends_on "readline"
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system "#{bin}/task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end
