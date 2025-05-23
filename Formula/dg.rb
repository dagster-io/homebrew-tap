class Dg < Formula
  desc "The dg application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.10.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.17/dg-aarch64-apple-darwin.tar.xz"
      sha256 "f73ccd020a5bfc24ad9c22f32bd50bc17da782ec916363ea3092a375a9562d69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.17/dg-x86_64-apple-darwin.tar.xz"
      sha256 "42ec2c712189cdd228db87cfb4875577e8b5eec7202be33d985a69f06cf5c683"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.17/dg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d38518d24490c2f6df056491f51bd40c51fe1b6c733b578402f3261d6c6058d"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dg"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dg"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dg"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
