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
                     MZM_NSE = 'Noordzee',
                     MZM_CRB = 'Caribisch gebied',
                     MZM_PRG = 'Perzische Golf',
                     MZM_WAF = 'West-Afrika',
                     MZM_WORLD = 'Wereld',
                     MZM_FSU = 'Voormalige Sovjet-Unie',
                     MZM_EU0 = 'Europa (-Sovjet-Unie)',
                     MZM_EU1 = 'Europa (+ Sovjet-Unie)',
                     MZM_OPEC = 'OPEC',
                     MZM_OPEC10 = 'OPEC-10',
                     MZM_NON_OPEC = 'Niet-OPEC',
                     MZM_OECD = 'OESO',
                     MZM_G7 = 'G7',
                     MZM_O5 = 'O5',
                     MZM_G75 = 'G7 + O5',
                     MZM_BELU = 'België en Luxemburg',
                     MZM_TNA = 'Noord-Amerika',
                     MZM_TSCA = 'S. & Cent. Amerika',
                     MZM_TEE = 'Europa',
                     MZM_TME = 'Midden-Oosten',
                     MZM_TAF = 'Afrika',
                     MZM_TAP = 'Azië & Stille Oceaan'
                    )
    country = country_list[[country]]
  }

  title_coal = 'Kolen'
  title_oil = 'Olie'
  title_gas = 'Gas'
  title_nuclear = 'Kern'
  title_hydro = 'Waterkracht'
  title_all = "Alle"
  title_consumption = "Verbruik"
  title_production = "Productie"
  units_mto = 'miljoen ton per jaar'
  units_mtoe = 'miljoen ton olie-equiv. per jaar'
  units_bbl = 'miljoen vaten per dag'
  units_ft3 = 'miljard kubieke voet per dag'
  units_m3 = 'miljard kubieke meter per jaar'
  units_twh = 'terawatt uur per jaar'
  units_joule = "Exajoule per jaar"

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
             subtitle = 'Data: BP Statistical Review 2012   Graphic: mazamascience.com',
             year = 'Jaar',
             units = text_units,
             consumption = 'Consumptie',
             production = 'Productie',
             imports = 'Invoer',
             exports = 'Uitvoer',
             fromto = '2011',
             consumption_increased = "verbruik toegenomen met",
             consumption_decreased = "verbruik daalde met",
             production_increased = 'productie toegenomen met',
             production_decreased = 'productie daalde met',
             imports_increased = 'invoer toegenomen met',
             imports_decreased = 'invoer daalde met',
             exports_increased = 'uitvoer toegenomen met',
             exports_decreased = 'uitvoer daalde met',
             note_nodata = '* geen gegevens beschikbaar',
             note_minvalue = '* minimum waarde',
             msg_nodata = 'Geen gegevens beschikbaar.',
             country = country,
             earned = 'verdiend',
             spent = 'besteed',
             billion = 'miljard',
             missing = 'geen gegevens',
             net_0 = 'netto nul',
             coal = "kolen",
             oil = "olie",
             gas = "gas",
             nuclear = 'kern',
             hydro = 'water',
             US = 'VS',
             World = 'Wereld',
             percent = "% van de totale",
             energy_consumed_increased = "Totale energieverbruik toegenomen door",
             energy_consumed_decreased = "Totale energieverbruik daalde met",
             energy_produced_increased = "Totaal geproduceerde energie steeg met",
             energy_produced_decreased = "Totaal geproduceerde energie daalde met",
             percent_title = "Percentage bijdrage van elke bron.",
             efficiency = "(38% rendement)"
            )

  return(txt)

}
            
