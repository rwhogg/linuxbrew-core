class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://s.saltstack.com/community/"
  url "https://files.pythonhosted.org/packages/48/79/66352fd2351bd494ee6ee502693c8b54f77a8afc4d96c5b20b1f1306b2b5/salt-3002.1.tar.gz"
  sha256 "4c536a0577c9fe5052fa80c25c93527af00b50086aba0f5320e46dcd1dc3e75e"
  license "Apache-2.0"
  head "https://github.com/saltstack/salt.git", branch: "develop", shallow: false

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "c5e7477c701d1fca58ed75b843fb6177fb655f002d66c78acd49517d0c470176" => :catalina
    sha256 "9a1068ea05113e25f15eb79303178d75d18c0ffa7d00ccd3ca97a804bb073ffc" => :mojave
    sha256 "931b163609b7e915f2e29c589cd83c3d8894651b9c4a656db2d4892e5928281c" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "zeromq"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gmp"
    depends_on "pcre"
  end

  # Saltstack's Git filesystem backend depends on pygit2 which depends on libgit2
  # pygit2 must be the same version as libgit2 - mismatched versions are incompatible

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7b/db/1d037ccd626d05a7a47a1b81ea73775614af83c2b3e53d86a0bb41d8d799/Jinja2-2.10.3.tar.gz"
    sha256 "9fe95f19286cfefaa917656583d020be14e7859c6b0252588391e47db34527de"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/74/18/3beedd4ac48b52d1a4d12f2a8c5cf0ae342ce974859fba838cbbc1580249/M2Crypto-0.35.2.tar.gz"
    sha256 "4c6ad45ffb88670c590233683074f2440d96aaccb05b831371869fc387cbd127"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  # Homebrew installs optional dependencies: M2Crypto, pygit2

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/cb/ae/380e33d621ae301770358eb11a896a34c34f30db188847a561e8e39ee866/cffi-1.14.3.tar.gz"
    sha256 "f92f789e4f9241cd262ad7a555ca2c648a98178a953af117ef7fad46aa1d5591"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/ff/df/84609ed874b5e6fcd3061a517bf4b6e4d0301f553baf9fa37bef2b509797/M2Crypto-0.36.0.tar.gz"
    sha256 "1542c18e3ee5c01db5031d0b594677536963e3f54ecdf5315aeecb3a595b4dc1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/20/02/25077cf7ac6599e0e6bd2c6836e7c7360244d2d7224d54e51218dbe00711/pygit2-1.3.0.tar.gz"
    sha256 "0be93f6a8d7cbf0cc79ae2f0afb1993fc055fc0018c27e2bd01ba143e51d4452"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

    # Fix building of M2Crypto on High Sierra https://github.com/Homebrew/homebrew-core/pull/45895
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    # Do not install PyObjC since it causes broken linkage
    # https://github.com/Homebrew/homebrew-core/pull/52835#issuecomment-617502578
    File.write(buildpath/"pkg/osx/req_pyobjc.txt", "")

    # Fix build with Python 3.9 by updating cffi
    # https://github.com/saltstack/salt/issues/58809
    inreplace "requirements/static/pkg/py3.9/darwin.txt", "cffi==1.12.2", "cffi>=1.14.3"

    venv = virtualenv_create(libexec, Formula["python@3.9"].bin/"python3.9")
    venv.pip_install resources

    system libexec/"bin/pip", "install", "-v", "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "salt"
    venv.pip_install_and_link buildpath

    prefix.install libexec/"share" # man pages
    (etc/"saltstack").install (buildpath/"conf").children # sample config files
  end

  def caveats
    <<~EOS
      Sample configuration files have been placed in #{etc}/saltstack.
      Saltstack will not use these by default.

      Homebrew's installation does not include PyObjC.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salt --version")
  end
end
