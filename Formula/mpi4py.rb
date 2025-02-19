class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.3.tar.gz"
  sha256 "012d716c8b9ed1e513fcc4b18e5af16a8791f51e6d1716baccf988ad355c5a1f"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    sha256 "c6163dd690053dc5adcca25c63c54c5feb34d46248685e3d448ef673e907de36" => :catalina
    sha256 "e3bec47030124ee25c7d8d0bc31f24f6c317e81da4878e008ae8bb4cb26fb017" => :mojave
    sha256 "3c73ed25e9e29e5232bfe258147ebe87dd78ae5d295d4de6a1ec4f93475635a6" => :high_sierra
    sha256 "0e21df60d261097e377d1a30a08234d3931dabd064f9a7e005bfe24735a8e295" => :x86_64_linux
  end

  depends_on "cython" => :build
  depends_on "open-mpi"
  depends_on "python@3.9"

  def install
    system "#{Formula["python@3.9"].opt_bin}/python3",
           *Language::Python.setup_install_args(libexec)

    system Formula["python@3.9"].bin/"python3", "setup.py",
      "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3",
           "-c", "import mpi4py"
    system Formula["python@3.9"].opt_bin/"python3",
           "-c", "import mpi4py.MPI"
    system Formula["python@3.9"].opt_bin/"python3",
           "-c", "import mpi4py.futures"

    # Somehow our Azure CI only has two CPU cores available.
    cpu_cores = (ENV["CI"] ? 2 : 4).to_s

    if Process.uid.zero?
      ENV["OMPI_ALLOW_RUN_AS_ROOT_CONFIRM"] = "1"
      ENV["OMPI_ALLOW_RUN_AS_ROOT"] = "1"
    end

    system "mpiexec", "-n", cpu_cores, "#{Formula["python@3.9"].opt_bin}/python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", cpu_cores, "#{Formula["python@3.9"].opt_bin}/python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest",
           "-l", "10", "-n", "1024"
  end
end
