require 'spec_helper'

describe Like do
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { user.posts.create!(action: 'test') }
  let(:like) { post.likes.build(user_id: user.id) }

  subject { like }

  it { should be_valid }

  it { should respond_to(:user) }
  it { should respond_to(:post) }
  its(:user) { should eq user }
  its(:post) { should eq post }
end
