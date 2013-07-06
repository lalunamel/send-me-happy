class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :phone, :default => ""
      t.integer :message_frequency, :default => 1
      t.string :verification_token
      t.datetime :verification_token_created_at

      t.timestamps
    end
  end
end
