class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/1.0.4.tar.gz"
  sha256 "8f3d56b0cbc4b84436d8baf4c8346cd2ee7ffb257bba5ddd9892c41bf516edc4"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "1a4cf15eac5ab20085f401c827511eddd6075f2d4511f9b4a72c7388d587a91b" => :catalina
    sha256 "8f9f55abf13706344949050a7fb077e4394daef2556a09b03deef1481eef432f" => :mojave
    sha256 "a80e9b0bb93db5384993499150c28c883cc1f839e4e9fa7e933bf85067be1818" => :high_sierra
    sha256 "43d705373ba79db2aa725c1f903766aae5fbde000a044409dce1d3fe6e91ab89" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "console_bridge"
  depends_on "tinyxml"
  depends_on "urdfdom_headers"

  patch do
    # Fix for finding console_bridge 1.0
    url "https://github.com/ros/urdfdom/commit/6faba176d41cf39114785a3e029013f941ed5a0e.patch?full_index=1"
    sha256 "7aa3fdd462b47326bac6f8f94187be18459dcbad568cefb239625103d7b31239"
  end

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <urdf_parser/urdf_parser.h>
      int main() {
        std::string xml_string =
          "<robot name='testRobot'>"
          "  <link name='link_0'>  "
          "  </link>               "
          "</robot>                ";
        urdf::parseURDF(xml_string);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lurdfdom_world", "-std=c++11",
                    "-o", "test"
    system "./test"
  end
end
