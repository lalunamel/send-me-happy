class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone, :default => ""
      t.integer :message_frequency, :default => 1

      t.timestamps
    end
  end
end
