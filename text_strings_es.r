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
                     MZM_NSE = 'Mar del Norte',
                     MZM_CRB = 'Caribe',
                     MZM_PRG = 'Golfo Pérsico',
                     MZM_WAF = 'África del Oeste',
                     MZM_WORLD = 'Mundo',
                     MZM_FSU = 'Antigua Unión Soviética',
                     MZM_EU0 = 'Europa (-AUS)',
                     MZM_EU1 = 'Europa (+AUS)',
                     MZM_OPEC = 'OPEP',
                     MZM_OPEC10 = 'OPEP-10',
                     MZM_NON_OPEC = 'No OPEP',
                     MZM_OECD = 'OCDE',
                     MZM_G7 = 'G7',
                     MZM_O5 = 'O5',
                     MZM_G75 = 'G7 + O5',
                     MZM_BELU = 'Bélgica y Luxemburgo',
                     MZM_TNA = 'América del Norte',
                     MZM_TSCA = 'S. & Cent. América',
                     MZM_TEE = 'Europa',
                     MZM_TME = 'Oriente Medio',
                     MZM_TAF = 'África',
                     MZM_TAP = 'Asia y el Pacífico'
                    )
    country = country_list[[country]]
  }

  title_coal = 'Carbón'
  title_oil = 'Petróleo'
  title_gas = 'Gas'
  title_nuclear = 'Nuclear'
  title_hydro = 'Hidroeléctrica'
  title_all	 = 'Todas'
  title_consumption	 = 'Consumo'
  title_production	 = 'Producción'
  units_mto = 'millones de toneladas por año'
  units_mtoe = 'millones de toneladas equiv. de petróleo por año'
  units_bbl = 'millones de barriles por día'
  units_ft3 = 'mil millones de pies cúbicos por día'
  units_m3 = 'mil millones de metros cúbicos por año'
  units_twh = 'teravatios hora por año'
  units_joule	 = 'Exajulios por año'

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
             subtitle = 'Datos: BP Statistical Review 2012   Gráfico: mazamascience.com',
             year = 'Año',
             units = text_units,
             consumption = 'Consumo',
             production = 'Producción',
             imports = 'Importaciones',
             exports = 'Exportaciones',
             fromto = '2011',
             consumption_increased	 = 'el consumo aumentó',
             consumption_decreased	 = 'el consumo disminuyó',
             production_increased = 'la producción aumentó',
             production_decreased = 'la producción disminuyó',
             imports_increased = 'las importaciones aumentaron',
             imports_decreased = 'las importaciones disminuyeron',
             exports_increased = 'las exportaciones aumentaron',
             exports_decreased = 'las exportaciones disminuyeron',
             note_nodata = '* no se dispone de datos',
             note_minvalue = '* valor mínimo',
             msg_nodata = 'No hay datos disponibles.',
             country = country,
             earned = 'ganado',
             spent = 'gastado',
             billion = 'mil millones',
             missing = 'sin datos',
             net_0 = 'neto de cero',
             coal = 'carbón',
             oil = 'petróleo',
             gas = 'gas',
             nuclear = 'nuclear',
             hydro = 'hidroeléctrica',
             US = 'EE.UU.',
             World = 'Mundo',
             percent	 = '% del total',
             energy_consumed_increased	 = 'El total de energía consumida aumentó un',
             energy_consumed_decreased	 = 'El total de energía consumida disminuyó un',
             energy_produced_increased	 = 'El total de energía producida aumentó un',
             energy_produced_decreased	 = 'El total de energía producida disminuyó un',
             percent_title	 = 'Porcentaje de contribución de cada fuente.',
             efficiency	 = '(38% de eficiencia)'
            )

  return(txt)

}
            
