class CreateLessonParts < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_parts do |t|
      t.integer :number
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end

    add_index :lesson_parts, [:lesson_id, :number], unique: true

    # Sadly ActiveRecord does not know how to add a foreign key to an existing
    # SQLite table.
    reversible do |dir|
      dir.up do
        execute <<-EOSQL
          ALTER TABLE "students"
          ADD COLUMN "lesson_part_id" integer
            DEFAULT NULL
            REFERENCES "lesson_parts" ("id")
              ON DELETE SET NULL
        EOSQL
      end

      dir.down do
        remove_column :students, :lesson_part_id
      end
    end
  end
end
