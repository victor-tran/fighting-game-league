class AddInfoToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :info, :string
  end
end
