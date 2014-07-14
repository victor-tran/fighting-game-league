require 'spec_helper'

describe LeagueRelationship do
  let(:league) { FactoryGirl.create(:league) }
  let(:follower) { FactoryGirl.create(:user) }
  let(:league_relationship) { league.relationships.build(follower_id: follower.id) }

  subject { league_relationship }

  it { should be_valid }

=begin
  describe "follower methods" do
    it { should respond_to(:league) }
    it { should respond_to(:follower) }
    its(:league) { should eq league }
    its(:follower) { should eq follower }
  end

  describe "when followed id is not present" do
    before { league_relationship.league_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { league_relationship.follower_id = nil }
    it { should_not be_valid }
  end
=end

end
