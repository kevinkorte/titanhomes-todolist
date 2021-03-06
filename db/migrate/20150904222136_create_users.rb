class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :token
      t.string :refresh_token
      t.string :expires_at

      t.timestamps null: false
    end
  end
end
