function rateableAttributesHoverRatingImage(objectRating, idPrefix, hoveredRating, hoverImage) {
  for(var i = 0; i <= hoveredRating; i++)
    document.getElementById(idPrefix + "_" + i).src = "/images/" + hoverImage;
}

function rateableAttributesUnhoverRatingImage(objectRating, maxRating, idPrefix, ratedImage, unratedImage) {
  for(var i = 0; i < maxRating; i++) {
    var image = (i < objectRating) ? ratedImage : unratedImage;
    document.getElementById(idPrefix + "_" + i).src = "/images/" + image;
  }
}

function rateableAttributesClickRatingImage(ajaxURL, clickedRating, clickedAttribute) {
  new Ajax.Request(ajaxURL, {
    parameters: { 
      rating: clickedRating,
      attribute: clickedAttribute
    }
  });
}