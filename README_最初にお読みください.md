# キャラブロック App Store 登録用一式（2026-10-11）

元ZIPに入っていたゲーム処理（index.html）を変更せず、**ビルドのための設定とアイコン**を追加しました。

## このパッケージの内容
- `Resources/index.html` : ゲーム本体。ネット接続不要。
- `Sources/CharaBlock/*.swift` : ゲームのiOSラッパー。
- `Sources/CharaBlock/Info.plist` : 表示名、縦画面、プライバシー関連設定。
- `Resources/Assets.xcassets/AppIcon.appiconset/` : ストア/ホーム画面用アイコン。
- `project.yml` : XcodeGenで生成するiOSプロジェクトの設定。
- `codemagic.yaml` : iOS署名・IPAビルド・TestFlightアップロード。
- `.github/workflows/ios-check.yml` : GitHub ActionsのiOSコンパイル検査。
- `PRIVACY.md` : プライバシーポリシー。
- `AppStore_登録文章.txt` : アプリ紹介文、審査メモ。

## ① GitHubに新規プロジェクトを用意
- リポジトリ名を `charablock` として新規作成。既存のアプリを壊さないよう、既存リポジトリを使い回さない。
- リポジトリを **Public** とすれば `PRIVACY.md` を外部から読めます。
- ZIPを解凍し、フォルダ `CharaBlock_AppStore_Ready` **の中身**をすべてコミット。ZIPそのものだけをアップロードしない。
- 隠しフォルダ `.github` も含める。`main` ブランチで作業。

## ② GitHub Actions検査
- 「キャラブロック iOS 動作検査」を実行またはpush時の自動実行結果を確認。
- グリーンになれば、無署名のiOSシミュレーター用コンパイルは成功。

## ③ Codemagic
- 新規レポジトリ `shu39a-lang/charablock` をCodemagicの**既存のApple連携があるチーム**に新規アプリとして追加。
- `codemagic.yaml` を使用、workflow `charablock-ios` を選択。
- 新しいBundle ID `com.shu39a.charablock` に合うApp Storeプロビジョニングプロファイルを作成・登録。
- Apple DeveloperのApp IDとApp Store Connectの新しいアプリのバンドルIDを一致させる。
- 既存連携名 `codemagic7` を参照する構成です。別チームへ追加した場合はキー名が違う可能性があります。
- ビルド番号はCodemagicの `$PROJECT_BUILD_NUMBER + 100` を使う方式です。
- 署名済みIPAを生成できた場合にTestFlightへ送ります。自動でApp Storeの審査に提出はしません。

## ④ App Store Connect
- 新規Appを作成、名前「キャラブロック」、Bundle ID `com.shu39a.charablock`、SKUは任意の固有文字列（例 CHARABLOCK-IOS-001）。
- アプリ情報を `AppStore_登録文章.txt` から入力。
- プライバシーポリシーURLはPublicで公開した `PRIVACY.md` のURLを利用できます。
- iPhoneから**実際にアプリを操作した画面**のスクリーンショットを撮影して登録（本ZIPに公式審査用スクリーンショットは含まれていません）。
- TestFlightで動作を確認してからiOS 1.0の審査に提出。

## 現在の検証状況
- `index.html` はChromeのモバイル画面でスタート・落下・表示とJavaScript例外なしを確認。
- Swiftコードは元のファイルを使用。Xcodeの実機ビルドや署名、TestFlightへの送信は未実行です。GitHub ActionsとCodemagicで確認してください。
- プライバシー分類/年齢区分/暗号化は最終的にAppleの質問票に正確に回答してください。
