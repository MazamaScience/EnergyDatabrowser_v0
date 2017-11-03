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
                     MZM_NSE='Северное море',
                     MZM_CRB='Карибское море',
                     MZM_PRG='Персидский залив',
                     MZM_WAF='Западная Африка',
                     MZM_WORLD='Весь мир',
                     MZM_FSU='Страны бывшего СССР',
                     MZM_EU0='Европа (-ex-СССР)',
                     MZM_EU1='Европа (+ex-СССР)',
                     MZM_OPEC='ОПЕК',
                     MZM_OPEC10='ОПЕК10',
                     MZM_GCC='Страны ССАГПЗ',
                     MZM_GECF='Страны ФСЭГ',
                     MZM_GECF11='Страны ФСЭГ11',
                     MZM_NON_OPEC='Все, кроме ОПЕК',
                     MZM_OECD='ОЭСР',
                     MZM_G7='G7',
                     MZM_O5='O5',
                     MZM_G75='TXT_75',
                     MZM_BELU='Бельгия и Люксембург',
                     MZM_TNA='Северная Америка',
                     MZM_TSCA='Южная и Центральная Америка',
                     MZM_TEE='Европа',
                     MZM_TME='Ближний Восток',
                     MZM_TAF='Африка',
                     MZM_TAP='Азия и Тихий Океан'
                    )
    country = country_list[[country]]
  }

  title_coal = 'Уголь'
  title_oil = 'Нефть'
  title_gas = 'Природный газ'
  title_nuclear = 'АЭС'
  title_hydro = 'ГЭС'
  title_all = 'Все'
  title_consumption = 'Потребление'
  title_production = 'Производство'
  units_mto = 'млн. тонн в год year'
  units_mtoe = 'млн. тонн нефтяного экв. в год'
  units_bbl = 'млн. баррелей в день'
  units_ft3 = 'фут3'
  units_m3 = 'м3'
  units_twh = 'Вт·ч'
  units_joule = 'ДжOULE'

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
             subtitle = 'Данные: Статистический отчёт компании BP за 2012 г.    Оформление: mazamascience.com',
             year = 'год',
             units = text_units,
             consumption = 'Потребление',
             production = 'Производство',
             imports = 'Импорт',
             exports = 'Экспорт',
             fromto = '2011',
             consumption_increased = 'потребление возросло на',
             consumption_decreased = 'потребление упало на',
             production_increased = 'производство возросло на',
             production_decreased = 'производство упало на',
             imports_increased = 'импорт возрос на',
             imports_decreased = 'импорт упал на',
             exports_increased = 'экспорт возрос на',
             exports_decreased = 'экспорт упал на',
             note_nodata = '* нет данных',
             note_minvalue = '* не меньше',
             msg_nodata = 'Нет данных',
             country = country,
             earned = 'получено',
             spent = 'потрачено',
             billion = 'млрд.',
             missing = 'нет данных',
             net_0 = 'баланс',
             coal = 'Уголь',
             oil = 'Нефть',
             gas = 'Газ',
             nuclear = 'АЭС',
             hydro = 'TT_HYDRO',
             US = 'США',
             World = 'Весь мир',
             percent = 'PERCENT от общего',
             energy_consumed_increased = 'Потребление энергоресурсов возросло на',
             energy_consumed_decreased = 'Потребление энергоресурсов упало на',
             energy_produced_increased = 'Производство энергоресурсов возросло на',
             energy_produced_decreased = 'Производство энергоресурсов упало на',
             percent_title = '% от общего_TITLE',
             efficiency = '( эффективность 38% )'
            )

  return(txt)

}
            
