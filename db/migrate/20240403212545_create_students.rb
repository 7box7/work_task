class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :fio
      t.string :email
      t.string :password

      t.timestamps
    end
    add_index :students, :email, unique: true
  end
end
