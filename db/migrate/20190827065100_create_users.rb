class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email,           limit: 100
      t.string :nickname,        limit: 20
      t.string :code,            limit: 6
      t.string :password_digest

      t.timestamps
    end
  end
end
