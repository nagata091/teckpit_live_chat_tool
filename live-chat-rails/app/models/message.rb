class Message < ApplicationRecord
  # 関連付け
  belongs_to :user
  has_many :likes

  # バリデーション
  validates :content, presence: true
end
