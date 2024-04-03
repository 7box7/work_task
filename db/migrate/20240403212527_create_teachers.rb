class CreateTeachers < ActiveRecord::Migration[7.1]
  def change
    create_table :teachers do |t|
      t.string :fio
      t.string :email
      t.string :password

      t.timestamps
    end
    add_index :teachers, :email, unique: true
  end
end
