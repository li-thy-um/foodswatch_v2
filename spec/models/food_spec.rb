require 'spec_helper'

describe Food do

  before { @food = FactoryGirl.create(:food) }

  subject { @food }

  it { should be_valid }

  describe "when name is longer than 15 chars" do
    before { @food.name = "s" * 16 }
    it { should_not be_valid }
  end

end
