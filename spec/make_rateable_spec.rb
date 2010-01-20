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
  
  describe :rate do
    before :each do
      @project = Project.create(:name => "foo")
      @project.should_receive(:validate_rating_data!).and_return true
      @user = User.create(:name => "max")
    end
    
    it "should return available rating if already rated by user" do
      @project.should_receive(:was_rated_by?).and_return true
      @project.should_receive(:rating_by)
      lambda{@project.rate(1, @user)}.should_not change(Rating, :count).by(1)
    end
    
    it "should not return a given rating but create one if not yet rated by user" do
      @project.should_receive(:was_rated_by?).and_return false
      @project.should_not_receive(:rating_by)
      lambda{@project.rate(1, @user)}.should change(Rating, :count).by(1)      
    end
  end
  
  describe :average_rating do
    before :each do
      Rating.destroy_all
    end

    it "should return 0.0 if no rating is given" do
      Project.create(:name => "foo").average_rating.should == 0.0
    end
    
    it "should calculate correctly" do
      p = Project.create(:name => "foo")
      u = User.create(:name => "max")
      u2 = User.create(:name => "maxine")
      
      p.rate 1, u
      p.rate 5, u2
      
      p.average_rating.should == 3.0
    end
  end
  
  describe :average_rating_rounded do
    it "should return rounded ratings" do
      Rating.destroy_all
      
      p = Project.create(:name => "foo")
      u = User.create(:name => "max")
      u2 = User.create(:name => "maxine")
      
      p.rate 1, u
      p.rate 2, u2
      
      p.average_rating_rounded.should == 1
    end
  end
  
  describe :average_rating_percentage do
    it "should return a percentage" do
      p = Project.create(:name => "foo")
      p.rate 4, User.create(:name => "max")
      
      p.average_rating_percentage.should == 80
    end
  end
  
  describe :was_rated_by? do
    before :each do
      @project = Project.create(:name => "hello world")
      @user = User.create(:name => "my_user")
    end
    
    it "should return false if user hasn't rated yet" do
      @project.was_rated_by?(@user).should be_false
    end
    
    it "should return true if user has already rated" do
      @project.rate 1, @user
      @project.was_rated_by?(@user).should be_true
    end
  end
  
  describe :rating_by do
    before :each do
      @project = Project.create(:name => "hello world")
      @user = User.create(:name => "my_user")
    end
    
    it "should return nil if no rating was given" do
      @project.rating_by(@user).should be_nil
    end
    
    it "should return the rating object if rating was given" do
      @project.rate 1, @user
      r = @project.rating_by(@user)
      r.should_not be_nil
      r.class.to_s.should == "Rating"
      r.rating.should == 1
    end
  end
  
  describe :method_missing do
    before :each do
      @project = Project.create(:name => "hello world")
      @user = User.create(:name => "my_user")
    end
    
    
    it "should add methods for rating the defined attributes" do
      lambda{@project.rate_usability(1, @user)}.should change(Rating, :count).by(1)
      lambda{@project.rate_performance(1, @user)}.should change(Rating, :count).by(1)
      lambda{@project.rate_functionality(1, @user)}.should change(Rating, :count).by(1)
    end
  end
end