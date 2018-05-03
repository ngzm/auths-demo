# Auths Demo の Webサーバについて

### Arukas を使用する場合

Arukas コンテナサービスを利用する場合は、Arukas の エンドポイントを使用することにより リバースプロキシが自動的にセットアップされるので、特に自前で Webサーバを構築する必要はない。

また、Arukas エンドエンドポイントは、https によるTLS通信となるため、TLS証明書の取得や更新といった手間がかからないので、うれしい。


### 自前でWebコンテナを構築する場合

この設定をベースにWebサーバコンテナを構築すること