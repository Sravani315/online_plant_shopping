class CreateProducts < ActiveRecord::Migration[5.1]
  def up
    create_table :products do |t|
      t.string :name
      t.string :image
      t.integer :cost
      t.text :about_product
      t.text :benifits
      t.references :category, index: true
      t.references :product_type, index: true
      t.timestamps
    end
  end
  def down
    drop_table :products
  end
end
