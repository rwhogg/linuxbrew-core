class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
    tag:      "1.0.20",
    revision: "830d32a41449278cacb0bf17530618d47c43340b"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/WebAssembly/wabt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "910d30dea89023dadf308768eee1f8d186e88ff50210a5603c392e3dc33546b7" => :catalina
    sha256 "e9eba56a16e053365d515a6637a1b12217cf65c2c3f81988a0d80af8fc2f0094" => :mojave
    sha256 "77e89094c8a0d95abeb513f6ff3bbfcecab82ed4cc740b7be1445cee79eef6a0" => :high_sierra
    sha256 "1b8cf42144e66988a172727fd420c8eea4c69dcb2aa025aaac0a791fd78549b8" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
