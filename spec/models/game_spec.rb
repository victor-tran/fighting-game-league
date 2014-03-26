require 'spec_helper'

describe Game do

  before do
    @game = Game.new(name: "USF4", logo: "jaja.jpg")
  end

  subject { @game }

  it { should respond_to(:name) }
  it { should respond_to(:logo) }
  it { should respond_to(:characters) }

  it { should be_valid }
end
