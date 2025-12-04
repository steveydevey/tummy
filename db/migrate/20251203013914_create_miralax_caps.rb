class CreateMiralaxCaps < ActiveRecord::Migration[8.1]
  def change
    create_table :miralax_caps do |t|
      t.datetime :occurred_at
      t.decimal :amount, precision: 3, scale: 1
      t.text :notes

      t.timestamps
    end
  end
end
