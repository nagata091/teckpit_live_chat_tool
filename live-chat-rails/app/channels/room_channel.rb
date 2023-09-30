class RoomChannel < ApplicationCable::Channel
  # ブラウザ側のコネクションが確立すると呼び出されるメソッド
  # stream_fromメソッドで、どのチャンネルとコネクションを確率するかを指定する
  def subscribed
    stream_from "room_channel"
  end

  # コネクションが切断される時に呼び出されるメソッド
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # ユーザーがチャットにメッセージを打ち込み、そのメッセージデータを受信するたびに呼び出されるメソッド
  # dataの例
  # data = {
  #   message: "こんにちは",
  #   email: "test@example,com",
  # }
  def receive(data)
    user = User.find_by(email: data["email"])
    
    # 小規模のアプリなのでここでcreateしているが、コントローラーやモデルに処理を移すのもあり
    if message = Message.create(content: data["message"], user_id: user.id)
      ActionCable.server.broadcast  'room_channel',
                                    {
                                      message: data["message"],
                                      name: user.name,
                                      created_at: message.created_at,
                                    }
    end
  end
end
