class Dg < Formula
  desc "The dg application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.10.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.15/dg-aarch64-apple-darwin.tar.xz"
      sha256 "610294a81046e6b271f94105a4a27a11c56524793b0d797865d4d37706cf39aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.15/dg-x86_64-apple-darwin.tar.xz"
      sha256 "c0f6ab9fff181b0722c9b876e241365a6437a1155134c0daaa1410d3636d7f6d"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.15/dg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2def060d9df13128d923499040d7a4680cec7222c2c2c9baf6434a7c40f6422"
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
