require 'spec_helper'

describe "League pages" do

  subject { page }

  # Test league index page.
  describe "index" do
    it "is a pending example"
  end

  # Test league show page.
  describe "show" do
    let(:user) { FactoryGirl.create(:user) }
    let(:league) { FactoryGirl.create(:league, commissioner_id: user.id) }
    before do
      
      visit league_path(league)
    end

    it { should have_title(league.name) }
    it { should have_title(league.game.name) }
    it { should have_title(league.info) }
    it { should have_title(league.match_count) }

    # Test everything that should be on a league's show page regardless of
    # being a signed in user or not.
    describe "page" do
      it "is a pending example"
    end

    # Test signed in-user landing on show page.
    describe "user signed in" do
      it "is a pending example"

      describe "as a commissioner" do
        it "is a pending example"
      end

      describe "as a normal league member" do
        it "is a pending example"
      end
    end
  end

end