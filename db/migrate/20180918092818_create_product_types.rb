class CreateProductTypes < ActiveRecord::Migration[5.1]
  def up
    create_table :product_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :product_types
  end
end
