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

デフォルトでは`platex`・`dvipdfmx`・`epstopdf`が必要です。`--latex`・`--dvidriver`で別の処理系も指定できます。

このリポジトリのFormulaは、wtsnjp氏の[homebrew-tex2img](https://github.com/wtsnjp/homebrew-tex2img)を基にしています。Formulaのライセンスは[Public Domain](LICENSE)、配布するTeX2img本体のライセンスはGPL-2.0-or-laterです。
