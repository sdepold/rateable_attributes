function rateableAttributesHoverRating(objectRating, idPrefix, hoveredRating, hoverImage) {
  for(var i = 0; i <= hoveredRating; i++)
    document.getElementById(idPrefix + "_" + i).src = "/images/" + hoverImage;
}

function rateableAttributesUnhoverRating(objectRating, maxRating, idPrefix, ratedImage, unratedImage) {
  for(var i = 0; i < maxRating; i++) {
    var image = (i < objectRating) ? ratedImage : unratedImage;
    document.getElementById(idPrefix + "_" + i).src = "/images/" + image;
  }
}