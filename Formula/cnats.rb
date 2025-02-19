class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.3.0.tar.gz"
  sha256 "2251e3804f5c492f9b98834fea66b161f1a6f7e39a193636760b028171725022"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "874dae9b5751b247f322df936983238c37fb25e4907b57258a8cbdbec7863802" => :catalina
    sha256 "cdce55913e70d44003278835ead106710f3221593ac4d47ff525c5f29c510d1c" => :mojave
    sha256 "885c923403383be453e7d200eb085b1238636c9b96213064d36c2fa71b709a55" => :high_sierra
    sha256 "13f9dcf16a6b44a29c707ce05d13376cdb82c935c574b80955f8d9f1407c0336" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         ("-DNATS_PROTOBUF_LIBRARY=#{Formula["protobuf-c"].lib}/libprotobuf-c.so" unless OS.mac?),
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
