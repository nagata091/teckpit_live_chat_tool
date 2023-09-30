# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # すべてのオリジンからのリクエストを許可する。
    origins "*"

    # どのリソースへのHTTPリクエストを許可するかを指定する。
    resource "*",
    # どのヘッダー情報を許可するか
      headers: :any,
      # ブラウザからアクセスできるヘッダー情報の指定
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
      # どのHTTPリクエストメソッドを許可するか
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
