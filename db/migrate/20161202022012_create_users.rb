class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :facebook_id
      t.string :zipcode
      t.integer :preference

      t.timestamps null: false
    end
  end
end
