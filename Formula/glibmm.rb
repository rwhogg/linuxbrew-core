class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.64/glibmm-2.64.2.tar.xz"
  sha256 "a75282e58d556d9b2bb44262b6f5fb76c824ac46a25a06f527108bec86b8d4ec"
  license "LGPL-2.1"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "aaff9671885e0337aeeee7bf5c3b18a87c88fd79323bbce01f79c648a0531c87" => :big_sur
    sha256 "8b39f15570f8ec9281554ec8db93e4011ad2e13a1248047c18c7f8570a548d53" => :catalina
    sha256 "316a5f0f84491a62cf1c48a12cd4f8d9b7f7de9aa8092f72256f5114aa8730d3" => :mojave
    sha256 "7d224a2283e08715a1f7f286fcdc3e1c5cc277101bb3e2cc4bce488ec776cc02" => :high_sierra
    sha256 "0c4cc228b4fdcb78f2f96726c0413c8fa7c22d0bed11e346fa9f3b1d62e212c0" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    ENV.cxx11

    # see https://bugzilla.gnome.org/show_bug.cgi?id=781947
    # Note that desktopappinfo.h is not installed on Linux
    # if these changes are made.
    if OS.mac?
      inreplace "gio/giomm/Makefile.in" do |s|
        s.gsub! "OS_COCOA_TRUE", "OS_COCOA_TEMP"
        s.gsub! "OS_COCOA_FALSE", "OS_COCOA_TRUE"
        s.gsub! "OS_COCOA_TEMP", "OS_COCOA_FALSE"
      end
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
