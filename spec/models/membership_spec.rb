require 'spec_helper'

describe Membership do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league) }
  let(:membership) { user.memberships.build(league_id: league.id) }

  subject { membership }

  it { should be_valid }

  describe "association methods" do
    it { should respond_to(:user) }
    it { should respond_to(:league) }
    its(:user) { should eq user }
    its(:league) { should eq league }
  end

  describe "when user id is not present" do
    before { membership.user_id = nil }
    it { should_not be_valid }
  end

  describe "when league id is not present" do
    before { membership.league_id = nil }
    it { should_not be_valid }
  end
end
