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
                     MZM_NSE='Nordsjön',
                     MZM_CRB='Karibien',
                     MZM_PRG='Persiska viken',
                     MZM_WAF='Västafrika',
                     MZM_WORLD='Världen',
                     MZM_FSU='Förra Sovjetunionen',
                     MZM_EU0='Europe (-FSU)',
                     MZM_EU1='Europe (+FSU)',
                     MZM_OPEC='OPEC',
                     MZM_OPEC10='OPEC-10',
                     MZM_GCC='Samarbetsrådet i P v',
                     MZM_GECF='Gasexporterande länder',
                     MZM_GECF11='GECF-11',
                     MZM_NON_OPEC='Icke-OPEC',
                     MZM_OECD='OECD',
                     MZM_G7='G7',
                     MZM_O5='O5',
                     MZM_G75='G7 + O5',
                     MZM_BELU='Belgien och Luxembrg',
                     MZM_TNA='Nordamerika',
                     MZM_TSCA='Syd- och Centralamerika',
                     MZM_TEE='Europe',
                     MZM_TME='Mellanöstern',
                     MZM_TAF='Afrika',
                     MZM_TAP='Asien-Stilla havet'
                    ) 
    country = country_list[[country]]
  }

  title_coal = 'Kol'
  title_oil = 'Olja'
  title_gas = 'Gas'
  title_nuclear = 'Kärnkraft'
  title_hydro = 'Vattenkraft'
  title_all = 'Alla'
  title_consumption = 'Konsumtion'
  title_production = 'Produktion'
  units_mto = 'miljon ton per år'
  units_mtoe = 'miljon ton oljeekv. per år'
  units_bbl = 'miljon fat per dag'
  units_ft3 = 'miljard kubikfot per dag'
  units_m3 = 'miljard kubikmeter per år'
  units_twh = 'Terawattimmar per år'
  units_joule = 'Exajoule per år' 

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
             subtitle = 'Data: BP Statistical Review 2012    Grafic: mazamascience.com',
             year = 'År',
             units = text_units,
             consumption = 'Konsumtion',
             production = 'Produktion',
             imports = 'Nettoimport',
             exports = 'Nettoexport',
             consumption_increased = 'konsumtion ökade med',
             consumption_decreased = 'konsumtion minskade med',
             production_increased = 'produktion ökade med',
             production_decreased = 'produktion minskade med',
             imports_increased = 'import ökade med',
             imports_decreased = 'import minskade med',
             exports_increased = 'export ökade med',
             exports_decreased = 'export minskade med',
             note_nodata = '* inga data tillgängliga',
             note_minvalue = '* minimivärde',
             msg_nodata = 'Inga data tillgängliga',
             country = country,
             earned = 'intjänad',
             spent = 'förbrukad',
             billion = 'miljard',
             missing = 'inga data',
             net_0 = 'netto noll',
             coal = 'kol',
             oil = 'olja',
             gas = 'gas',
             nuclear = 'kärn',
             hydro = 'vatten',     
             US = 'US',
             World = 'Världen',
             percent = '% av totala',
             energy_consumed_increased = 'Totalt konsumerad energi ökade med',
             energy_consumed_decreased = 'Totalt konsumerad energi minskade med',
             energy_produced_increased = 'Totalt producerad energi ökade med',
             energy_produced_decreased = 'Totalt producerad energi minskade med',
             percent_title = 'Andel i procent från varje energislag',
             efficiency = 'verkningsgrad ( 38% verkningsgrad )'
            ) 

  return(txt)

}
            
