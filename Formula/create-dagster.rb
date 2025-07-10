class CreateDagster < Formula
  desc "The create-dagster application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.11.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.11.2/create-dagster-aarch64-apple-darwin.tar.xz"
      sha256 "0475183f84e14f8c7eebee4169027cdceb8ffbf7ae6e8f0302e0fbdcc5ef5693"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.11.2/create-dagster-x86_64-apple-darwin.tar.xz"
      sha256 "9035df8446d03389c6b4643a4ab586960483a4b7f6b96e638ced3ac70db4b745"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.11.2/create-dagster-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "75f6c657968936a28b25e25e73cad5d1080e4065d06e1db159ad15ce652834d8"
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
