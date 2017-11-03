############################################################
# create_text_strings()
#
# Returns a list containing US English text strings.
#
# These are used by the following functions:
# * Import_Export_plot()
#

create_text_strings <- function(plottype='Exports',country='MZM_WORLD',fuel='oil',units='bbl',conprod='consumption') {

  # Country names for special 'MZM_~' groupings
  if (length(grep('MZM_',country)) == 1) {
    country_list = c(
                     MZM_NSE='Severné more',
                     MZM_CRB='Karibik',
                     MZM_PRG='Perzský záliv',
                     MZM_WAF='Západná Afrika',
                     MZM_WORLD='Svet',
                     MZM_FSU='Bývalý Sovietsky zväz',
                     MZM_EU0='Európa (-BSZ)',
                     MZM_EU1='Europe (+BSZ)',
                     MZM_OPEC='OPEC',
                     MZM_OPEC10='OPEC-10',
                     MZM_GCC='Rada pre spoluprácu krajín Perzského zálivu',
                     MZM_GECF='Krajiny vyvážajúce zemný plyn',
                     MZM_GECF11='KVZP-11',
                     MZM_NON_OPEC='Mimo-OPEC',
                     MZM_OECD='OECD',
                     MZM_G7='G7',
                     MZM_O5='O5',
                     MZM_G75='G7 + O5',
                     MZM_BELU='Belgicko a Luxembursko',
                     MZM_TNA='Severná Amerika',
                     MZM_TSCA='Juž. a Str. Amerika',
                     MZM_TEE='Európa',
                     MZM_TME='Stredný Východ',
                     MZM_TAF='Afrika',
                     MZM_TAP='Ázia-Pacifik'
                    )
    country = country_list[[country]]
  }

  title_coal = 'Uhlie'
  title_oil = 'Ropa'
  title_gas = 'Zemný Plyn'
  title_nuclear = 'Jadro'
  title_hydro = 'Voda'
  title_all = 'Všetko'
  title_consumption = 'Spotreba'
  title_production = 'Produkcia'
  units_mto = 'milióny ton za rok'
  units_mtoe = 'milióny ton ekv. ropy za rok'
  units_bbl = 'milióny barelov za deň'
  units_ft3 = 'miliárd kubických stôp za deň'
  units_m3 = 'miliárd kubických metrov za rok'
  units_twh = 'Terawatt-hodín za rok'
  units_joule = 'Exajoulov za rok'

  # Resource
  if (fuel == 'oil') {
    resource = title_oil
  } else if (fuel == 'gas') {
      resource = title_gas
  } else if ( fuel == 'coal') {
      resource = title_coal
  } else if ( fuel == 'nuclear') {
      resource = title_nuclear
  } else if ( fuel == 'hydro') {
      resource = title_hydro
  } else if ( fuel == 'all') {
      resource = title_all
  }

  # Units
  if (units == 'mtoe') {
    if (fuel == 'oil') {
      text_units = units_mto
    } else {
      text_units = units_mtoe
    }
  } else if (units == 'bbl') {
    text_units = units_bbl
  } else if (units == 'ft3') {
    text_units = units_ft3
  } else if (units == 'm3') {
    text_units = units_m3
  } else if (units == 'twh') {
    text_units = units_twh
  } else if (units == 'joule') {
    text_units = units_joule
  }

  # Main titles
  if (plottype == 'Sources') {
    if (conprod == 'consumption') {
      main1 = paste(country,': ',title_consumption)
    } else if (conprod == 'production') {
      main1 = paste(country,': ',title_production)
    }
    main2 = 'main2'
    main3 = 'main3'
  } else {
    main1 = paste(country,': ',resource)
    main2 = 'main2'
    main3 = 'main3'
  }

  # TODO:  Rename subtitle,fromto,earned?,spent?
  # Assemble the list
  txt = list(
             main1 = main1,
             main2 = main2,
             main3 = main3,
             subtitle = 'Údaje: Štatistický prehľad BP_2012    Grafika: mazamascience.com',
             year = 'Rok',
             units = text_units,
             consumption = 'Spotreba',
             production = 'Produkcia',
             imports = 'čistý dovoz',
             exports = 'čistý vývoz',
             consumption_increased = 'spotreba stúpla o',
             consumption_decreased = 'spotreba klesla o',
             production_increased = 'produkcia stúpla o',
             production_decreased = 'produkcia klesla o',
             imports_increased = 'dovoz stúpol o',
             imports_decreased = 'dovoz klesol o',
             exports_increased = 'vývoz stúpol o',
             exports_decreased = 'vývoz klesol o',
             note_nodata = '* nedostupné údaje',
             note_minvalue = '* minimálna hodnota',
             msg_nodata = 'Nedostupné údaje',
             country = country,
             earned = 'zisk',
             spent = 'útrata',
             billion = 'miliarda',
             missing = 'chýbajúce údaje',
             net_0 = 'nula',
             coal = 'uhlie',
             oil = 'ropa',
             gas = 'zemný plyn',
             nuclear = 'jadro',
             hydro = 'voda',
             US = 'USA',
             World = 'Svet',
             percent = '% z celku',
             energy_consumed_increased = 'Celková spotrebovaná energia stúpla o',
             energy_consumed_decreased = 'Celková spotrebovaná energia klesla o',
             energy_produced_increased = 'Celková vyrobená energia stúpla o',
             energy_produced_decreased = 'Celková vyrobená energia klesla o',
             percent_title = 'Percento výroby z každého zdroja.',
             efficiency = '( 38% účinnosť )'
            )

  return(txt)

}
            
