require 'spec_helper'

describe "User pages" do

  subject { page }

  # Test user index page.
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.alias)
        end
      end
    end
  end

  # Test registering a new user.
  describe "register" do
    before { visit register_path }

    # Test registration page title.
    it { should have_title('Sign up') }

    let(:submit) { "Create account" }

    # Test registering with no information inputted.
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        # Test title after signing up with invalid information.
        it { should have_title('Sign up') }

        # Test error messages.
        it { should have_content('error') }
      end
    end

    # Test registering with valid information.
    describe "with valid information" do
      before do
        fill_in "First name",   with: "Testie"
        fill_in "Last name",    with: "Cull"
        fill_in "Alias",        with: "Rone"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        # user@example.com should have been created in the DB.
        let(:user) { User.find_by(email: 'user@example.com') }

        # Test title.
        it { should have_title("Fighting Game League") }

        # Testing flash notice after successful signin.
        it { should have_selector('div.alert.alert-success',
                            text: 'Welcome to the Fighting Game League!') }

        # Check to see that correct navbar links are there.
        it { should have_link('Settings') }
        it { should have_link('Sign out') }

        # Test signout.
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end
  end

  # Test user edit page.
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    # Test initial visit.
    describe "page" do
      it { should have_title("Edit user") }
      it { should have_content("Update your profile") }
    end

    # Test submitting with no information.
    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    # Test submitting with valid information.
    describe "with valid information" do
      let(:new_first_name)  { "New" }
      let(:new_last_name)   { "Name" }
      let(:new_alias)       { "Alias" }
      let(:new_email)       { "new@example.com" }
      before do
        fill_in "First name",       with: new_first_name
        fill_in "Last name",        with: new_last_name
        fill_in "Alias",            with: new_alias
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.first_name).to  eq new_first_name }
      specify { expect(user.reload.last_name).to   eq new_last_name }
      specify { expect(user.reload.alias).to       eq new_alias }
      specify { expect(user.reload.email).to       eq new_email }
    end
  end

end