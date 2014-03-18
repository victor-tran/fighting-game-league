require 'spec_helper'

describe Bet do
  it { should respond_to(:wager_amount) }
  it { should respond_to(:match) }
  it { should respond_to(:better) }
  it { should respond_to(:favorite) }
end
