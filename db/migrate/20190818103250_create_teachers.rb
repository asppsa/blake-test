class CreateTeachers < ActiveRecord::Migration[5.2]
  def change
    create_table :teachers do |t|
      t.string :name, null: false

      t.timestamps
    end

    # Sadly ActiveRecord does not know how to add a foreign key to an existing
    # SQLite table.
    reversible do |dir|
      dir.up do
        execute <<-EOSQL
          ALTER TABLE "students"
          ADD COLUMN "teacher_id" integer
            DEFAULT NULL
            REFERENCES "teachers" ("id")
              ON DELETE SET NULL
        EOSQL
      end

      dir.down do
        remove_column :students, :teacher_id
      end
    end
  end
end
