class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :beginDate
      t.string :endDate
      t.integer :priority
      t.string :description
      t.integer :status

      t.timestamps null: false
    end
  end
end
