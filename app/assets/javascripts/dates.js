$(document).ready(function() {
  $('input.datepicker').each(function() {
    $(this).datepicker({
      dateFormat: "dd-mm-yy",
      maxDate: '0'
    });
  });
});
