class AddPasswordProtectedToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :password_protected, :boolean
  end
end
