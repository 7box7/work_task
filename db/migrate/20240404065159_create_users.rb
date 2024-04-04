class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :fio
      t.string :email
      t.string :password
      t.boolean :teacher

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
