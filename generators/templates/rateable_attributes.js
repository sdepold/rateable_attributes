function rateableAttributesHoverRatingImage(objectRating, idPrefix, hoveredRating, hoverImage) {
  for(var i = 0; i <= hoveredRating; i++)
    $(idPrefix + "_" + i).src = "/images/" + hoverImage;
}

function rateableAttributesUnhoverRatingImage(objectRating, maxRating, idPrefix, ratedImage, unratedImage) {
  for(var i = 0; i < maxRating; i++) {
    var imageURL = "/images/" + ((i < objectRating) ? ratedImage : unratedImage);
    $(idPrefix + "_" + i).src = imageURL;
  }
}

function rateableAttributesClickRatingImage(ajaxURL, clickedRating, clickedAttribute, maxRating, idPrefix, ratedImage, unratedImage) {
  new Ajax.Request(ajaxURL, {
    parameters: { 
      rating: clickedRating,
      attribute: clickedAttribute
    },
    onSuccess:function(data) {
      var result = data.responseJSON;
      rateableAttributesUnhoverRatingImage(result.new_rating, maxRating, idPrefix, ratedImage, unratedImage);
    }
  });
}