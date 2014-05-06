$(function() {
  var myQr = $('#qr_input');
  myQr.on('change', sendQr);

  function sendQr() {
    var formData = new FormData($('form')[0]);
    $.ajax({
      url: '/qr',
      type: 'POST',
      // xhr: function() {
      //   var myXhr = $.ajaxSettings.xhr();
      //   if(myXhr.upload){
      //     myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
      //   }
      //   return myXhr;
      // },
      // Form data
      data: formData,
      // Options
      cache: false,  // not necessary
      contentType: false, // necessary
      processData: false // necessary
    }).done(
      function(data) {
        if(data === ''){
          $('#result').html('Could not decode QR')
        }
        else {
          $('#result').html(data);
        }
      }
    ).fail(
      function(error) {
        $('#result').html('Server Error')
      }
    );
  }

}); // End jQuery