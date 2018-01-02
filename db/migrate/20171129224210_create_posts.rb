class CreatePosts < ActiveRecord::Migration[5.1]
   def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :owner
      t.timestamps
    end
    
    create_table :users do |t|
      t.string :name
      t.string :password
    end
  end
end
