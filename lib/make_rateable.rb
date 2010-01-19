module MakeRateable
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def make_rateable(*args)
      include ActionView::Helpers
      has_many :ratings, :as => :rateable
      
      options = args.extract_options!
      options[:range] ||= 1..5
      
      { :rateable_range => options[:range], :rateable_attributes => args }.each do |accessor, value|
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
    def is_valid_rateable_attribute?(attribute)
      attribute.nil? || rateable_attributes.include?(attribute.to_sym)
    end
    
    def validate_rating_data!(rating, attribute)
      raise "#{attribute} is not valid for this model. Choose one of the following: #{rateable_attributes.join(', ')}" unless is_valid_rateable_attribute?(attribute)
      raise "The rating #{rating} is not in allowed rating range: #{rateable_range.to_s}" unless rateable_range.include?(rating)
      true
    end
    
    def rate(rating, user, attribute=nil)
      validate_rating_data!(rating, attribute)
      return rating_from(user, attribute) if was_rated_by?(user, attribute)
      Rating.create({:user => user, :rating => rating, :rateable_attribute => attribute, :rateable => self}) 
    end
    
    def rate!(rating, user, attribute=nil)
      validate_rating_data!(rating, attribute)
      Rating.create!({:user => user, :rating => rating, :rateable_attribute => attribute, :rateable => self}) 
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
      average_rating(attribute) * 100 / rateable_range.end
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
      options[:image_hover] ||= "ratings/star_hover.png"
      
      result = ""
      rating = average_rating_rounded(options[:attribute])
      rating.times do
        result << if options[:user_can_rate]
          image_tag(options[:image_rated], :onmouseover => "this.src = '/images/#{options[:image_hover]}';", :onmouseout => "this.src = '/images/#{options[:image_rated]}';")
        else
          image_tag(options[:image_rated])
        end
      end
      (rateable_range.end - rating).times do
        result << image_tag(options[:image_unrated])
      end
      
      result
    end
    
    private
    
    def method_missing(method, *args, &block)
      return super(method, *args, &block) unless method.to_s.starts_with?("rate_")

      # this will find method calls like rate_accuracy
      attribute = method.to_s.split("rate_").last
      rate(args[0], args[1], attribute) if rateable_attributes.include?(attribute.to_sym) && ![args[0], args[1]].include?(nil)
    end 
  end
end

class ActiveRecord::Base
  include MakeRateable
end