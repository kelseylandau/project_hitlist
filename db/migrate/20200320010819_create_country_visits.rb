class CreateCountryVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :country_visits do |t|
      t.string :country
      t.integer :user_id

      t.timestamps
    end
  end
end
