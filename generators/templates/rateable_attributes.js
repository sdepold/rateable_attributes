function rateableAttributesHoverRating(objectRating, idPrefix, hoveredRating, hoverImage) {
  for(var i = 0; i < hoveredRating; i++)
    document.getElementById(idPrefix + i).src = "/images/" + hoverImage;
}

function rateableAttributesUnhoverRating(objectRating, maxRating, idPrefix, ratedImage, unratedImage) {
  for(var i = 0; i < maxRating; i++) {
    var image = (i < maxRating) ? ratedImage : unratedImage;
    document.getElementById(idPrefix + i).src = "/images/" + image;
  }
}