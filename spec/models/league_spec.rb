require 'spec_helper'

describe League do
  before do
    @league = League.new(
              name: "Example League",
              game_id: 1,
              commissioner_id: 1,
              started: false,
              current_season_number: 0,
              current_round: 0,
              info: "Example info",
              match_count: 5)
  end

  subject { @league }

  # League attributes checks.
  it { should respond_to(:name) }
  it { should respond_to(:game_id) }
  it { should respond_to(:commissioner_id) }
  it { should respond_to(:started) }
  it { should respond_to(:current_season_number) }
  it { should respond_to(:current_round) }
  it { should respond_to(:info) }
  it { should respond_to(:match_count) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:banner) }

  # League methods checks.
  it { should respond_to(:authenticate) }
  #it { should respond_to(:text_search) }
  it { should respond_to(:total_rounds) }
  it { should respond_to(:has_more_rounds_left_in_season?) }
  it { should respond_to(:matches_for_current_season) }
  it { should respond_to(:total_matches_played) }
  it { should respond_to(:generate_matches) }
  it { should respond_to(:swap_interleaved) }
  it { should respond_to(:swap) }
  it { should respond_to(:generate_single_elimination_tournament_matchups) }

  it { should be_valid }

  describe "when name is not present" do
    before { @league.name = " " }
    it { should_not be_valid }
  end

  describe "when game_id is not present" do
    before { @league.game_id = " " }
    it { should_not be_valid }
  end

  describe "when commissioner_id is not present" do
    before { @league.commissioner_id = " " }
    it { should_not be_valid }
  end

  describe "when started is not present" do
    before { @league.started = nil }
    it { should_not be_valid }
  end

  describe "when current_season_number is not present" do
    before { @league.current_season_number = " " }
    it { should_not be_valid }
  end

  describe "when current_round is not present" do
    before { @league.current_round = " " }
    it { should_not be_valid }
  end

  describe "when info is not present" do
    before { @league.info = " " }
    it { should_not be_valid }
  end

  describe "when match_count is not present" do
    before { @league.match_count = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @league.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when league name is already taken" do
    before do
      league_with_same_name = @league.dup
      league_with_same_name.save
    end

    it { should_not be_valid }
  end
end
