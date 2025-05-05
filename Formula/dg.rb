class Dg < Formula
  include Language::Python::Virtualenv
  desc "The official command line utility for Dagster."
  homepage "https://dagster.io/"
  version "0.26.13"
  license "Apache-2.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dagster-io/homebrew-tap/releases/download/v0.26.13/dg-macos-aarch64"
      sha256 "8594814bb35f3da53ffb40f79258ea7c6f42ffa6a7cee35322d02338032b0e53"
      def install
        bin.install "dg-macos-aarch64" => "dg"
      end
    else
      url "https://github.com/dagster-io/homebrew-tap/releases/download/v0.26.13/dg-macos-x64"
      sha256 "421e20ff58b931a862c29dcdf5d5c1a7f5e1b367a0bf969ee86fec53ad5fda1c"
      def install
        bin.install "dg-macos-x64" => "dg"
      end
    end
  end

  if OS.linux?
    url "https://github.com/dagster-io/homebrew-tap/releases/download/v0.26.13/dg-linux-x86_64"
    sha256 "ee0a30ebac2cd4403cd8c70d1a677c33e1dda8c828df869c3e283338689ad7fa"
    def install
      bin.install "dg-linux-x86_64" => "dg"
    end
  end
end
