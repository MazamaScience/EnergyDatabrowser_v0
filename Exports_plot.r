############################################################
# Exports_plot
#
# y - vector of years
# p - vector of annual production amounts

Exports_plot <- function(countryID='MZM_WORLD',countrylist=c('BP_WORLD'),
                         datasource='BP_2012',fuel='oil',units='mtoe',
                         overlay='MZM_NONE',yscalecode='auto',showmap='M',
                         special_years=c(),special_x=1975,special_y=90,special_text='',
                         firstyear=1965,lastyear=2011,txt=list()) {

  # Default plotting parameters
  par(las=1, lend='butt')

  # set up map colors
  color_export_map = '#22CCAA'  
  color_import_map = '#EE5555'
  color_missing_map = 'gray90'
  color_net_0_map = '#AAAAB9'

  # set up plot colors
  color_exports = '#00BB99'  
  color_imports = 'firebrick2'  #EE2C2C
  color_consumption = 'black'
  color_production = 'gray80'
  color_production_decades = 'gray75'
  color_guide_lines = 'gray95'
  color_overlay = 'black'
  color_yscalecode = 'black'

  # set up text colors
  color_labels_text = 'black'
  color_production_text = 'gray40'
  color_consumption_text = 'black'
  color_export_text = '#008050'  
  color_import_text = 'firebrick3'  
  color_overlay_text = 'black'
  color_yscalecode_text = 'black'
  color_missing_text = 'gray80'
  color_net_0_text = '#777799'

  color_map_label_1 = 'black'
  color_map_label_2 = 'black'

  include_plot_label_1 = TRUE  # Consumption
  include_plot_label_2 = TRUE  # Production
  include_plot_label_3 = FALSE # Exports
  include_plot_label_4 = FALSE # Imports

  include_map_label_1 = FALSE
  include_map_label_2 = FALSE

  yscale = 0
  divisor = 1
  # set up defaults for each datasource
  if (fuel == 'coal') {

    # Only 'mtoe' units are available for Coal
    if (units == 'mtoe') {
      divisor = 1
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 600 }
      if (yscalecode == 'world') { yscale = 3500 }
    } else if (units == 'joule') {
      # NOTE:  1 mtoe ~= 0.042 exajoules
      divisor = 1/0.042
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 25 }
      if (yscalecode == 'world') { yscale = 150 }
    }

  } else if (fuel == 'oil') {

    if (units == 'bbl') {
      divisor = 1000
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 22 }
      if (yscalecode == 'world') { yscale = 85 }
    } else if (units == 'mtoe') {
      divisor = 1
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 1000 }
      if (yscalecode == 'world') { yscale = 4000 }
    } else if (units == 'joule') {
      # NOTE:  1 mtoe ~= 0.042 exajoules
      divisor = 1/0.042
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 40 }
      if (yscalecode == 'world') { yscale = 170 }
    }

  } else if (fuel == 'gas') {

    if (units == 'ft3') {
      divisor = 1
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 65 }
      if (yscalecode == 'world') { yscale = 300 }
    } else if (units == 'mtoe') {
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 650 }
      if (yscalecode == 'world') { yscale = 3000 }
    } else if (units == 'm3') {
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 650 }
      if (yscalecode == 'world') { yscale = 3000 }
    } else if (units == 'joule') {
      # NOTE:  1 mtoe ~= 0.042 exajoules
      divisor = 1/0.042
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 25 }
      if (yscalecode == 'world') { yscale = 120 }
    }

  } else if (fuel == 'nuclear') {

    if (units == 'twh') {
      divisor = 1
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 800 }
      if (yscalecode == 'world') { yscale = 3000 }
    } else if (units == 'mtoe') {
      divisor = 1
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 200 }
      if (yscalecode == 'world') { yscale = 700 }
    } else if (units == 'joule') {
      # NOTE: 1 Terawatt-hour = 0.0036 Exajoules
      divisor = 1 / 0.0036
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 3 }
      if (yscalecode == 'world') { yscale = 12 }
    }

  } else if (fuel == 'hydro') {

    if (units == 'twh') {
      divisor = 1
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 300 }
      if (yscalecode == 'world') { yscale = 3000 }
    } else if (units == 'mtoe') {
      divisor = 1
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 75 }
      if (yscalecode == 'world') { yscale = 750 }
    } else if (units == 'joule') {
      # NOTE: 1 Terawatt-hour = 0.0036 Exajoules
      divisor = 1 / 0.0036
      if (yscalecode == 'auto') { yscale = 0 }
      if (yscalecode == 'us') { yscale = 2 }
      if (yscalecode == 'world') { yscale = 12 }
    }

  } else {

    divisor = 1

  }

  # For testing the EIA data
  if (datasource == 'EIA_2008' && fuel == 'oil') {
    divisor = 1000
  }

  # Defaults for named labels
  map_label_1 = ''
  map_label_2 = ''
  special_note = ''
  warning_text = ''

  # Set up arrays of zeroes and NA's
  y = c(firstyear:lastyear)
  y_p = y + 0.5
  y_p1 = y + 1.0
  y_m = y - 0.5
  zeroes = y * 0.0
  missing = y * NA
  n = lastyear - firstyear + 1

  # Create the production and consumption data frames:
  # Production data exist for all fuel types except 'nuclear' and 'hydro' where BP assumes production = consumption

  if (units == 'joule') {
    if (fuel == 'nuclear' || fuel == 'hydro') {
      filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_consumption_twh.csv',sep='',collapse='')
    } else {
      filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_consumption_mtoe.csv',sep='',collapse='')
    }
  } else {
    filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_consumption_',units,'.csv',sep='',collapse='')
  }

  c1 = read.csv(file=filename,skip=6,na.strings=c('na'))
  c4 = c1 / divisor

  if (fuel == 'nuclear' || fuel == 'hydro') {
    p4 = c4
  } else {
    if (units == 'joule') {
      filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_production_mtoe.csv',sep='',collapse='')
    } else {
      filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_production_',units,'.csv',sep='',collapse='')
    }
    p1 = read.csv(file=filename,skip=6,na.strings=c('na'))
    p4 = p1 / divisor
  }

  # For every country in the list
  # 1) production is zero if not listed (BP is keeping track of all the major producers.)
  # 2) consumption is zero if not listed (We know it won't be negative and we'd at least like to calculate a minimum.
  #    But we keep track of countries with missing consumption data because it is probably growing and we'd like to 
  #    let folks know we're only displaying a minimum here.)

  production_data_missing = FALSE
  consumption_data_missing = FALSE
  production = zeroes       # total production for all countries in the list
  consumption = zeroes      # total consumption for all countries in the list
  exportable_oil = zeroes   # total exportable oil for all countries in the list
  ei_col = countrylist
  country_index = 0
  for (country in countrylist) {
    country_consumption_data_missing = FALSE
    country_production_data_missing = FALSE
    country_index = country_index + 1
    # NOTE:  R will do 'partial matches' of "YE" to "YEAR".
    # NOTE:  To avoid this, we need to use the more complicated match() method 
    ###if (is.null(p4[[country]])) {
    ###if (is.null(p4[,match(country,names(p4))])) {
    # NOTE:  R 2.14 generates a "no columns selected" error with the above.
    # NOTE:  So we're trying something new
    if (!(country %in% names(p4))) {
      country_production_data_missing = TRUE  
      production_data_missing = TRUE
      p5 = zeroes
    } else {
      p5 = as.numeric(as.character(p4[,match(country,names(p4))]))
    }
    # NOTE:  R will do 'partial matches' of "YE" to "YEAR".
    # NOTE:  To avoid this, we need to use the more complicated match() method 
    ###if (is.null(c4[[country]])) {
    ###if (is.null(c4[,match(country,names(c4))])) {
    # NOTE:  R 2.14 generates a "no columns selected" error with the above.
    # NOTE:  So we're trying something new
    if (!(country %in% names(c4))) {
      country_consumption_data_missing = TRUE  
      consumption_data_missing = TRUE
      c5 = zeroes
    } else {
      c5 = as.numeric(as.character(c4[,match(country,names(c4))]))
    }
    production = production + p5
    consumption = consumption + c5
    national_export = pmax(zeroes,(p5-c5),na.rm=TRUE)  # Assume NA means 'zero' for national_export
    exportable_oil = exportable_oil + national_export

    if (country_production_data_missing && country_consumption_data_missing) {
      ei_col[country_index] = c(color_missing_map)
      map_label_2 = txt$missing
      include_map_label_2 = TRUE
      color_map_label_2 = color_missing_text
    } else if (is.na(p5[n]) || is.na(c5[n]) || country_consumption_data_missing) {
      ei_col[country_index] = c(color_export_map)
    } else {
      # If production is within +/- 0.5% of consumption, color this country 'net_0'
      if (p5[n] > (c5[n] * 1.005)) {
        ei_col[country_index] = c(color_export_map)
      } else if (c5[n] > (p5[n] * 1.005)) {
        ei_col[country_index] = c(color_import_map)
      } else {
        ei_col[country_index] = c(color_net_0_map)
        map_label_1 = txt$net_0
        include_map_label_1 = TRUE
        color_map_label_1 = color_net_0_text
      }
    }

    # Override ei_col for BP 'other' groupings which have totals but no inidvidual country data.
    bp_other_groups = c('BP_OSCA','BP_OEE','BP_OME','BP_OAF','BP_OAP')
    if (country %in% bp_other_groups) {
      ei_col[country_index] = c(color_missing_map)
      map_label_2 = txt$missing
      include_map_label_2 = TRUE
      color_map_label_2 = color_missing_text
    }
    
    # Override ei_col for 'nuclear' and 'hydro'.  Color only countries with non-zero, non-missing production.
    # (Otherwise everything ends up with color_net_0_map.)
    if (fuel == 'nuclear' || fuel == 'hydro') {
      if (p5[n] >= 0.001) { # 0.001 works for units of mtoe, twh and joules
        ei_col[country_index] = c(color_export_map)
      } else {
        ei_col[country_index] = c(color_missing_map)
      }
      # Now set the labeling information
      if (fuel == 'nuclear') {
        map_label_1 = txt$nuclear
        map_label_2 = txt$missing
      } else {
        map_label_1 = txt$hydro
        map_label_2 = txt$missing
      }
      include_map_label_1 = TRUE
      include_map_label_2 = TRUE
      color_map_label_1 = color_export_text
      color_map_label_2 = color_missing_text
    }
 
  } # End of "for (country in countrylist)" loop

  if (country_production_data_missing && country_consumption_data_missing && length(countrylist) == 1) {
    warning_text = txt$msg_nodata
  }

  # Now that we have created the ei_col list of colors for all countries involved we
  # need to check to see if this is a special grouping that has it's own row in the 
  # BP data files.  In such a case we use the BP_~ row instead of our sum as the sum 
  # will have missing values if even one small nation has missing values.  The BP 
  # special groupings do not have missing values and we'll just assume that BP did 
  # things right.
                
  # The following groups should be available in all BP data files
  # BP_TNA   Total North America
  # BP_OSCA  Other South & Central America
  # BP_TSCA  Total South & Central America
  # BP_OEE   Other Europe & Eurasia
  # BP_TEE   Total Europe & Eurasia
  # BP_OME   Other Middle East
  # BP_TME   Total Middle East
  # BP_OAF   Other Africa
  # BP_TAF   Total Africa
  # BP_OAP   Other Asia-Pacific
  # BP_TAP   Total Asia-Pacific
  # BP_WORLD World
  # BP_OECD  OECD
  # BP_FSU   Former Soviet Untion

  special_groups = c('MZM_TNA','MZM_OSCA','MZM_TSCA','MZM_OEE','MZM_TEE','MZM_OME','MZM_TME',
                     'MZM_OAF','MZM_TAF','MZM_OAP','MZM_TAP','MZM_WORLD','MZM_OECD','MZM_FSU')
  MZM_to_BP = list('MZM_TNA'='BP_TNA',
                   'MZM_OSCA'='BP_OSCA',
                   'MZM_TSCA'='BP_TSCA',
                   'MZM_OEE'='BP_OEE',
                   'MZM_TEE'='BP_TEE',
                   'MZM_OME'='BP_OME',
                   'MZM_TME'='BP_TME',
                   'MZM_OAF'='BP_OAF',
                   'MZM_TAF'='BP_TAF',
                   'MZM_OAP'='BP_OAP',
                   'MZM_TAP'='BP_TAP',
                   'MZM_WORLD'='BP_WORLD',
                   'MZM_OECD'='BP_OECD',
                   'MZM_FSU'='BP_FSU')

  if ( countryID %in% special_groups ) {
    consumption_data_missing = FALSE
    BP_ID = MZM_to_BP[[countryID]]
    if (is.null(p4[[BP_ID]])) {
      production = zeroes
    } else {
      production = as.numeric(as.character(p4[[BP_ID]]))
    }
    if (is.null(c4[[BP_ID]])) {
      consumption_data_missing = TRUE
      consumption = zeroes
    } else {
      consumption = as.numeric(as.character(c4[[BP_ID]]))
    }
  }

  # Create the special_note
  if (consumption_data_missing) {
    if (length(countrylist) == 1) {
      special_note = txt$note_nodata
    } else {
      special_note = txt$note_minvalue
    }
  }

  # Create a masks to identify decades and hilighted years
  #           5 6 7 8 970 1 2 3 4 5 6 7 8 980 1 2 3 4 5 6 7 8 990 1 2 3 4 5 6 7 8 900 1 2 3 4 5 6 7 8 910 1
  decades = c(0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1)
  ### SAVE ### special_years = c(1980,1981,1982,1983,1992)
  label_years = zeroes
  for (year in special_years) {
    year_index = year - 1964
    label_years[year_index] = 1
  }

  # Line width must be just enough to cause histogram bars to overlap.
  # This will depend upon the width of the graphic.
  lwd = 10

  # Now for the actual plot

  exports = production - consumption     # Positive or negative
  exports_0 = pmax(exports, exports * 0) # Positive or zero only

  if (yscale == 0) {
    pcmax = pmax(production,consumption,na.rm=FALSE)
    ylo = min(exports,na.rm=TRUE)
    ylo = min(ylo,0)
    yhi = max(pcmax,na.rm=TRUE)
    yscale = max(abs(ylo),yhi)
    if (yscale == 0) { yscale = 1 }
  }
  
  # The production graph goes on the bottom, shaded by decade
  plot(production ~ y_p, axes=FALSE, type='h', lwd=lwd, col=color_production, 
                         xlim=c(1954,2014), ylim=c(-1.0*yscale,yscale),
                         main='', xlab='', ylab='')
  axis(1)
  axis(4,las=0)
  points(production*decades ~ y_p, type='h', lwd=lwd, col=color_production_decades)

  # Add user selected years associated with a label
  ### SAVE ### points(production*label_years ~ y_p, type='h', lwd=lwd, col='gray50')

  # Add exports and imports on top (for the 'world' plot exportable_oil)
  if (countryID == 'MZM_WORLD') {
    points(exportable_oil ~ y_p, type='h', lwd=lwd, col=color_exports)
  } else {
    # The variable with both pos + neg values is plotted first in the 'import' color.
    # Then the variable with pos-only values is overlayed in the 'export' color.
    if (!consumption_data_missing || length(countrylist) > 1) {
      points(exports ~ y_p, type='h', lwd=lwd, col=color_imports)
      ### SAVE ### points(exports*label_years ~ y_p, type='h', lwd=lwd, col='firebrick4')
      points(exports_0 ~ y_p, type='h', lwd=lwd, col=color_exports)
      ### SAVE ### points(exports_0*label_years ~ y_p, type='h', lwd=lwd, col='#44DDAA')
    }
  }

  # Add year guides (thin gray lines that mark the decades)
  guide_years = c(1970,1980,1990,2000,2010)
  guide_indices = c(6,16,26,36,46)
  guides = production[guide_indices]
  points(guides ~ guide_years, type='h', lwd=2, col=color_guide_lines)
  guides = exports[guide_indices]
  points(guides ~ guide_years, type='h', lwd=2, col=color_guide_lines)

  # Add the overlay line
  if (overlay != 'MZM_NONE') {
    overlay_consumption = as.numeric(as.character(c4[[overlay]]))
    points(overlay_consumption ~ y, type='s', lwd=1, col=color_overlay)
    points(overlay_consumption ~ y_p1, type='S', lwd=1, col=color_overlay)
  }

  # Add the consumption line for the 'yscalecode'
  if (yscalecode == 'us') {
    yscalecode_consumption = c4[['US']]
    points(yscalecode_consumption ~ y, type='s', lwd=1, col=color_yscalecode)
    points(yscalecode_consumption ~ y_p1, type='S', lwd=1, col=color_yscalecode)
  } else if (yscalecode == 'world') {
    yscalecode_consumption = c4[['BP_WORLD']]
    points(yscalecode_consumption ~ y, type='s', lwd=1, col=color_yscalecode)
    points(yscalecode_consumption ~ y_p1, type='S', lwd=1, col=color_yscalecode)
  } else {
    noop = 1
  }

  # The consumption line goes on top
  if (!consumption_data_missing || length(countrylist) > 1) {
    points(consumption ~ y, type='s', lwd=3, col=color_consumption)
    points(consumption ~ y_p1, type='S', lwd=3, col=color_consumption)
  }

  # Lastly, calculate labeling information
  height = exports[n]
  if (abs(exports[n-1]) > 0) {
    if (countryID == 'MZM_WORLD') {
      pct_chg = 100 * (production[n] - production[n-1]) / abs(production[n-1])
    } else {
      pct_chg = 100 * (exports[n] - exports[n-1]) / abs(exports[n-1])
    }

    if (is.na(pct_chg)) {
      pct_chg_string = '--'
    } else {
      pct_chg_string = as.character(abs(pct_chg))
      if (pct_chg >= 100) {
        pct_chg_string = strtrim(pct_chg_string,5)
      } else if (pct_chg >= 10) {
        pct_chg_string = strtrim(pct_chg_string,4)
      } else {
        pct_chg_string = strtrim(pct_chg_string,3)
      }
    }
  } else {
    pct_chg_string = '--'
  }

  # Exports
  if (height > 0) {
    if (exports[n] > exports[n-1] ) {
      if (consumption_data_missing && length(countrylist) == 1) {
        ei_text = txt$production_increased
      } else {
        ei_text = txt$exports_increased
      }
    } else {
      if (consumption_data_missing && length(countrylist) == 1) {
        ei_text = txt$production_decreased
      } else {
        ei_text = txt$exports_decreased
      }
    }

  # Imports
  } else {
    if (exports[n] > exports[n-1] ) {
      ei_text = txt$imports_decreased
    } else {
      ei_text = txt$imports_increased
    }
  }

  # Special case for the entire world
  if (countryID == 'MZM_WORLD') {
    if (production[n] > production[n-1] ) {
      ei_text = txt$production_increased
    } else {
      ei_text = txt$production_decreased
    }
  }

  # Override the titles for 'nuclear' and 'hydro' where BP assumes production = consumption
  if (fuel == 'nuclear' || fuel == 'hydro') {

    pct_chg = 100 * (production[n] - production[n-1]) / abs(production[n-1])
    if (is.na(pct_chg)) {
      pct_chg_string = '--'
    } else {
      pct_chg_string = as.character(abs(pct_chg))
      if (pct_chg >= 100) {
        pct_chg_string = strtrim(pct_chg_string,5)
      } else if (pct_chg >= 10) {
        pct_chg_string = strtrim(pct_chg_string,4)
      } else {
        pct_chg_string = strtrim(pct_chg_string,3)
      }
    }

    if (production[n] > production[n-1] ) {
      ei_text = txt$production_increased
    } else {
      ei_text = txt$production_decreased
    }

  }

  # Add the title
  if (showmap == 'M') {
    main1_line = 3
    main_line = 1.5
  } else {
    main1_line = 5
    main_line = 3
  }
  title(main=txt$main1,line=main1_line,cex.main=2.0,xpd=NA)
  label = paste(txt$fromto,ei_text,pct_chg_string,'%')
  title(main=label,line=main_line,xpd=NA)
  # Add the mazamascience.com and datasource attribution
  title(sub=txt$subtitle,line=2.5,family='Times',col=color_labels_text,xpd=NA)


  # Add the axis labels
  mtext(text=txt$year,side=1,line=0.8,cex=1.0,adj=0,xpd=TRUE)
  mtext(text=txt$units,side=4,line=3.0,cex=1.2,las=0,xpd=NA)
  if (units == 'mtoe') {
    if (fuel == 'nuclear' | fuel == 'hydro') {
      mtext(text=txt$efficiency,side=4,line=4.5,cex=1.0,las=0,xpd=NA)
    }
  }

  # Add a legend as colored text labels on the left
  if (showmap == 'M') {
    label_size = 1.2 
  } else {
    label_size = 1.2
  }
  if (showmap == 'M') {
    if (include_map_label_1) {
      mtext(text=map_label_1,col=color_map_label_1,side=3,line=4,adj=-0.1,cex=label_size,xpd=TRUE)
    }
    if (include_map_label_2) {
      mtext(text=map_label_2,col=color_map_label_2,side=3,line=3,adj=-0.1,cex=label_size,xpd=TRUE)
    }
  }
  text(x=1952,y=1.0*yscale,pos=4,lab=txt$consumption,col=color_consumption_text,cex=label_size,font=2,xpd=TRUE)
  text(x=1952,y=0.80*yscale,pos=4,lab=txt$production,col=color_production_text,cex=label_size,font=2,xpd=TRUE)

  # Only include the import/export labels in some circumstances
  if (fuel != 'nuclear' && fuel != 'hydro') {
    if (showmap == 'M') {
      include_plot_label_3 = TRUE
      include_plot_label_4 = TRUE
    } else {
      if (countryID == 'MZM_WORLD') {
        include_plot_label_3 = TRUE
        include_plot_label_4 = FALSE
      } else {
        include_plot_label_3 = TRUE
        include_plot_label_4 = TRUE
      }
    }
  }

  if (include_plot_label_3) {
    text(x=1952,y=0.10*yscale,pos=4,lab=txt$exports,col=color_export_text,cex=label_size,font=2,xpd=TRUE)
  }
  if (include_plot_label_4) {
    text(x=1952,y=-0.10*yscale,pos=4,lab=txt$imports,col=color_import_text,cex=label_size,font=2,xpd=TRUE)
  }

  # Add a label for the 'overlay' if one was chosen
  if (overlay != 'MZM_NONE') {
    ypos = overlay_consumption[n-10]
    xpos = lastyear - 10
    label = paste(overlay,txt$consumption)
    text(x=xpos,y=ypos,pos=1,lab=label,col=color_overlay_text,cex=1.0,font=2,xpd=TRUE)
  }

  # Add a label for the 'yscalecode' if one was chosen
  if (yscalecode != 'auto') {
    ypos = yscalecode_consumption[n]
    xpos = lastyear - 2 
    if (yscalecode == 'us') {
      text(x=xpos,y=ypos,pos=3,lab=txt$US,col=color_yscalecode_text,cex=label_size-0.2,font=1,xpd=TRUE)
    } else {
      text(x=xpos,y=ypos,pos=3,lab=txt$World,col=color_yscalecode_text,cex=label_size-0.2,font=1,xpd=TRUE)
    }
  }

  # Add user specified label
# NOTE:  yhi and ylo have been replaced by yscale
#  y = special_y*(yhi-ylo)*0.01 + ylo
#  text(x=c(special_x),y=c(y),labels=c(special_text),cex=1.0,font=2,col=color_labels_text)

  # Add the special note if found
  if (special_note != '') {
    text(x=1967,y=1.0*yscale,pos=4,lab=special_note,col=color_labels_text,cex=0.7,xpd=TRUE)
  }

  # Add the warning text if found
  if (warning_text != '') {
    text(x=1985,y=0,pos=4,lab=warning_text,col=color_labels_text,cex=1.2,xpd=TRUE)
  }

  # Return the list of colors associated with the countrylist variable.
  return(ei_col)
}
