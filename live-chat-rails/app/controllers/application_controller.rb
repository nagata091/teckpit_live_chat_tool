class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        include DeviseHackFakeSession # APIモードでセッションを可能にするため追加
end
