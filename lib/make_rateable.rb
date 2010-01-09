module MakeRateable
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def make_rateable(options={})
      include ActionView::Helpers
      has_many :ratings, :as => :rateable
      
      options[:max_rating] ||= 5
      options[:attributes] ||= []
      
      { :max_rating => options[:max_rating], :rateable_attributes => options[:attributes] }.each do |accessor, value|
        next if respond_to?(accessor)
        class_inheritable_accessor accessor
        attr_protected accessor
        self.send("#{accessor}=", value)
      end
      
      include MakeRateable::ClassMethods
      include MakeRateable::InstanceMethods
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    def rate(rating, user, attribute=nil)
      raise "#{attribute} is not valid for this model. Choose one of the following: #{rateable_attributes.join(', ')}" if attribute.present? && !rateable_attributes.include?(attribute.to_sym)
      return rating_from(user, attribute) if was_rated_by?(user, attribute)
      Rating.create({:user => user, :rating => rating, :rateable_attribute => attribute, :rateable => self}) 
    end
    
    def average_rating(attribute=nil)
      all_ratings = ratings.find(:all, :conditions => {:rateable_attribute => attribute})
      return 0.0 if all_ratings.empty?
      all_ratings.sum(&:rating) / all_ratings.size
    end
    
    def average_rating_rounded(attribute=nil)
      average_rating(attribute).round
    end
    
    def average_rating_percentage(attribute=nil)
      average_rating(attribute) * 100 / max_rating
    end
    
    def was_rated_by?(user, attribute=nil)
      ratings.find(:first, :conditions => {:user_id => user.id, :rateable_attribute => attribute}).present?
    end
    
    def ratings_by(user, attribute=nil)
      ratings.find(:all, :conditions => {:user => user, :rateable_attribute => attribute})
    end
    
    def visualize_average_rating(options={})
      options[:attribute] ||= nil
      options[:image_rated] ||= "ratings/star_rated.png"
      options[:image_unrated] ||= "ratings/star_unrated.png"
      
      result = ""
      rating = average_rating_rounded(options[:attribute])
      rating.times { result << image_tag(options[:image_rated]) }
      (max_rating - rating).times { result << image_tag(options[:image_unrated]) }
      
      result
    end
    
    private
    
    def method_missing(method, *args)
      attribute = method.to_s.split("rate_").last
      
      if method.to_s.starts_with?("rate_") && rateable_attributes.include?(attribute.to_sym)
        # this will find method calls like rate_accuracy
        rate(args[0], args[1], attribute) unless [args[0], args[1]].include?(nil)
      end
    end
    
  end
end

class ActiveRecord::Base
  include MakeRateable
end