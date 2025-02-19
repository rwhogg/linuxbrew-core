class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.15.tar.gz"
  sha256 "c4656a8fb97b0488bda3bfadeb36c3f9d64d9a20095d81f93d59db7d24e34e2b"
  license "MIT"

  livecheck do
    url "https://github.com/deplinenoise/tundra/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "782e5cffac2df8f04a2f86a994a0e6f3dbc5d6c0627119fa2e7e8e9c048b58aa" => :catalina
    sha256 "0fb994652330be64e5375a8a21924c2b6f65505685dfaac7d1dcdf4f26f54016" => :mojave
    sha256 "065e6fc51e912585a278de152b5b149c1d86fc6dd3843d5add5b0a0230c6b118" => :high_sierra
    sha256 "1c6e1c7ca50d187c7673b3a9b4b51c5aa5d4bf7be96ce77dd4b79a6e783f1c12" => :x86_64_linux
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

  def install
    (buildpath/"unittest/googletest").install resource("gtest")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS
    if OS.mac?
      (testpath/"tundra.lua").write <<~'EOS'
        Build {
          Units = function()
            local test = Program {
              Name = "test",
              Sources = { "test.c" },
            }
            Default(test)
          end,
          Configs = {
            {
              Name = "macosx-clang",
              DefaultOnHost = "macosx",
              Tools = { "clang-osx" },
            },
          },
        }
      EOS
    else
      (testpath/"tundra.lua").write <<~'EOS'
        Build {
          Units = function()
            local test = Program {
              Name = "test",
              Sources = { "test.c" },
            }
            Default(test)
          end,
          Configs = {
            {
              Name = "linux-gcc",
              DefaultOnHost = "linux",
              Tools = { "gcc" },
            },
          },
        }
      EOS
    end
    system bin/"tundra2"
    if OS.mac?
      system "./t2-output/macosx-clang-debug-default/test"
    else
      system "./t2-output/linux-gcc-debug-default/test"
    end
  end
end
