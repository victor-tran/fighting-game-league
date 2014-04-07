require 'spec_helper'

describe Tournament do
  before do
    @tournament = Tournament.new(
              name: "Example Tournament",
              league_id: 1,
              season_number: 1,
              participants: ["1", "2", "3", "4"],
              live_image_url: "img.com",
              full_challonge_url: "challonge.com",
              game_id: 1)
  end

  subject { @tournament }

  # Tournament attribute checks.
  it { should respond_to(:name) }
  it { should respond_to(:league) }
  it { should respond_to(:league_id) }
  it { should respond_to(:season_number) }
  it { should respond_to(:live_image_url) }
  it { should respond_to(:full_challonge_url) }
  it { should respond_to(:participants) }
  it { should respond_to(:winner) }
  it { should respond_to(:winner_id) }
  it { should respond_to(:matches) }
  it { should respond_to(:game_id) }

  it { should be_valid }

  describe "when name is too long" do
    before { @tournament.name = "a" * 61 }
    it { should_not be_valid }
  end
end
