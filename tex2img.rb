class Tex2img < Formula
  desc "Compile TeX file to various formats of image"
  homepage "https://tex2img.tech/"

  url "https://github.com/doraTeX/TeX2img/releases/download/v.3.0.3/tex2imgcMac3.0.3.zip"
  sha256 "e9caa54d6dbf03738ed14d3e17966f73e4fec15ebbaecc03cbd7cdfd09b215b6"
  license "GPL-2.0-or-later"

  depends_on "ghostscript"
  depends_on :macos
  depends_on "mupdf-tools"
  depends_on "poppler"

  on_macos do
    depends_on macos: :monterey
  end

  def install
    libexec.install "tex2img"

    # 古いGUIアプリの同梱ツールより、Homebrewの依存ツールを優先する。
    # install_symlinkはoptを版固定のCellarパスへ解決するため使用しない。
    # 依存パッケージの更新・旧版削除後もopt経由で新しい版を参照する。
    (libexec/"pdftops").mkpath
    (libexec/"mupdf").mkpath
    (libexec/"pdftops/pdftops").make_symlink formula_opt_bin("poppler")/"pdftops"
    (libexec/"mupdf/mudraw").make_symlink formula_opt_bin("mupdf-tools")/"mudraw"

    # TeX環境のPATHを引き継ぎつつ、GhostscriptはHomebrew版を使う。
    (bin/"tex2img").write_env_script libexec/"tex2img",
      PATH: "#{formula_opt_bin("ghostscript")}:$PATH"
  end

  def caveats
    <<~MSG
      A TeX distribution must be installed separately (for example, MacTeX).
      This formula does not install TeX Live.
      Add your TeX distribution's binary directory to PATH. For MacTeX:
        export PATH="/Library/TeX/texbin:$PATH"

      The defaults require platex, dvipdfmx and epstopdf. Use --latex and
      --dvidriver to select other TeX tools. Ghostscript, pdftops and mudraw
      are provided by this formula's Homebrew dependencies.
    MSG
  end

  test do
    { "pdftops/pdftops" => "poppler", "mupdf/mudraw" => "mupdf-tools" }.each do |tool, dependency|
      link = libexec/tool
      assert_equal formula_opt_bin(dependency)/link.basename, link.readlink.expand_path(link.dirname)
    end
    assert_match "tex2img Ver.#{version}", shell_output("#{bin}/tex2img --version")

    # PDF入力でもTeX系ツールの存在確認があるため、未使用の拒否スタブを置く。
    # 呼び出されれば失敗させ、TeXを使わない変換経路であることも検査する。
    (testpath/"unused-tex-tool").write "#!/bin/sh\nexit 1\n"
    (testpath/"unused-tex-tool").chmod 0755
    (testpath/"epstopdf").make_symlink testpath/"unused-tex-tool"
    ENV.prepend_path "PATH", testpath

    %w[eps svg].each do |extension|
      output = testpath/"output.#{extension}"
      system bin/"tex2img", "--latex", "unused-tex-tool",
             "--dvidriver", "unused-tex-tool", "--with-text", "--no-preview",
             test_fixtures("test.pdf"), output
      assert_path_exists output
      assert_match((extension == "eps") ? "%!PS-Adobe" : "<svg", output.binread)
    end
  end
end
