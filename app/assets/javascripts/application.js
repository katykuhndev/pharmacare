// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require rails-ujs 
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es.js
//= require_tree .


$(document).ready(function(){
  $('.datepicker').datepicker({
  	autoclose: true,
    todayHighlight: true, 
    orientation: 'auto top', 
    format: 'yyyy-mm-dd',
    language: 'es',
    endDate: "1d"
  });
  $('#show').click(function() {
      $('.menu').toggle("slide");
    });
});

$(document).ready(function(){
    $("#recomendacion_atributos_examen_baciliformes").keyup(function(){
          var leuco = +$("#recomendacion_atributos_examen_leucocitos").val();
          var seg = +$("#recomendacion_atributos_examen_segmentados").val();
          var bacil = +$("#recomendacion_atributos_examen_baciliformes").val();
          var ran = (seg+bacil)*leuco/100;
          $("#recomendacion_atributos_examen_ran").val(ran);
    });
});

$(function() {
  function selectVisibility() {
    var selector = $($(this).attr('data-selects-visibility'));
    if ($(this).is('input[type="checkbox"]')) {
      if ($(this).is(':checked')) {
        value = '_checked';
      } else {
        value = '_unchecked';
      }
    } else if ($(this).is('input[type=radio]')) {
      var checkedRadioButton = $(this).closest('form').find('input[type="radio"][name="' + $(this).attr('name') + '"]:checked');
      if (checkedRadioButton.length > 0) {
        value = checkedRadioButton.val();
      }
    } else {
      var value = $(this).val();
    }
    if (!value) {
      value = '_blank';
    }
    selector.filter('[data-show-for]:not([data-show-for~="' + value + '"])').hide();
    selector.filter('[data-hide-for~="' + value + '"]').hide();
    selector.filter('[data-hide-for]:not([data-hide-for~="' + value + '"])').show();
    selector.filter('[data-show-for~="' + value + '"]').show();
  }

  $(this).find('[data-selects-visibility]').change(selectVisibility);
  $(this).find('select[data-selects-visibility]').each(selectVisibility);
  $(this).find('input[data-selects-visibility][type="checkbox"]').each(selectVisibility);
  $(this).find('input[data-selects-visibility][type="radio"]:checked').each(selectVisibility);
});

$(function() {
  return $('#recomendacion_medico_nombre').autocomplete({
    source: $('#recomendacion_medico_nombre').data('autocomplete-source') 
  });
});



$(function() {
  $('#recomendacion_atributos_paciente_paciente_rut').bind('railsAutocomplete.select', function(event, data){
    var recomendacion_id = +$("#form_pendiente_recomendacion_id").val();
    $.ajax({
      type:"POST",
      url:"/recomendaciones/encuentra_caso",
      data: {paciente_id :data.item.id, recomendacion_id :recomendacion_id},
      dataType:"json",
      success:function(result){
        $("#form_consentimiento").hide();
        $("#codigo_caso").html("CASO : " + result.codigo);
        if (result.tipo_control_id == 2) {
          $( "#tipo_control_2" ).prop( "checked", true );
          $( "#tipo_control_3" ).prop( "checked", false );
        } else if(result.tipo_control_id == 3){  
          $( "#tipo_control_2" ).prop( "checked", false );
          $( "#tipo_control_3" ).prop( "checked", true );
        }
      }
    });
    /*$("#form_conse").hide();*/
  });
});

/*$(document).ready(function(){
    $("#recomendacion_atributos_paciente_segundo_apellido").keyup(function(){
      $("#form_caso").show();
    });
});*/

