require File.dirname(__FILE__)+'/spec_helper'

describe Project do
  describe :rateable_range do
    it "should have a range" do
      Project.rateable_range.should_not be_nil
    end
  end
end