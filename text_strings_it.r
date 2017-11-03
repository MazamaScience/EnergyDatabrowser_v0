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
                     MZM_NSE = "Mar del Nord",
                     MZM_CRB = "Caraibi",
                     MZM_PRG = "Golfo Persico",
                     MZM_WAF = "Africa occidentale",
                     MZM_WORLD = "Mondo",
                     MZM_FSU = "Ex Unione Sovietica",
                     MZM_EU0 = "Europa occidentale",
                     MZM_EU1 = "Europa e Eurasie",
                     MZM_OPEC = "OPEC",
                     MZM_OPEC10 = "OPEC-10",
                     MZM_NON_OPEC = "Non OPEC",
                     MZM_OECD = "OCSE",
                     MZM_G7 = "G7",
                     MZM_O5 = "O5",
                     MZM_G75 = "G7 + O5",
                     MZM_BELU = "Belgio e Lussemburgo",
                     MZM_TNA = "Nord America",
                     MZM_TSCA = "l'America cent. e sud",
                     MZM_TEE = "Europa",
                     MZM_TME = "Medio Oriente",
                     MZM_TAF = "Africa",
                     MZM_TAP = "Sud-Est Asiatico"
                    )
    country = country_list[[country]]
  }

  title_coal = "Carbone"
  title_oil = "Petrolio"
  title_gas = "Gas"
  title_nuclear = "Nucleare"
  title_hydro = "Idroelettrica"
  title_all = "Tutti"
  title_consumption = "Consumo"
  title_production = "Produzione"
  units_mto = "milioni di tonnellate l'anno"
  units_mtoe = "milioni di tonnellate equiv. di petrolio all'anno"
  units_bbl = "milioni di barili al giorno"
  units_ft3 = "miliardi di piedi cubici al giorno"
  units_m3 = "miliardi di metri cubi all'anno"
  units_twh = "terawattore ore all'anno"
  units_joule = "Exajoules all'anno"

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
             subtitle = "Dati: BP Statistical Review 2012   Grafica: mazamascience.com",
             year = "Anno",
             units = text_units,
             consumption = "Consumo",
             production = "Produzione",
             imports = "Importazioni",
             exports = "Esportazioni",
             fromto = "2011",
             consumption_increased = "il consumo è aumentato del",
             consumption_decreased = "il consumo è diminuito del",
             production_increased = "la produzione è aumentata del",
             production_decreased = "la produzione è diminuita del",
             imports_increased = "le importazioni sono aumentate del",
             imports_decreased = "le importazioni sono diminuite del",
             exports_increased = "le esportazioni sono aumentate del",
             exports_decreased = "le esportazioni sono diminuite del",
             note_nodata = "* dati non disponibili",
             note_minvalue = "* valore minimo",
             msg_nodata = "Dati non disponibili",
             country = country,
             earned = "guadagnato",
             spent = "esaurito",
             billion = "miliardi",
             missing = "nessun dato",
             net_0 = "netto pari a zero",
             coal = "carbone",
             oil = "olio",
             gas = "gas",
             nuclear = "nucleare",
             hydro = "idroelettrica",
             US = "Stati Uniti",
             World = "Mondo",
             percent = "% del totale",
             energy_consumed_increased = "Consumo totale di energia è aumentato del",
             energy_consumed_decreased = "Consumo total di energia è diminuito del",
             energy_produced_increased = "Produzione totale di energia è aumentata del",
             energy_produced_decreased = "Produzione total di energia è diminuito del",
             percent_title = "Percentuale contributo di ciascuna fonte.",
             efficiency = "(38% di efficienza)"
            )

  return(txt)

}
            
