require 'spec_helper'

describe "League pages" do

  subject { page }

  # Test league index page.
  describe "index" do
    before { visit leagues_path }

    # Assert that title and h1 content are present.
    it { should have_title("All leagues") }
    it { should have_content("All leagues") }

    # Assert that search query field and button are present.
    it { find_field('query') }
    it { find('#league_search').should have_button('Search') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:league) } }
      after(:all)  { League.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each league" do
        # There are only 20 leagues per page, so there should be 2 pages.
        League.paginate(page: 2).each do |league|
          expect(page).to have_selector('li', text: league.name)
        end
      end
    end
  end

  # Test league show page.
  describe "show" do

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