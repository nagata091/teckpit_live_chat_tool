class Like < ApplicationRecord

  # 関連付け
  belongs_to :user
  belongs_to :message
end
