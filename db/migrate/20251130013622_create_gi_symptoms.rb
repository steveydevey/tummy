class CreateGiSymptoms < ActiveRecord::Migration[8.1]
  def change
    create_table :gi_symptoms do |t|
      t.string :symptom_type
      t.datetime :occurred_at
      t.integer :severity
      t.text :notes

      t.timestamps
    end
  end
end
