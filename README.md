# アプリ仕様書
作者：翁 偉恆  
アプリ名：Restaurant Map  

## アプリケーション基本情報

> 対象端末、OS：iOS 13.3.1  
開発環境：xcode 11.3.1  
開発言語：swift 5.1  
使用しているAPI、SDK：ぐるなびレストランAPI
### コンセプト
  - 現在の人は何を食べるかという悩みがあり、決まったらまだどちらのレストランがいいかという悩みが出てくる。なので、食べに行きたいレストランが簡単に見つかる。
### こだわったポイント
  - 食べ物の種類、例えば：居酒屋とか、カレーとかの検索条件も検索できるようにしました。範囲内に同じ種類のレストランを表示され、写真や詳細内容を見て、選択が簡単になります。
### デザイン面こだわったポイント
  - ちょうどいいページングで必要な機能を載せる。SwipeGestureRecognizerのアニメでメインページにMapや検索機能、一覧リストを同時に表示できる。
### 該当プロジェクトのリポジトリ
  - //github url
  
## アプリケーション機能

### 機能概要
1. レストラン検索：ぐるなびレストランAPIを利用して、現在地周辺の飲食店を検索する。
2. レストラン情報取得：ぐるなびレストランAPIを利用して、レストランの詳細情報を取得する。
3. ユーザー現在地取得：locataionManagerを利用して、ユーザーの現在地をmapViewに表示される。
4. レストランの位置取得：CLGeocoderを利用して、レストランの位置を取得するとplacemarkで表示される。

### 画面概要
1. Map画面：
   - 検索機能：条件を指定してレストランを検索する。
   - 一覧機能：検索結果のレストランを表示する。
   - 中央揃え機能：ユーザーの現在地をマップの中央に揃える。
2. レストラン詳細画面：検索結果のレストランの詳細情報を表示される。

## その他
### アドバイスして欲しいポイント
  - APIの使い方はまだ未熟だと思うので、APIで受け取ったデータについて、どうすればベストかを教えていただきたいと思います。 
  - 今作成した機能だけではなく、レストランに対する評価と現在地からレストランまでの路線の表示とか、もっと便利にさせる機能を追加したいので、載せるべきだと思う機能を教えでいただきたいと思います。
### 自己評価
  - デザイン面：今回のUIデザインはまだ色々なところを深く考えていなかったので、アプリの流れが未熟だと思います。例えば、検索範囲を設定するときに、ユーザーの現在地中心から設定した300mとかの範囲を丸で囲んだ方がユーザーにとってはわかりやすいことです。
  - プログラミング：ページングの部分をちゃんと考えましたけらど、プログラミングはもっとわかりやすい、もっと簡単な書き方があるはずです。これから色々なタイプのアプリをチャレンジしながら、書き方を修正し、全般的に考える練習を頑張りに行きたいと思います。
  - 成長面：書類審査に書いてあり、Kitの種類とライブラリーの使いは一番難しかったところだと思います。私にとって、今回の課題はSwiftに対する知識が広がるようになりました。Alamofireや構造体などAPIの使い方がわかり、自分の成長をはっきり感じております。
