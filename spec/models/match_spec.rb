require 'spec_helper'

describe Match do
  before do
    @match = Match.new(
              round_number: 1, 
              p1_id: 1, 
              p2_id: 2,
              season_number: 1,
              league_id: 1,
              p1_accepted: false,
              p2_accepted: false,
              game_id: 1)
  end

  subject { @match }

  # Match attributes checks.
  it { should respond_to(:round_number) }
  it { should respond_to(:p1_id) }
  it { should respond_to(:p2_id) }
  it { should respond_to(:p1_score) }
  it { should respond_to(:p2_score) }
  it { should respond_to(:season_number) }
  it { should respond_to(:league_id) }
  it { should respond_to(:p1_accepted) }
  it { should respond_to(:p2_accepted) }
  it { should respond_to(:game_id) }

  # Match method checks.
  it { should respond_to(:match_scores_are_at_match_count) }
  it { should respond_to(:convert_character_ids_to_strings) }
  it { should respond_to(:winner_id) }
  it { should respond_to(:pay_winning_betters) }
  it { should respond_to(:display_score) }
  it { should respond_to(:scores_not_set?) }

  # Check to see that subject match is valid.
  #it { should be_valid }
end
