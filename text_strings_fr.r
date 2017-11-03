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
                     MZM_NSE = "Mer du Nord",
                     MZM_CRB = "Caraïbes",
                     MZM_PRG = "Golfe Persique",
                     MZM_WAF = "Afrique de l'Ouest",
                     MZM_WORLD = "Monde",
                     MZM_FSU = "Ex-Union soviétique",
                     MZM_EU0 = "Europe occidentale",
                     MZM_EU1 = "Europe et Eurasie",
                     MZM_OPEC = "OPEP",
                     MZM_OPEC10 = "OPEP10",
                     MZM_NON_OPEC = "Non-OPEP",
                     MZM_OECD = "OCDE",
                     MZM_G7 = "G7",
                     MZM_O5 = "O5",
                     MZM_G75 = "G7 + O5",
                     MZM_BELU = "Belgique et Luxembourg",
                     MZM_TNA = "Amérique du Nord",
                     MZM_TSCA = "Amérique du Sud et Centrale.",
                     MZM_TEE = "Europe et Eurasie",
                     MZM_TME = "Moyen-Orient",
                     MZM_TAF = "Afrique",
                     MZM_TAP = "Asie-Pacifique"
                    )
    country = country_list[[country]]
  }

  title_coal = "Charbon"
  title_oil = "Pétrole"
  title_gas = "Gaz"
  title_nuclear = "Nucléaire"
  title_hydro = "Hydro"
  title_all = "Tous"
  title_consumption = "Consommation"
  title_production = "Production"
  units_mto = "millions de tonnes par an"
  units_mtoe = "millions de tonnes équiv. pétrole par an"
  units_bbl = "millions de barils par jour"
  units_ft3 = "milliards de pieds cubes par jour"
  units_m3 = "milliards de mètres cubes par an"
  units_twh = "Térawattheures par an"
  units_joule = "Exajoules par an"

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
             subtitle = "Data: BP Statistical Review 2012   Graphique: mazamascience.com",
             year = "Année",
             units = text_units,
             consumption = "Consommation",
             production = "Production",
             imports = "Importations",
             exports = "Exportations",
             fromto = "2011",
             consumption_increased = "la consommation a augmenté de",
             consumption_decreased = "la consommation a diminué de",
             production_increased = "la production a augmenté de",
             production_decreased = "la production a diminué de",
             imports_increased = "les importations ont augmenté de",
             imports_decreased = "les importations ont diminué de",
             exports_increased = "les exportations ont augmenté de",
             exports_decreased = "les exportations ont diminué de",
             note_nodata = "* pas de données disponibles",
             note_minvalue = "* valeur minimale",
             msg_nodata = "Pas de données disponibles.",
             country = country,
             earned = "gagné",
             spent = "passé",
             billion = "milliards de dollars",
             missing = "pas de données",
             net_0 = "nette zéro",
             coal = "charbon",
             oil = "pétrole",
             gas = "gaz",
             nuclear = "nucléaire",
             hydro = "hydro",
             US = "États-Unis",
             World = "Monde",
             percent = "% du total",
             energy_consumed_increased = "consommation d'énergie a augmenté de",
             energy_consumed_decreased = "consommation d'énergie a diminué de",
             energy_produced_increased = "l'énergie produite a augmenté de",
             energy_produced_decreased = "l'énergie produite a diminué de",
             percent_title = "Pour cent de la contribution de chaque source.",
             efficiency = "(38% d'efficacité)"
            )

  return(txt)

}
            
