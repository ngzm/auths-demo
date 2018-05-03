# アプリ実行に必要な環境変数について

Auths Demo コンテナの実行にあたっては、以下の環境変数をコンテナ起動時に設定してください。

- SECRET_KEY_BASE: `rails secret` の値
- RP_GG_CLIENT_ID: Google認証用 Client ID
- RP_GG_CLIENT_SECRET: Google認証用 Client Secret
- RP_GG_REDIRECT_URI: Google認証用 Redirect URI 
- RP_FB_APP_ID: Facebook認証用 Application ID
- RP_FB_APP_SECRET: Facebook認証用 Application Secret
- RP_FB_REDIRECT_URI: Facebook認証用 Redirect URI
- RP_TW_CONSUMER_KEY: Twitter認証用Customer Key
- RP_TW_CONSUMER_SECRET: Twitter認証用Customer Secret
- RP_TW_CALLBACK_URL: Twitter認証用Callback URL
