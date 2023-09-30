class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    # N+1問題を解消するために、includesメソッドを使って、他のテーブルのレコードも一度に取得する
    messages = Message.includes(:user, [likes: :user])
    messages_array = messages.map do |message|
      {
        id: message.id,
        user_id: message.user_id,
        name: message.user.name,
        content: message.content,
        email: message.user.email,
        created_at: message.created_at,
        likes: message.likes.map  {
          |like| {
            id: like.id,
            email: like.user.email,
          }
        }
      }
    end
    # messages_arrayをHTTPレスポンス(200)として返す
    render json: messages_array, status: :ok
  end
end
