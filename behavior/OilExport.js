/* Make an AJAX request for a new plot */
function requestImage() {
  var a = $('controls_form').serialize();
  var AR = new Ajax.Request('/cgi-bin/OilExport.cgi', {
    parameters: a,
    evalJSON: 'force',
    onCreate: function(){$('spinner').show()},
    onComplete: completed  });
}

/* Respond to the AJAX response */
function completed(Response, header) {
// TODO:  check the response for possible errors
  var img_url = Response.responseJSON.img_url;
  var pdf_url = Response.responseJSON.pdf_url;
  $('plot').src = img_url;
  $('pdf').href = pdf_url;
  $('spinner').hide();
}

/* Callback functions for plottype tabs */

function chooseExports() {
  $('Exports').addClassName('selected');
  $('Sources').removeClassName('selected');
  $('plottype').value = 'Exports';
  $('coal').enable();
  $('coal_span').setOpacity(1.0).removeClassName('selected');
  $('oil').enable();
  $('oil').checked = true;
  $('oil_span').setOpacity(1.0).removeClassName('selected');
  $('gas').enable();
  $('gas_span').setOpacity(1.0).removeClassName('selected');
  $('nuclear').enable();
  $('nuclear_span').setOpacity(1.0).removeClassName('selected');
  $('hydro').enable();
  $('hydro_span').setOpacity(1.0).removeClassName('selected');
  $('all').disable();
  $('all_span').setOpacity(0.3).removeClassName('selected');

  changeAdvancedOptions();
  chooseOil();
}

function chooseSources() {
  $('Exports').removeClassName('selected');
  $('Sources').addClassName('selected');
  $('plottype').value = 'Sources';
  $('coal').disable();
  $('coal_span').setOpacity(0.3).removeClassName('selected');
  $('oil').disable();
  $('oil_span').setOpacity(0.3).removeClassName('selected');
  $('gas').disable();
  $('gas_span').setOpacity(0.3).removeClassName('selected');
  $('nuclear').disable();
  $('nuclear_span').setOpacity(0.3).removeClassName('selected');
  $('hydro').disable();
  $('hydro_span').setOpacity(0.3).removeClassName('selected');
  $('all').enable();
  $('all').checked = true;
  $('all_span').setOpacity(1.0).removeClassName('selected');

  changeAdvancedOptions();
  chooseAll();
}

/* Callback functions for various radio buttons */

function chooseCoal() {
  $('coal_span').addClassName('selected');
  $('oil_span').removeClassName('selected');
  $('gas_span').removeClassName('selected');
  $('nuclear_span').removeClassName('selected');
  $('hydro_span').removeClassName('selected');
  $('all_span').removeClassName('selected');
  // disable and unselect inappropriate units
  $('bbl').disable();
  $('bbl_span').setOpacity(0.3).removeClassName('selected');
  $('ft3').disable();
  $('ft3_span').setOpacity(0.3).removeClassName('selected');
  $('m3').disable();
  $('m3_span').setOpacity(0.3).removeClassName('selected');
  $('twh').disable();
  $('twh_span').setOpacity(0.3).removeClassName('selected');
  // keep current units if possible
  var units = $$('input:checked[type="radio"][name="units"]').pluck('value')[0]; 
  if (units == 'joule') {
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule').checked = true;
    $('joule_span').setOpacity(1.0).addClassName('selected');
  } else { // default to 'mtoe'
    $('mtoe').enable();
    $('mtoe').checked = true;
    $('mtoe_span').setOpacity(1.0).addClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  }

  requestImage();
}

function chooseOil() {
  $('coal_span').removeClassName('selected');
  $('oil_span').addClassName('selected');
  $('gas_span').removeClassName('selected');
  $('nuclear_span').removeClassName('selected');
  $('hydro_span').removeClassName('selected');
  $('all_span').removeClassName('selected');
  // disable and unselect inappropriate units
  $('ft3').disable();
  $('ft3_span').setOpacity(0.3).removeClassName('selected');
  $('m3').disable();
  $('m3_span').setOpacity(0.3).removeClassName('selected');
  $('twh').disable();
  $('twh_span').setOpacity(0.3).removeClassName('selected');
  // keep current units if possible
  var units = $$('input:checked[type="radio"][name="units"]').pluck('value')[0]; 
  if (units == 'mtoe') {
    $('bbl').enable();
    $('bbl_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe').checked = true;
    $('mtoe_span').setOpacity(1.0).addClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  } else if (units == 'joule') {
    $('bbl').enable();
    $('bbl_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule').checked = true;
    $('joule_span').setOpacity(1.0).addClassName('selected');
  } else { // default to 'bbl'
    $('bbl').enable();
    $('bbl').checked = true;
    $('bbl_span').setOpacity(1.0).addClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  }

  requestImage();
}

function chooseGas() {
  $('coal_span').removeClassName('selected');
  $('oil_span').removeClassName('selected');
  $('gas_span').addClassName('selected');
  $('nuclear_span').removeClassName('selected');
  $('hydro_span').removeClassName('selected');
  $('all_span').removeClassName('selected');
  // disable and unselect inappropriate units
  $('bbl').disable();
  $('bbl_span').setOpacity(0.3).removeClassName('selected');
  $('twh').disable();
  $('twh_span').setOpacity(0.3).removeClassName('selected');
  // keep current units if possible
  var units = $$('input:checked[type="radio"][name="units"]').pluck('value')[0]; 
  if (units == 'mtoe') {
    $('ft3').enable();
    $('ft3_span').setOpacity(1.0).removeClassName('selected');
    $('m3').enable();
    $('m3_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe').checked = true;
    $('mtoe_span').setOpacity(1.0).addClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  } else if (units == 'joule') {
    $('ft3').enable();
    $('ft3_span').setOpacity(1.0).removeClassName('selected');
    $('m3').enable();
    $('m3_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule').checked = true;
    $('joule_span').setOpacity(1.0).addClassName('selected');
  } else if (units == 'm3') {
    $('ft3').enable();
    $('ft3_span').setOpacity(1.0).removeClassName('selected');
    $('m3').enable();
    $('m3').checked = true;
    $('m3_span').setOpacity(1.0).addClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  } else { // default to 'ft3'
    $('ft3').enable();
    $('ft3').checked = true;
    $('ft3_span').setOpacity(1.0).addClassName('selected');
    $('m3').enable();
    $('m3_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  }
  requestImage();
}

function chooseNuclear() {
  $('coal_span').removeClassName('selected');
  $('oil_span').removeClassName('selected');
  $('gas_span').removeClassName('selected');
  $('nuclear_span').addClassName('selected');
  $('hydro_span').removeClassName('selected');
  $('all_span').removeClassName('selected');
  // disable and unselect inappropriate units
  $('bbl').disable();
  $('bbl_span').setOpacity(0.3).removeClassName('selected');
  $('ft3').disable();
  $('ft3_span').setOpacity(0.3).removeClassName('selected');
  $('m3').disable();
  $('m3_span').setOpacity(0.3).removeClassName('selected');
  // keep current units if possible
  var units = $$('input:checked[type="radio"][name="units"]').pluck('value')[0]; 
  if (units == 'mtoe') {
    $('twh').enable();
    $('twh_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe').checked = true;
    $('mtoe_span').setOpacity(1.0).addClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  } else if (units == 'joule') {
    $('twh').enable();
    $('twh_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule').checked = true;
    $('joule_span').setOpacity(1.0).addClassName('selected');
  } else { // default to 'twh'
    $('twh').enable();
    $('twh').checked = true;
    $('twh_span').setOpacity(1.0).addClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  }
  requestImage();
}

function chooseHydro() {
  $('coal_span').removeClassName('selected');
  $('oil_span').removeClassName('selected');
  $('gas_span').removeClassName('selected');
  $('nuclear_span').removeClassName('selected');
  $('hydro_span').addClassName('selected');
  $('all_span').addClassName('selected');
  // disable and unselect inappropriate units
  $('bbl').disable();
  $('bbl_span').setOpacity(0.3).removeClassName('selected');
  $('ft3').disable();
  $('ft3_span').setOpacity(0.3).removeClassName('selected');
  $('m3').disable();
  $('m3_span').setOpacity(0.3).removeClassName('selected');
  // keep current units if possible
  var units = $$('input:checked[type="radio"][name="units"]').pluck('value')[0]; 
  if (units == 'mtoe') {
    $('twh').enable();
    $('twh_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe').checked = true;
    $('mtoe_span').setOpacity(1.0).addClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  } else if (units == 'joule') {
    $('twh').enable();
    $('twh_span').setOpacity(1.0).removeClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule').checked = true;
    $('joule_span').setOpacity(1.0).addClassName('selected');
  } else { // default to 'twh'
    $('twh').enable();
    $('twh').checked = true;
    $('twh_span').setOpacity(1.0).addClassName('selected');
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  }
  requestImage();
}

function chooseAll() {
  $('coal_span').removeClassName('selected');
  $('oil_span').removeClassName('selected');
  $('gas_span').removeClassName('selected');
  $('nuclear_span').removeClassName('selected');
  $('hydro_span').removeClassName('selected');
  $('all_span').addClassName('selected');
  // disable and unselect inappropriate units
  $('bbl').disable();
  $('bbl_span').setOpacity(0.3).removeClassName('selected');
  $('ft3').disable();
  $('ft3_span').setOpacity(0.3).removeClassName('selected');
  $('m3').disable();
  $('m3_span').setOpacity(0.3).removeClassName('selected');
  $('twh').disable();
  $('twh_span').setOpacity(0.3).removeClassName('selected');
  // keep current units if possible
  var units = $$('input:checked[type="radio"][name="units"]').pluck('value')[0]; 
  if (units == 'joule') {
    $('mtoe').enable();
    $('mtoe_span').setOpacity(1.0).removeClassName('selected');
    $('joule').enable();
    $('joule').checked = true;
    $('joule_span').setOpacity(1.0).addClassName('selected');
  } else { // default to 'mtoe'
    $('mtoe').enable();
    $('mtoe').checked = true;
    $('mtoe_span').setOpacity(1.0).addClassName('selected');
    $('joule').enable();
    $('joule_span').setOpacity(1.0).removeClassName('selected');
  }

  requestImage();
}

function chooseJoule() {
  $('joule_span').addClassName('selected');
  $('mtoe_span').removeClassName('selected');
  $('bbl_span').removeClassName('selected');
  $('ft3_span').removeClassName('selected');
  $('m3_span').removeClassName('selected');
  $('twh_span').removeClassName('selected');
  requestImage();
}

function chooseMTOE() {
  $('joule_span').removeClassName('selected');
  $('mtoe_span').addClassName('selected');
  $('bbl_span').removeClassName('selected');
  $('ft3_span').removeClassName('selected');
  $('m3_span').removeClassName('selected');
  $('twh_span').removeClassName('selected');
  requestImage();
}

function chooseBBL() {
  $('joule_span').removeClassName('selected');
  $('mtoe_span').removeClassName('selected');
  $('bbl_span').addClassName('selected');
  $('ft3_span').removeClassName('selected');
  $('m3_span').removeClassName('selected');
  $('twh_span').removeClassName('selected');
  requestImage();
}

function chooseFT3() {
  $('joule_span').removeClassName('selected');
  $('mtoe_span').removeClassName('selected');
  $('bbl_span').removeClassName('selected');
  $('ft3_span').addClassName('selected');
  $('m3_span').removeClassName('selected');
  $('twh_span').removeClassName('selected');
  requestImage();
}

function chooseM3() {
  $('joule_span').removeClassName('selected');
  $('mtoe_span').removeClassName('selected');
  $('bbl_span').removeClassName('selected');
  $('ft3_span').removeClassName('selected');
  $('m3_span').addClassName('selected');
  $('twh_span').removeClassName('selected');
  requestImage();
}

function chooseTWH() {
  $('joule_span').removeClassName('selected');
  $('mtoe_span').removeClassName('selected');
  $('bbl_span').removeClassName('selected');
  $('ft3_span').removeClassName('selected');
  $('m3_span').removeClassName('selected');
  $('twh_span').addClassName('selected');
  requestImage();
}

function chooseYAuto() {
  $('y_auto_span').addClassName('selected');
  $('y_us_span').removeClassName('selected');
  $('y_world_span').removeClassName('selected');
  requestImage();
}

function chooseYUS() {
  $('y_auto_span').removeClassName('selected');
  $('y_us_span').addClassName('selected');
  $('y_world_span').removeClassName('selected');
  requestImage();
}

function chooseYWorld() {
  $('y_auto_span').removeClassName('selected');
  $('y_us_span').removeClassName('selected');
  $('y_world_span').addClassName('selected');
  requestImage();
}

function chooseConsumption() {
  $('consumption_span').addClassName('selected');
  $('production_span').removeClassName('selected');
  requestImage();
}

function chooseProduction() {
  $('consumption_span').removeClassName('selected');
  $('production_span').addClassName('selected');
  requestImage();
}

/* Determine which options to show depending upon the plottype */

function chooseAdvancedOptions() {
  /* Choose the labels based on the language */

  switch($F('language')) {
    case 'de':
      text_show = 'Optionen Anzeigen';
      text_hide = 'Optionen Ausblenden';
      break;
    case 'en':
      text_show = 'Show Options';
      text_hide = 'Hide Options';
      break;
    case 'es':
      text_show = 'Meustra Opciones';
      text_hide = 'Oculta Opciones';
      break;
    case 'fr':
      text_show = 'Affichez les Options';
      text_hide = 'Masquez les Options';
      break;
    case 'it':
      text_show = 'Mostra Opzioni';
      text_hide = 'Nascondi Opzioni';
      break;
    case 'nl':
      text_show = 'Toon Opties';
      text_hide = 'Verberg Opties';
      break;
    case 'sk':
      text_show = 'Ukáž možnosti';
      text_hide = 'Skri možnosti';
    case 'sv':
      text_show = 'Visa Alternativ';
      text_hide = 'Dölj Alternativ';
      break;
    default:
      text_show = 'Show Options';
      text_hide = 'Hide Options';
      break;
  }

  if ( $('advanced_options').hasClassName('selected') ) {
    $('advanced_options').removeClassName('selected');
    $('advanced_options').update(text_show);
    $$('#advanced_options_div > div').each(function(item) {
      item.hide();
    });
  } else {
    $('advanced_options').addClassName('selected');
    $('advanced_options').update(text_hide);
    plottype = $$('li.tab > a.selected')[0].identify();
    selector = '#advanced_options_div > div.' + plottype;
    $$(selector).each(function(item) {
      item.show();
    });
  }
}

function changeAdvancedOptions() {
  if ( $('advanced_options').hasClassName('selected') ) {
    $$('#advanced_options_div > div').each(function(item) {
      item.hide();
    });
    plottype = $$('li.tab > a.selected')[0].identify();
    selector = '#advanced_options_div > div.' + plottype;
    $$(selector).each(function(item) {
      item.show();
    });
  }
}

/* Document onload functionality */

document.observe('dom:loaded', function() {
  // hide the spinner first
  $('spinner').hide();

  // plottype tabs
  $('Exports').observe('click', chooseExports);
  $('Sources').observe('click', chooseSources);
  
  // fuel radio buttons
  $('coal').observe('click', chooseCoal);
  $('oil').observe('click', chooseOil);
  $('gas').observe('click', chooseGas);
  $('nuclear').observe('click', chooseNuclear);
  $('hydro').observe('click', chooseHydro);
  $('all').observe('click', chooseAll);
  // units radio buttons
  $('joule').observe('click', chooseJoule);
  $('mtoe').observe('click', chooseMTOE);
  $('bbl').observe('click', chooseBBL);
  $('ft3').observe('click', chooseFT3);
  $('m3').observe('click', chooseM3);
  $('twh').observe('click', chooseTWH);
  // country selector
  $('countryID').observe('change', requestImage);

  // "Exports" yscalecode radio buttons
  $('y_auto').observe('click', chooseYAuto);
  $('y_us').observe('click', chooseYUS);
  $('y_world').observe('click', chooseYWorld);
  // "Exports" showmap checkbox
  $('showmap').observe('click', requestImage);
  // "Sources" conprod radio buttons
  $('consumption').observe('click', chooseConsumption);
  $('production').observe('click', chooseProduction);
  // "Sources" percent checkbox
  $('percent').observe('click', requestImage);

  // disable and unselect 'all' fuel type until it is enabled by selecting 'Sources' plottype
  $('all').disable();
  $('all_span').setOpacity(0.3).removeClassName('selected');
  
  // disable and unselect units unavailable for Oil in the 'Exports' plot (the default)
  $('ft3').disable();
  $('ft3_span').setOpacity(0.3).removeClassName('selected');
  $('m3').disable();
  $('m3_span').setOpacity(0.3).removeClassName('selected');
  $('twh').disable();
  $('twh_span').setOpacity(0.3).removeClassName('selected');

  // advanced options button
  $('advanced_options').observe('click',chooseAdvancedOptions);
  $$('#advanced_options_div > div').each(function(item) {
    item.hide();
  });
});
