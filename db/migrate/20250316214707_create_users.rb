class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :auth0_id
      t.string :picture
      t.string :locale

      t.timestamps
    end
    add_index :users, :auth0_id
  end
end
