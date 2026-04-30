class CreateDagster < Formula
  desc "The create-dagster application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.13.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.3/create-dagster-aarch64-apple-darwin.tar.xz"
      sha256 "ce359d7f8b433e5fae864aa80fa5e38738be56e1b0206c45a252920036922fd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.3/create-dagster-x86_64-apple-darwin.tar.xz"
      sha256 "306a17ad7c00d266b132bd5b1896f7eb7c01cd0c19dbcfbdd81594827fd864a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.3/create-dagster-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a8571b30b55163d7b1ba661a3555cc0d911f510e8560f0f2e5d8c4844f8cd5a"
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
      bin.install "create-dagster"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "create-dagster"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "create-dagster"
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
