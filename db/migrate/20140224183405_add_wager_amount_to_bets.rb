class AddWagerAmountToBets < ActiveRecord::Migration
  def change
    add_column :bets, :wager_amount, :integer
  end
end
