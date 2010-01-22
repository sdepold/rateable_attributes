module RateableAttributes
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def rateable_attributes(*args)
      has_many :ratings, :as => :rateable
      
      options = args.extract_options!
      options[:range] ||= 1..5
      
      { :rateable_range => options[:range], :rateables => args }.each do |accessor, value|
        next if respond_to?(accessor)
        class_inheritable_accessor accessor
        attr_protected accessor
        self.send("#{accessor}=", value)
      end
      
      include RateableAttributes::ClassMethods
      include RateableAttributes::InstanceMethods
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    def is_valid_rateable_attribute?(attribute)
      attribute.nil? || rateables.include?(attribute.to_sym)
    end
    
    def validate_rating_data!(rating, attribute)
      raise "#{attribute} is not valid for this model. Choose one of the following: #{rateables.join(', ')}" unless is_valid_rateable_attribute?(attribute)
      raise "The rating #{rating} is not in allowed rating range: #{rateable_range.to_s}" unless rateable_range.include?(rating)
      true
    end
    
    def rate(rating, user, attribute=nil)
      validate_rating_data!(rating, attribute)
      return rating_by(user, attribute) if was_rated_by?(user, attribute)
      Rating.create({:user => user, :rating => rating, :rateable_attribute => attribute, :rateable => self}) 
    end
    
    def rate!(rating, user, attribute=nil)
      validate_rating_data!(rating, attribute)
      Rating.create!({:user => user, :rating => rating, :rateable_attribute => attribute, :rateable => self}) 
    end
    
    def average_rating(attribute=nil)
      attribute = attribute.to_s unless attribute.nil?
      all_ratings = ratings.find(:all, :conditions => {:rateable_attribute => attribute})
      return 0.0 if all_ratings.empty?
      all_ratings.sum(&:rating) / all_ratings.size
    end
    
    def average_rating_rounded(attribute=nil)
      average_rating(attribute).round
    end
    
    def average_rating_percentage(attribute=nil)
      average_rating(attribute) * 100 / rateable_range.end
    end
    
    def was_rated_by?(user, attribute=nil)
      attribute = attribute.to_s unless attribute.nil?
      ratings.find(:first, :conditions => {:user_id => user.id, :rateable_attribute => attribute}).present?
    end
    
    def rating_by(user, attribute=nil)
      attribute = attribute.to_s unless attribute.nil?
      ratings.find(:first, :conditions => {:user_id => user.id, :rateable_attribute => attribute})
    end
    
    private
    
    def method_missing(method, *args, &block)
      return super(method, *args, &block) unless method.to_s.starts_with?("rate_")

      # this will find method calls like rate_accuracy
      attribute = method.to_s.split("rate_").last
      rate(args[0], args[1], attribute) if rateables.include?(attribute.to_sym) && ![args[0], args[1]].include?(nil)
    end 
  end
end

class ActiveRecord::Base
  include RateableAttributes
end