class CreateDagster < Formula
  desc "The create-dagster application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.13.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.24/create-dagster-aarch64-apple-darwin.tar.xz"
      sha256 "5de4e3f2f783ff94458dc84fd65de5013e1ff290ddc7282c3d7f9b98524d1bca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.24/create-dagster-x86_64-apple-darwin.tar.xz"
      sha256 "0bf59616c9f79939629c41ce3118f87f32dba0ad911ecdaa14fbda24cae57f17"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.24/create-dagster-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9ddb36c8d648a376aa8cb36628bb6523e8f22030920e3aa0120f4c045d793d08"
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
