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
                     MZM_NSE = 'Nordsee',
                     MZM_CRB = 'Karibik',
                     MZM_PRG = 'Persischen Golf',
                     MZM_WAF = 'West Afrika',
                     MZM_WORLD = 'Welt',
                     MZM_FSU = 'Ehemaligen Sowjetunion',
                     MZM_EU0 = 'Europa (-UdSSR)',
                     MZM_EU1 = 'Europa (+UdSSR)',
                     MZM_OPEC = 'OPEC',
                     MZM_OPEC10 = 'OPEC-10',
                     MZM_NON_OPEC = 'Nicht-OPEC -',
                     MZM_OECD = 'OECD',
                     MZM_G7 = 'G7',
                     MZM_O5 = 'O5',
                     MZM_G75 = 'G7 + O5',
                     MZM_BELU = 'Belgien und Luxemburg',
                     MZM_TNA = 'Nordamerika',
                     MZM_TSCA = 'Süd & Zentralamerika',
                     MZM_TEE = 'Europa',
                     MZM_TME = 'Naher Osten',
                     MZM_TAF = 'Afrika',
                     MZM_TAP = 'Asien-Pazifik-Raum'
                    )
    country = country_list[[country]]
  }

  title_coal = 'Kohle'
  title_oil = 'Öl'
  title_gas = 'Gas'
  title_nuclear = 'Kernkraft'
  title_hydro = 'Wasserkraft'
  title_all = 'Energie Quellen'
  title_consumption	 = 'Verbrauch'
  title_production	 = 'Produktion'
  units_mto = 'Millionen Tonnen pro Jahr'
  units_mtoe = 'Millionen Tonnen Öl-Äquiv. pro Jahr'
  units_bbl = 'Millionen Barrel pro Tag'
  units_ft3 = 'Milliarden Kubikfuß pro Tag'
  units_m3 = 'Milliarden Kubikmeter pro Jahr'
  units_twh = 'Terawattstunden pro Jahr'
  units_joule	 = 'Exajoule pro Jahr'

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
             subtitle = 'Daten: BP Statistical Review 2012   Grafik: mazamascience.com',
             year = 'Jahr',
             units = text_units,
             consumption = 'Verbrauch',
             production = 'Förderung',
             imports = 'Einfuhren',
             exports = 'Ausfuhren',
             fromto = '2011',
             consumption_increased = 'Verbrauch stieg m',
             consumption_decreased = 'Verbrauch sank um',
             production_increased = 'Förderung stieg um',
             production_decreased = 'Förderung sank um',
             imports_increased = 'Einfuhren stiegen um',
             imports_decreased = 'Einfuhren sanken um',
             exports_increased = 'Ausfuhren stiegen um',
             exports_decreased = 'Ausfuhren sanken um',
             note_nodata = '* keine Daten verfügbar',
             note_minvalue = '* Mindestwert',
             msg_nodata = 'Keine Daten verfügbar.',
             country = country,
             earned = 'verdient',
             spent = 'ausgegeben',
             billion = 'milliarden',
             missing = 'keine Daten',
             net_0 = 'Netto Null',
             coal = 'Kohle',
             oil = 'Öl',
             gas = 'Gas',
             nuclear = 'Kern',
             hydro = 'Wasser',
             US = 'US',
             World = 'Welt',
             percent = 'Prozent der Summe',
             energy_consumed_increased = 'Energieverbrauch stieg um',
             energy_consumed_decreased = 'Energieverbrauch sank um',
             energy_produced_increased = 'Produzierte Energie stieg um',
             energy_produced_decreased = 'Produzierte Energie sank um',
             percent_title = 'Prozent aus jeder Quelle.',
             efficiency = '(38% Wirkungsgrad)'
            )

  return(txt)

}
            
