class CreateDagster < Formula
  desc "The create-dagster application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.13.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.23/create-dagster-aarch64-apple-darwin.tar.xz"
      sha256 "85be0bac493deca59d02cb131c6d9d62075dcd61ecab2dad04ef0ac9f69fb5ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.23/create-dagster-x86_64-apple-darwin.tar.xz"
      sha256 "dba9eeb2e372651b5f3a521b244a1f9bc9ff7057bb867d1635f90b79d50edc14"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.23/create-dagster-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dd76361585073d7f780ff91f83e5838668ed702e2c47bbc5228ae5747399d4cf"
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
