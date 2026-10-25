# homebrew-tex2img

macOS版[TeX2img](https://tex2img.tech/)のCLIをインストールするHomebrew Formulaです。

## インストール

```sh
brew tap doratex/tex2img
brew install doratex/tex2img/tex2img
```

GUIアプリはインストールしません。CLIの配布済みUniversal Binaryを使用します。

## 依存関係

次の周辺ツールはHomebrewでインストールします。

| Formula | 使用するコマンド |
| --- | --- |
| `ghostscript` | `gs` |
| `poppler` | `pdftops` |
| `mupdf-tools` | `mudraw` |

TeX Liveは依存関係に含めません。MacTeX等のTeX環境を別途用意し、その実行ファイルのディレクトリをPATHに追加してください。MacTeXの場合は次の設定です。

```sh
export PATH="/Library/TeX/texbin:$PATH"
```

既定では`platex`・`dvipdfmx`・`epstopdf`が必要です。`--latex`・`--dvidriver`で別の処理系も指定できます。TeX2img 3.0.3はPDF入力でもこれらの存在を確認します。

TeX2img本体の最低動作OSはmacOS 12 Montereyです。Homebrewおよび依存Formulaの対応OS・バイナリ提供範囲はそれぞれの条件に従います。

別のTeX2img.appが存在しても、`pdftops`・`mudraw`にはこのFormulaの依存パッケージを使います。`gs`もHomebrew版を優先し、必要なら`--gs /path/to/gs`で明示的に変更できます。

## 動作確認

```sh
tex2img --version
brew test doratex/tex2img/tex2img
```

FormulaのテストはTeX環境を使わず、PDFからEPS・SVGへの変換を検査します。TeX原稿からの変換は、利用するTeX環境でも確認してください。

### 検証記録（2026-10-25）

VirtualBuddy上のmacOS 15.6.1（arm64）、Homebrew 7.0.10で、空のHomebrew環境から導入して検証しました。使用した依存ツールはGhostscript 10.08.0、Poppler 26.10.0、MuPDF tools 1.28.5（Brotli 1.2.1）です。

- `brew install`・修正後の`brew reinstall`・`brew test --verbose`・`brew linkage --test`に成功。
- `brew style`・`brew audit --strict`に合格。
- PDFからEPS・SVG・PDF・PNG・JPEGへの変換に成功。EPSのGhostscriptでの描画、PDFのページ情報、SVGのXML構文も検査。
- TeX系コマンドは呼び出されたら失敗するスタブを指定し、これらの変換でTeX処理が発生しないことを確認。
- 実行ログでHomebrew版の`gs`・`pdftops`・`mudraw`の選択を確認。
- `install_symlink`がリンク先を版固定のCellarパスに解決する問題を修正。依存更新に追随する`opt`へのリンクを`brew test`でも検査。

TeX原稿のコンパイル、Intel実機、macOS 12実機はこのVM検証の対象外です。HomebrewがCommand Line Toolsの更新を推奨する警告は表示されましたが、上記の導入・検査はすべて完了しました。

## 更新時の作業

CLIのGitHub Releaseを公開後、`tex2img.rb`の`url`・`sha256`を更新し、インストールと変換テストを行います。

このリポジトリのFormulaは、wtsnjp氏の[homebrew-tex2img](https://github.com/wtsnjp/homebrew-tex2img)を基にしています。Formulaのライセンスは`LICENSE`、配布するTeX2img本体のライセンスはGPL-2.0-or-laterです。
