class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.1.5.tar.gz"
  sha256 "a63ecb93182134ba4293fd5f22d6e08ca417caafa244afaa751cbfddf6415b13"
  license "BSD-3-Clause"
  revision OS.mac? ? 1 : 2
  head "https://github.com/google/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20b93e20891d48912ffbfbdf3ef470f7305684df2381ef93056a11cedd95c65f" => :catalina
    sha256 "ec700c89a4f1794170b4466f5a0a100b6eafee7cb0a794e55ea53de18114a1d3" => :mojave
    sha256 "9b54153b09683b8fa40160588792385e04f6be56ba355c5a530a2209b9f0526d" => :high_sierra
    sha256 "96604a8a62a29b5a5bda15a7b1181d76c0b32f3c5006c9530d8e1f50c548fe0f" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "dc-build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"

      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "libdouble-conversion.a"
    end

    unless OS.mac?
      # Move lib64/* to lib/ on Linuxbrew
      lib64 = Pathname.new "#{lib}64"
      if lib64.directory?
        mkdir_p lib
        mv lib64, lib
        rmdir lib64
      end
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <double-conversion/bignum.h>
      #include <stdio.h>
      int main() {
          char buf[20] = {0};
          double_conversion::Bignum bn;
          bn.AssignUInt64(0x1234567890abcdef);
          bn.ToHexString(buf, sizeof buf);
          printf("%s", buf);
          return 0;
      }
    EOS
    system ENV.cc, "test.cc", "-L#{lib}", "-ldouble-conversion", "-o", "test"
    assert_equal "1234567890ABCDEF", `./test`
  end
end
