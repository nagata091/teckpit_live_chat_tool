class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|

      # referencesで記述すると、user_idというカラムが作成され、
      # 存在しないユーザーIDは追加できないようになる。
      t.references :user
      t.string :content

      t.timestamps
    end
  end
end
