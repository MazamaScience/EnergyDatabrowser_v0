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
                     MZM_NSE='North Sea',
                     MZM_CRB='Caribbean',
                     MZM_PRG='Persian Gulf',
                     MZM_WAF='West Africa',
                     MZM_WORLD='World',
                     MZM_WORLD1='World (-OECD -FSU)',
                     MZM_FSU='Former Soviet Union',
                     MZM_EU0='Europe (-FSU)',
                     MZM_EU1='Europe (+FSU)',
                     MZM_EU2='Eurozone',
                     MZM_OPEC='OPEC',
                     MZM_OPEC10='OPEC-10',
                     MZM_GCC='Gulf Cooperation Council',
                     MZM_GECF='Gas Exporting Countries',
                     MZM_GECF11='GECF-11',
                     MZM_NON_OPEC='Non-OPEC',
                     MZM_OECD='OECD',
                     MZM_OECD1='OECD (-USA)',
                     MZM_G7='G7',
                     MZM_O5='O5',
                     MZM_G75='G7 + O5',
                     MZM_BELU='Belgium and Luxembourg',
                     MZM_TNA='North America',
                     MZM_TSCA='S. & Cent. America',
                     MZM_TEE='Europe',
                     MZM_TME='Middle East',
                     MZM_TAF='Africa',
                     MZM_TAP='Asia-Pacific'
                    )
    country = country_list[[country]]
  }

  title_coal = 'Coal'
  title_oil = 'Oil'
  title_gas = 'Nat. Gas'
  title_nuclear = 'Nuclear'
  title_hydro = 'Hydro'
  title_all = 'All'
  title_consumption = 'Consumption'
  title_production = 'Production'
  units_mto = 'million tonnes per year'
  units_mtoe = 'million tonnes oil equiv. per year'
  units_bbl = 'million barrels per day'
  units_ft3 = 'billion cubic feet per day'
  units_m3 = 'billion cubic meters per year'
  units_twh = 'Terawatt-hours per year'
  units_joule = 'Exajoules per year'

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
             subtitle = 'Data: BP Statistical Review 2012    Graphic: mazamascience.com',
             year = 'Year',
             units = text_units,
             consumption = 'Consumption',
             production = 'Production',
             imports = 'net Imports',
             exports = 'net Exports',
             fromto = '2011',
             consumption_increased = 'consumption increased by',
             consumption_decreased = 'consumption decreased by',
             production_increased = 'production increased by',
             production_decreased = 'production decreased by',
             imports_increased = 'imports increased by',
             imports_decreased = 'imports decreased by',
             exports_increased = 'exports increased by',
             exports_decreased = 'exports decreased by',
             note_nodata = '* no data available',
             note_minvalue = '* minimum value',
             msg_nodata = 'No data available',
             country = country,
             earned = 'earned',
             spent = 'spent',
             billion = 'billion',
             missing = 'no data',
             net_0 = 'net zero',
             coal = 'coal',
             oil = 'oil',
             gas = 'gas',
             nuclear = 'nuclear',
             hydro = 'hydro',
             US = 'US',
             World = 'World',
             percent = '% of total',
             energy_consumed_increased = 'Total energy consumed increased by',
             energy_consumed_decreased = 'Total energy consumed decreased by',
             energy_produced_increased = 'Total energy produced increased by',
             energy_produced_decreased = 'Total energy produced decreased by',
             percent_title = 'Percent contribution from each source.',
             efficiency = '( 38% efficiency )'
            )

  return(txt)

}
            
