/*
	Webcam Browser
	@author Kenichi Maehashi
 */

package("com.kenichimaehashi", {
	WebcamBrowser: function(config) {
		this.config = config;
		this._isLoggedIn = false; // webcam にログインしたかどうか

		// 処理を開始する
		this.begin = function() {
			this.resetWindowSize();
			this.refreshImage();
			this.beginAutoRefreshImage();
		};

		// ウィンドウのサイズを設定する
		this.resetWindowSize = function() {
			switch (config.windowSize) {
				case 0:
					// 画像のサイズ + ウィンドウボーダーなどのサイズ = ウィンドウのサイズ
					var margin_width = 20; // ウィンドウのボーダー (Windows 7)
					var margin_height = 38; // ウィンドウのボーダーとタイトルバー (Windows 7)
					window.resizeTo(config.width + margin_width, config.height + margin_height);
					break;
				case 1:
					// 画面の表示可能領域に最大化し、ウィンドウの位置を左上に合わせる
					window.resizeTo(screen.availWidth, screen.availHeight);
					window.moveTo(0, 0);
					break;
			}
		};

		// ウィンドウのサイズを切り替える
		this.toggleWindowSize = function() {
			var newWindowSize = 0;
			switch (config.windowSize) {
				case 0:
					newWindowSize = 1;
					break;
				case 1:
					newWindowSize = 0;
					break;
			}
			config.windowSize = newWindowSize;
			this.resetWindowSize();
		};

		// 画像を最新のものに差し替える
		this.refreshImage = function() {
			// 画像を表示する img 要素
			var img = document.getElementById(config.canvas);

			// 画像が読み込まれれば、webcam へのログインに成功したものとみなす
			var _this = this;
			img.onload = function () {
				_this._isLoggedIn = true;
			};

			// 画像をクリックするとウィンドウサイズをトグルできるようにする
			img.onclick = function() {
				_this.toggleWindowSize();
			};

			// 画像を再取得する際、キャッシュにある画像を使用しないように時間を付加する
			img.src = "http://" + config.address + "/SnapshotJPEG?" +
				"Resolution=" + config.width + "x" + config.height + "&" +
				"Quality=" + config.quality + "&" +
				"Time=" + ((new Date()).getTime());
		};

		// 画像の自動アップデートを開始する
		this.beginAutoRefreshImage = function() {
			// 認証通過前に次のリクエストが送信されると認証ダイアログが複数回表示されて
			// しまうため、初回のログインに成功するまでは自動アップデートしない

			var _this = this;
			if (this._isLoggedIn) {
				// ログイン済みであれば refreshInterval おきに refreshImage する
				window.setInterval(function() {_this.refreshImage();}, config.refreshInterval);
			} else {
				// ログインしていなければ、ログインしたかどうかを 500 ms おきに確認する
				window.setTimeout(function() {_this.beginAutoRefreshImage();}, 500);
			}
		};
	}
});

// ちょっとしたお遊びなので気にしないように :-)
function package(name, objects) {
	var names = name.split(".");
	for (var i = 0; i < names.length; i++) {
		var pkg = names.slice(0, i + 1).join(".");
		eval("if (typeof " + pkg + " == 'undefined') {" + pkg + " = {};}");
	}
	eval("var o = " + name);
	for (var obj in objects) {
        	o[obj] = objects[obj];
	}
}
