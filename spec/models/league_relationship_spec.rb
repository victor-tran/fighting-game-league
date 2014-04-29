require 'spec_helper'

describe LeagueRelationship do
  let(:league) { FactoryGirl.create(:league) }
  let(:follower) { FactoryGirl.create(:user) }
  let(:relationship) { league.relationships.build(follower_id: follower.id) }

  subject { relationship }

  it { should be_valid }

  describe "follower methods" do
    it { should respond_to(:league) }
    it { should respond_to(:follower) }
    its(:league) { should eq league }
    its(:follower) { should eq follower }
  end

  describe "when followed id is not present" do
    before { relationship.league_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end
