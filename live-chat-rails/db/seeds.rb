3.times do |number|
  number = number + 1
  Message.create(
    content: "#{number}番目のメッセージです！",
    user_id: User.first.id,
  )
  puts "#{number}番目のメッセージを作成しました"
end

puts "メッセージの作成が完了しました"