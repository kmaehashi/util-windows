【このファイルについて】
	nVIDIA の API を叩いて、ディスプレイのデュアル / クローンを切り替えます。
	Windows Vista では nVIDIA 標準のコマンドライン API が使えないため、このようなコマンドを作りました。
	開発環境は Windows Vista Enterprise Service Pack 1 (64-bit) および Visual Studio 2008 です。
	ただし、32-bit でしかコンパイルしたことがありません（WoW によって 64-bit でも問題なく動作します）。
	Cygwin の gcc も使えますが、Cygwin 依存のバイナリになります。
	ただし gdb が使えるという利点はあるので、開発中には便利です。

【文法】
	nvswitch <ディスプレイ番号> <表示モード>
	オプションを付けずに起動した場合、またはオプションが間違っている場合はヘルプが出ます。
	詳細はそちらを見てください。
	なお、表示モードの standard と normal は同義です。

【コンパイルの方法】
	まず、NVIDIA API (32-bit) のスタティックライブラリとヘッダファイルを以下の URL から入手します。
		http://developer.nVIDIA.com/object/nvapi.html
	このファイル、nvapi.h、nvapi.lib を同じディレクトリに置きます。
	Visual Studio 2008 コマンド プロンプトを開き、そのディレクトリに移動します。
	あとは、
		cl nvswitch.c nvapi.lib
	と打つと、nvswitch.exe が生成されます。

【NVIDIA API について】
	バイナリ自体は September 2008 の NVAPI を用いてコンパイルしています。

【Windows XP での動作】
	動作しません（とリファレンスに書いてある）。nVIDIA 標準のコマンドライン API を使ってください。例えば、
		rundll32.exe NvCpl.dll,dtcfg setview 1 clone
	など。少々古いですが、リファレンスは
		http://http.download.nvidia.com/developer/SDK/Individual_Samples/DEMOS/common/src/NvCpl/docs/NVControlPanel_API.pdf
	にあるようです。

