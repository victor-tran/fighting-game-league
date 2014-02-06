class AddBioAndTaglineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :string
    add_column :users, :tagline, :string
  end
end
