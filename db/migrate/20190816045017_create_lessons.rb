class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.integer :number, index: { unique: true }

      t.timestamps
    end
  end
end
