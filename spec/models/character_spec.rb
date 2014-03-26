require 'spec_helper'

describe Character do
  
  before do
    @character = Character.new(name: "Ryu", game_id: 1)
  end

  subject { @character }

  it { should respond_to(:name) }
  it { should respond_to(:game) }
  it { should respond_to(:game_id) }

  it { should be_valid }
end
