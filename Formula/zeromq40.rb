class Zeromq40 < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "http://download.zeromq.org/zeromq-4.0.4.tar.gz"
  sha256 "1ef71d46e94f33e27dd5a1661ed626cd39be4d2d6967792a275040e34457d399"

  depends_on "pkg-config" => :build

  def install
    # Force compilation via gcc, clang wasn't exporting object symnbols.
    ENV['HOMEBREW_CC'] = ENV['CC'] = '/usr/bin/gcc'
    ENV['HOMEBREW_CXX'] = ENV['CXX'] = '/usr/bin/g++'

    args = ["--prefix=#{prefix}"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
