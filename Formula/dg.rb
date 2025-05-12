class Dg < Formula
  desc "The dg application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.10.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.14/dg-aarch64-apple-darwin.tar.xz"
      sha256 "a7e6661e04315dde42bdb03e0e1498a5fca7afe392e2b53e4563afebe6f5fbea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.14/dg-x86_64-apple-darwin.tar.xz"
      sha256 "f37bd4fb5164aad5ef462bf096953331c19217b3d826d1c2854f0df3cb4efa26"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.14/dg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e302ffdd390d39ba59e3d9bb914d9b0843ccd36f6383aefe5f45f88bc02e336f"
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
