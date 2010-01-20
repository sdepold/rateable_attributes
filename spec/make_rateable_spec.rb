require File.dirname(__FILE__)+'/spec_helper'

describe Project do
  describe :rateable_range do
    it "should have a range" do
      Project.rateable_range.should_not be_nil
    end
    
    it "should have the attributes, specified in model" do
      Project.rateables.should == [:usability, :performance, :functionality]
    end
  end
  
  describe :is_valid_rateable_attribute? do
    before :all do
      @project = Project.create(:name => "foo")
    end
    
    it "should return true if passed value is nil (= general rating)" do
      @project.is_valid_rateable_attribute?(nil).should be_true
    end
    
    it "should return true if passed value is one of the specified attributes" do
      @project.is_valid_rateable_attribute?(:usability).should be_true
    end
    
    it "should return false if passed value is not nil and not one of the specified attributes" do
      @project.is_valid_rateable_attribute?(:bar).should be_false
    end
  end
  
  describe :validate_rating_data! do
    before :all do
      @project = Project.create(:name => "foo")
    end
    
    it "should throw an exception if is_valid_rateable_attribute? returns false" do
      lambda{@project.validate_rating_data!(9, :foo)}.should raise_error
    end
    
    it "should throw an exception if rating is not in rateable_range" do
      lambda{@project.validate_rating_data!(8, nil)}.should raise_error
    end
    
    it "should return true if everything is nice" do
      @project.validate_rating_data!(3, nil).should be_true
    end
  end
  
  # describe :rate do
  #   it "" do
  #     
  #   end
  # end
end