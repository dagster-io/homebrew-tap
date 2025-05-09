class Dg < Formula
  desc "The dg application"
  homepage "https://github.com/dagster-io/dagster"
  version "1.10.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.14/dg-aarch64-apple-darwin.tar.xz"
      sha256 "a46a99a57aca2858470cba24b19d9bd1619c52e29268dbed5153fc6aa7ffd40b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.14/dg-x86_64-apple-darwin.tar.xz"
      sha256 "ec22568696dd75ffe8666ff530f55c58d057b991f90cccaa07731be7bed720e2"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/dagster-io/dagster/releases/download/1.10.14/dg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e4f5c7858c515e780fe5bbde2b43ccb7b9fd24769682f2b233b6624560a98717"
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
