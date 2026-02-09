class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :category, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :kind, null: false, default: 0
      t.text :description
      t.date :occurred_at, null: false

      t.timestamps
    end
    add_index :transactions, :occurred_at
  end
end
