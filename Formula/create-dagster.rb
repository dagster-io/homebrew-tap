class CreateDagster < Formula
  desc "The create-dagster application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.13.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.2/create-dagster-aarch64-apple-darwin.tar.xz"
      sha256 "f58d0cbe32acf98d25b98456bb8381e256705e776fe4e4bdc1bdaa81abd6f065"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.2/create-dagster-x86_64-apple-darwin.tar.xz"
      sha256 "622152341a041bb642a4f8bf7d8689c02592687e716e54b302d3430ab13836da"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.13.2/create-dagster-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "98b051c12f9e3490034f2d766ea8e0142efba0ce072c5705601dcda36390d068"
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
