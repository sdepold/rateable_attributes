module RateableAttributesHelper
  def visualize_average_rating(object, options={})
    options[:attribute] ||= nil
    options[:image_rated] ||= "ratings/star_rated.png"
    options[:image_unrated] ||= "ratings/star_unrated.png"
    options[:image_hover] ||= "ratings/star_hover.png"
    options[:click_url] ||= ""

    result = ""
    rating = object.average_rating_rounded(options[:attribute])
    max_rating = object.rateable_range.end
    
    max_rating.times do |i|
      id = "#{object.class.to_s.downcase}_#{options[:attribute] || "general"}_#{object.id}"
      image_options = {:id => "#{id}_#{i}"}
      image = ((i + 1) <= rating) ? options[:image_rated] : options[:image_unrated]
      
      if options[:enable_rating]
        image_options.merge!({
          :onmousemove => "rateableAttributesHoverRatingImage(#{rating}, '#{id}', #{i}, '#{options[:image_hover]}')",
          :onmouseout => "rateableAttributesUnhoverRatingImage(#{rating}, #{max_rating}, '#{id}', '#{options[:image_rated]}', '#{options[:image_unrated]}')",
          :onclick => "rateableAttributesClickRatingImage('#{options[:click_url]}', #{i + 1}, '#{options[:attribute]}', #{max_rating}, '#{id}', '#{options[:image_rated]}', '#{options[:image_unrated]}')"
        })
      end
      
      result << image_tag(image, image_options)
    end
    
    result
  end
end