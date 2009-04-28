function showDetailLightbox(){
  $('detail_lightbox_backdrop').observe('click', function(e){
    if(e.findElement() == $('detail_lightbox_backdrop'))
      $('detail_lightbox_backdrop').hide();
  }, false);
  
  $('detail_lightbox_backdrop').show();
}