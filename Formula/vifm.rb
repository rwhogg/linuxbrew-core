class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.11/vifm-osx-0.11.tar.bz2"
  sha256 "d6f829ed0228a8f534d63479fc988c2b4b95e6bc49d5db5e4fabff337fba3c4c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "d10ee88a7127716193fdfaad429e7c5c09f6a37c4b8b5ef78ba9cbb24229f4fa" => :catalina
    sha256 "fef03d352df4b86b94a5e529a6eb54fd4ffea6584fba2ab6e4bc8c6af2bae83d" => :mojave
    sha256 "9391d61f7b0cd098ce66789b3917e3b5d0e74104d309918980d94623c4cacac4" => :high_sierra
    sha256 "85cc08e9f7fb535da7239fc7ed28b71ed56fb68872d9c50015434df40c43ba32" => :x86_64_linux
  end

  uses_from_macos "groff" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    system "make", "check" if OS.mac?

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
