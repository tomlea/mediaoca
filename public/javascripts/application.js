function showDetailLightbox(){
  $('detail_lightbox_backdrop').observe('click', function(){
    $('detail_lightbox_backdrop').hide();
  });
  
  $('detail_lightbox_backdrop').show();
}