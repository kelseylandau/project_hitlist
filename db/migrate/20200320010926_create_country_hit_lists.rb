class CreateCountryHitLists < ActiveRecord::Migration[6.0]
  def change
    create_table :country_hit_lists do |t|
      t.integer :user_id
      t.string :country

      t.timestamps
    end
  end
end
