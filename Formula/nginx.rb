class Nginx < Formula
  desc "HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server"
  homepage "https://nginx.org/"
  # Use "mainline" releases only (odd minor version number), not "stable"
  # See https://www.nginx.com/blog/nginx-1-12-1-13-released/ for why
  url "https://nginx.org/download/nginx-1.19.4.tar.gz"
  sha256 "61df546927905a0d624f9396bb7a8bc7ca7fd26522ce9714d56a78b73284000e"
  license "BSD-2-Clause"
  head "https://hg.nginx.org/nginx/", using: :hg

  livecheck do
    url :homepage
    regex(%r{nginx[._-]v?(\d+(?:\.\d+)+)</a>\nmainline version has been released}i)
  end

  bottle do
    sha256 "6bac29f2d1e2db6e1f8d41ad601cd436035fa1fca9bd207f3ce2414fed67dcf4" => :big_sur
    sha256 "ba06157261435dbc64d363398480866855f7cb2ad0296138fcce864abf570aaf" => :catalina
    sha256 "7e99a7583a9ca640e06d9d6a608ec1c0d5ab6374485ba631c7d556dcd5e1a7f8" => :mojave
    sha256 "8fd77f248cf8a66c88334cde60b862d50d73d101987e080598477d6da301abfe" => :high_sierra
    sha256 "399ddd7e8baff6fb077b0d6f83a5d7d28b6f16a9f3f565cbb8f29576b6b3cc04" => :x86_64_linux
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "xz" => :build # for the tar command in the install step

  def install
    # keep clean copy of source for compiling dynamic modules e.g. passenger
    (pkgshare/"src").mkpath
    system "tar", "-cJf",
           (pkgshare/"src/src.tar.xz"),
           *("--options" if OS.mac?),
           *("compression-level=9" if OS.mac?), "."

    # Changes default port to 8080
    inreplace "conf/nginx.conf" do |s|
      s.gsub! "listen       80;", "listen       8080;"
      s.gsub! "    #}\n\n}", "    #}\n    include servers/*;\n}"
    end

    openssl = Formula["openssl@1.1"]
    pcre = Formula["pcre"]

    cc_opt = "-I#{pcre.opt_include} -I#{openssl.opt_include}"
    ld_opt = "-L#{pcre.opt_lib} -L#{openssl.opt_lib}"

    args = %W[
      --prefix=#{prefix}
      --sbin-path=#{bin}/nginx
      --with-cc-opt=#{cc_opt}
      --with-ld-opt=#{ld_opt}
      --conf-path=#{etc}/nginx/nginx.conf
      --pid-path=#{var}/run/nginx.pid
      --lock-path=#{var}/run/nginx.lock
      --http-client-body-temp-path=#{var}/run/nginx/client_body_temp
      --http-proxy-temp-path=#{var}/run/nginx/proxy_temp
      --http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp
      --http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp
      --http-scgi-temp-path=#{var}/run/nginx/scgi_temp
      --http-log-path=#{var}/log/nginx/access.log
      --error-log-path=#{var}/log/nginx/error.log
      --with-compat
      --with-debug
      --with-http_addition_module
      --with-http_auth_request_module
      --with-http_dav_module
      --with-http_degradation_module
      --with-http_flv_module
      --with-http_gunzip_module
      --with-http_gzip_static_module
      --with-http_mp4_module
      --with-http_random_index_module
      --with-http_realip_module
      --with-http_secure_link_module
      --with-http_slice_module
      --with-http_ssl_module
      --with-http_stub_status_module
      --with-http_sub_module
      --with-http_v2_module
      --with-ipv6
      --with-mail
      --with-mail_ssl_module
      --with-pcre
      --with-pcre-jit
      --with-stream
      --with-stream_realip_module
      --with-stream_ssl_module
      --with-stream_ssl_preread_module
    ]

    (pkgshare/"src/configure_args.txt").write args.join("\n")

    if build.head?
      system "./auto/configure", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    if build.head?
      man8.install "docs/man/nginx.8"
    else
      man8.install "man/nginx.8"
    end
  end

  def post_install
    (etc/"nginx/servers").mkpath
    (var/"run/nginx").mkpath

    # nginx's docroot is #{prefix}/html, this isn't useful, so we symlink it
    # to #{HOMEBREW_PREFIX}/var/www. The reason we symlink instead of patching
    # is so the user can redirect it easily to something else if they choose.
    html = prefix/"html"
    dst = var/"www"

    if dst.exist?
      html.rmtree
      dst.mkpath
    else
      dst.dirname.mkpath
      html.rename(dst)
    end

    prefix.install_symlink dst => "html"

    # for most of this formula's life the binary has been placed in sbin
    # and Homebrew used to suggest the user copy the plist for nginx to their
    # ~/Library/LaunchAgents directory. So we need to have a symlink there
    # for such cases
    sbin.install_symlink bin/"nginx" if rack.subdirs.any? { |d| d.join("sbin").directory? }
  end

  def caveats
    <<~EOS
      Docroot is: #{var}/www

      The default port has been set in #{etc}/nginx/nginx.conf to 8080 so that
      nginx can run without sudo.

      nginx will load all files in #{etc}/nginx/servers/.
    EOS
  end

  plist_options manual: "nginx"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <false/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/nginx</string>
              <string>-g</string>
              <string>daemon off;</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"nginx.conf").write <<~EOS
      worker_processes 4;
      error_log #{testpath}/error.log;
      pid #{testpath}/nginx.pid;

      events {
        worker_connections 1024;
      }

      http {
        client_body_temp_path #{testpath}/client_body_temp;
        fastcgi_temp_path #{testpath}/fastcgi_temp;
        proxy_temp_path #{testpath}/proxy_temp;
        scgi_temp_path #{testpath}/scgi_temp;
        uwsgi_temp_path #{testpath}/uwsgi_temp;

        server {
          listen 8080;
          root #{testpath};
          access_log #{testpath}/access.log;
          error_log #{testpath}/error.log;
        }
      }
    EOS
    system bin/"nginx", "-t", "-c", testpath/"nginx.conf"
  end
end
