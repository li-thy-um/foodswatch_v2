require 'spec_helper'

describe Like do
  let(:like) { FactoryGirl.create(:like) }

  it { should respond_to(:user) }
  it { should respond_to(:micropost) }
end
