require 'spec_helper'

describe Bet do

  before do
    @bet = Bet.new(
              match_id: 1, 
              better_id: 1, 
              favorite_id: 2,
              wager_amount: 1)
  end

  subject { @bet }

  it { should respond_to(:match) }
  it { should respond_to(:match_id) }
  it { should respond_to(:better) }
  it { should respond_to(:better_id) }
  it { should respond_to(:favorite) }
  it { should respond_to(:favorite_id) }
  it { should respond_to(:wager_amount) }

  it { should be_valid }
end
