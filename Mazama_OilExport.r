################################################################################
# $Header$

################################################################################
#
#  Plotting functions
#
################################################################################

############################################################
# Import_Export_plot
#
# y - vector of years
# p - vector of annual production amounts

Import_Export_plot <- function(cID='US',countrylist=c('US'),
                        yscale=0,
                        datasource='BP_2008_Gas',firstyear=1965,lastyear=2007,
                        special_years=c(),special_x=1975,special_y=90,special_text='',
                        textstrings=c()) {

  # Set up defaults for each datasource
  if (datasource == 'BP_2008_Oil') {
    divisor = 1000
  } else if (datasource == 'BP_2008_Gas') {
    divisor = 1
  } else if (datasource == 'BP_2008_Coal') {
    divisor = 1
  } else if (datasource == 'EIA_2008_Oil') {
    divisor = 1000
  } else {
    divisor = 1
  }

  # Set all of the text strings
  text_main1 = textstrings[1]
  text_main2 = textstrings[2]
  text_main3 = textstrings[3]
  text_subtitle = textstrings[4]
  text_year = textstrings[5]
  text_units = textstrings[6]
  text_consumption = textstrings[7]
  text_production = textstrings[8]
  text_import = textstrings[9]
  text_export = textstrings[10]
  text_fromto = textstrings[11]
  text_production_increased = textstrings[12]
  text_production_decreased = textstrings[13]
  text_imports_increased = textstrings[14]
  text_imports_decreased = textstrings[15]
  text_exports_increased = textstrings[16]
  text_exports_decreased = textstrings[17]
  text_note_nodata = textstrings[18]
  text_note_minvalue = textstrings[19]
  text_msg_nodata = textstrings[20]
  text_country = textstrings[21]
  text_earned = textstrings[22]
  text_spent = textstrings[23]
  text_billion = textstrings[24]
  # These two will choose strings above depending upon the calculations
  special_note = ''
  warning_text = ''

  y = c(firstyear:lastyear)
  y_p = y + 0.5
  y_p1 = y + 1.0
  y_m = y - 0.5
  zeroes = y * 0.0
  missing = y * NA
  n = lastyear - firstyear + 1

  # Create the production and consumption data frames:
  # 1) read in the CSV file, applying the appropriate row names
  # 2) leave out the columns for 'country', 'change' and 'share of total'
  # 3) transpose to get countries as columns, years as rows (converts to matrix)
  # 4) convert back into data frame

  filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'Production.csv',sep='',collapse='')
  p1 = read.csv(file=filename,header=TRUE,skip=6,row.names=1,na.strings=c('NA'),strip.white=TRUE)
  p2 = p1[,1:n] / divisor
  p3 = t(p2)
  p4 = as.data.frame(p3)

  filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'Consumption.csv',sep='',collapse='')
  c1 = read.csv(file=filename,header=TRUE,skip=6,row.names=1,na.strings=c('NA'),strip.white=TRUE)
  c2 = c1[,1:n] / divisor
  c3 = t(c2)
  c4 = as.data.frame(c3)

  # For every country in the list
  # 1) production is zero if not listed (BP is keeping track of all the major producers.)
  # 2) consumption is zero if not listed (We know it won't be negative and we'd at least like to calculate a minimum.
  #    But we keep track of countries with missing consumption data because it is probably growing and we'd like to 
  #    let folks know we're only displaying a minimum here.)

  production_data_missing = FALSE
  consumption_data_missing = FALSE
  production = zeroes
  consumption = zeroes
  ei_col = countrylist
  country_index = 0
  for (country in countrylist) {  
    country_consumption_data_missing = FALSE
    country_production_data_missing = FALSE
    country_index = country_index + 1
    if (is.null(p4[[country]])) {
      country_production_data_missing = TRUE  
      production_data_missing = TRUE
      p5 = zeroes
    } else {
      p5 = as.numeric(as.character(p4[[country]]))
    }
    if (is.null(c4[[country]])) {
      country_consumption_data_missing = TRUE  
      consumption_data_missing = TRUE
      c5 = zeroes
    } else {
      c5 = as.numeric(as.character(c4[[country]]))
    }
    production = production + p5
    consumption = consumption + c5

    if (country_production_data_missing && country_consumption_data_missing) {
      ei_col[country_index] = c('grey80')
    } else if (is.na(p5[n]) || is.na(c5[n]) || country_consumption_data_missing) {
      ei_col[country_index] = c('#00AA60')
    } else {
      if (p5[n] > c5[n]) {
        ei_col[country_index] = c('#00AA60')
      } else if (c5[n] > p5[n]) {
        ei_col[country_index] = c('firebrick2')
      } else {
        ei_col[country_index] = c('gray60')
      }
    }
  }

  if (country_production_data_missing && country_consumption_data_missing && length(countrylist) == 1) {
    warning_text = text_msg_nodata
  }

  # Now that we have created the ei_col list of colors for all countries involved we
  # need to check to see if this is a special grouping that has it's own row in the 
  # BP data files.  In such a case we use the MZM_~ row instead of our sum as the sum 
  # will have missing values if even one small nation has missing values.  The BP 
  # special groupings do not have missing values and we'll just assume that BP did 
  # things right.
  mzm_groups = c('MZM_BELU','MZM_EMES','MZM_EU1','MZM_EU2','MZM_FSU','MZM_NONOPEC','MZM_OAF',
                 'MZM_OAP','MZM_OECD','MZM_OEE','MZM_OME','MZM_OPEC','MZM_OPEC10','MZM_OSCA',
                 'MZM_TAF','MZM_TAP','MZM_TEE','MZM_TME','MZM_TNA','MZM_TSCA','MZM_WORLD')
  bp_groups = c('BP_TNA','BP_OSCA','BP_TSCA','BP_OEE','BP_TEE','BP_OME','BP_TME','BP_OAF',
                'BP_TAF','BP_OAP','BP_TAP','BP_WORLD','BP_EU1','BP_EU2','BP_OECD','BP_OPEC',
                'BP_OPEC10','BP_NONOPEC','BP_FSU','BP_BELU','BP_EMES')
  special_groups = c('MZM_OME','MZM_TNA','MZM_FSU','MZM_WORLD','MZM_OPEC')
  groups_map = list('MZM_OME'='BP_OME',
                    'MZM_TNA'='BP_TNA',
                    'MZM_OME'='BP_OME',
                    'MZM_FSU'='BP_FSU',
                    'MZM_OPEC'='BP_OPEC')
  if ( cID %in% special_groups ) {
    id = groups_map[[cID]]
    if (is.null(p4[[id]])) {
      production = zeroes
    } else {
      production = as.numeric(as.character(p4[[id]]))
    }
    if (is.null(c4[[id]])) {
      consumption_data_missing = TRUE
      consumption = zeroes
    } else {
      consumption = as.numeric(as.character(c4[[id]]))
    }
  }

  # Create the special_note
  if (consumption_data_missing) {
    if (length(countrylist) == 1) {
      special_note = text_note_nodata
    } else {
      special_note = text_note_minvalue
    }
  }

  # Create a masks to identify decades and hilighted years
  #           5 6 7 8 970 1 2 3 4 5 6 7 8 980 1 2 3 4 5 6 7 8 990 1 2 3 4 5 6 7 8 900 1 2 3 4 5 6 7
  decades = c(0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0)
  #special_years = c(1980,1981,1982,1983,1992)
  label_years = zeroes
  for (year in special_years) {
    year_index = year - 1964
    label_years[year_index] = 1
  }

  # Line width must be just enough to cause histogram bars to overlap.  This will
  # depend upon the width of the graphic.
  lwd = 11

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
  plot(production ~ y_p, axes=FALSE, type='h', lwd=lwd, col='gray80', 
                         xlim=c(1960,2010), ylim=c(-1.0*yscale,yscale),
                         main='', xlab='', ylab='')
  axis(1)
  axis(4)
  points(production*decades ~ y_p, type='h', lwd=lwd, col='gray75')

  # Add user selected years associated with a label
  points(production*label_years ~ y_p, type='h', lwd=lwd, col='gray50')

  # Add exports and imports on top (unless it's the entire world)
  if (cID != 'MZM_WORLD') {
    if (!consumption_data_missing || length(countrylist) > 1) {
      points(exports ~ y_p, type='h', lwd=lwd, col='firebrick2')
      points(exports*label_years ~ y_p, type='h', lwd=lwd, col='firebrick4')
      points(exports_0 ~ y_p, type='h', lwd=lwd, col='#00AA60')
      points(exports_0*label_years ~ y_p, type='h', lwd=lwd, col='#44DDAA')
    }
  }

  # Add year guides (thin grey lines that mark the decades)
  guide_years = c(1970,1980,1990,2000)
  guide_indices = c(6,16,26,36)
  guides = production[guide_indices]
  points(guides ~ guide_years, type='h', lwd=2, col='gray95')
  guides = exports[guide_indices]
  points(guides ~ guide_years, type='h', lwd=2, col='gray95')

  # The consumption line goes on top
  if (!consumption_data_missing || length(countrylist) > 1) {
    points(consumption ~ y, type='s', lwd=3, col='black')
    points(consumption ~ y_p1, type='S', lwd=3, col='black')
  }

 # Lastly, calculate labeling information
  height = exports[n]
  if (abs(exports[n-1]) > 0) {
    if (cID == 'MZM_WORLD') {
      pct_chg = 100 * (production[n] - production[n-1]) / abs(production[n-1])
    } else {
      pct_chg = 100 * (exports[n] - exports[n-1]) / abs(exports[n-1])
    }
    pct_chg_string = as.character(abs(pct_chg))

    if (pct_chg >= 100) {
      pct_chg_string = strtrim(pct_chg_string,5)
    } else if (pct_chg >= 10) {
      pct_chg_string = strtrim(pct_chg_string,4)
    } else {
      pct_chg_string = strtrim(pct_chg_string,3)
    }
  } else {
    pct_chg_string = '--'
  }

  if (height > 0) {
    if (exports[n] > exports[n-1] ) {
      if (consumption_data_missing && length(countrylist) == 1) {
        ei_text = text_production_increased
      } else {
        ei_text = text_exports_increased
      }
    } else {
      if (consumption_data_missing && length(countrylist) == 1) {
        ei_text = text_production_decreased
      } else {
        ei_text = text_exports_decreased
      }
    }
  } else {
    if (exports[n] > exports[n-1] ) {
      ei_text = text_imports_decreased
    } else {
      ei_text = text_imports_increased
    }
  }

  # Special case for the entire world
  if (cID == 'MZM_WORLD') {
    if (production[n] > production[n-1] ) {
      ei_text = text_production_increased
    } else {
      ei_text = text_production_decreased
    }
  }


  # Add the title
  title(main=text_main1,line=3.0,cex.main=2.0,xpd=NA)
  label = paste(text_fromto,': ',ei_text,pct_chg_string,'%')
  title(main=label,line=1.5,xpd=NA)

  # Add the axis labels
  text(x=1952,y=-1.26*yscale,pos=4,lab=text_year,cex=1.0,xpd=TRUE)
  text(x=2020,y=0*yscale,lab=text_units,cex=1.2,srt=90,xpd=NA)

  # Add a legend
  text(x=1952,y=1.0*yscale,pos=4,lab=text_consumption,col='black',cex=0.8,font=2,xpd=TRUE)
  text(x=1952,y=0.9*yscale,pos=4,lab=text_production,col='gray60',cex=0.8,font=2,xpd=TRUE)
  text(x=1952,y=0.8*yscale,pos=4,lab=text_export,col='#00AA60',cex=0.8,font=2,xpd=TRUE)
  text(x=1952,y=0.7*yscale,pos=4,lab=text_import,col='firebrick2',cex=0.8,font=2,xpd=TRUE)

  # Add user specified label
# NOTE:  yhi and ylo have been replaced by yscale
#  y = special_y*(yhi-ylo)*0.01 + ylo
#  text(x=c(special_x),y=c(y),labels=c(special_text),cex=1.0,font=2,col='black')

  # Add the special note if found
  if (special_note != '') {
    text(x=1967,y=1.0*yscale,pos=4,lab=special_note,col='black',cex=0.7,xpd=TRUE)
  }

  # Add the warning text if found
  if (warning_text != '') {
    text(x=1985,y=0,pos=4,lab=warning_text,col='black',cex=1.2,xpd=TRUE)
  }

  # Add the mazamascience.com and datasource labels
  ###title(sub='Data: BP Statistical Review 2008     Graphic: mazamascience.com',line=2.5,family='Times',col='black',xpd=NA)
  title(sub=text_subtitle,line=2.5,family='Times',col='black',xpd=NA)

  return(ei_col)
}

############################################################
# Flow_of_Funds plot
#
# y - vector of years
# p - vector of annual production amounts

Flow_of_Funds_plot <- function(cID='US',countrylist=c('US'),yscale=0,
                               datasource='BP_2008_Gas',firstyear=1965,lastyear=2007,
                               special_years=c(),special_x=1975,special_y=90,special_text='',
                               textstrings=c()) {

  # Set up defaults for each datasource
  if (datasource == 'BP_2008_Oil') {
    divisor = 1000
  }

  # Set all of the text strings
  text_main1 = textstrings[1]
  text_main2 = textstrings[2]
  text_main3 = textstrings[3]
  text_subtitle = textstrings[4]
  text_year = textstrings[5]
  text_units = textstrings[6]
  text_consumption = textstrings[7]
  text_production = textstrings[8]
  text_import = textstrings[9]
  text_export = textstrings[10]
  text_fromto = textstrings[11]
  text_production_increased = textstrings[12]
  text_production_decreased = textstrings[13]
  text_imports_increased = textstrings[14]
  text_imports_decreased = textstrings[15]
  text_exports_increased = textstrings[16]
  text_exports_decreased = textstrings[17]
  text_note_nodata = textstrings[18]
  text_note_minvalue = textstrings[19]
  text_msg_nodata = textstrings[20]
  text_country = textstrings[21]
  text_earned = textstrings[22]
  text_spent = textstrings[23]
  text_billion = textstrings[24]
  # These two will choose strings above depending upon the calculations
  special_note = ''
  warning_text = ''

  y = c(firstyear:lastyear)
  y_p = y + 0.5
  y_p1 = y + 1.0
  y_m = y - 0.5
  zeroes = y * 0.0
  missing = y * NA
  n = lastyear - firstyear + 1

  # Create the production and consumption data frames:
  # 1) read in the CSV file, applying the appropriate row names
  # 2) leave out the columns for 'country', 'change' and 'share of total'
  # 3) transpose to get countries as columns, years as rows (converts to matrix)
  # 4) convert back into data frame

  filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'Production.csv',sep='',collapse='')
  p1 = read.csv(file=filename,header=TRUE,skip=6,row.names=1,na.strings=c('NA'),strip.white=TRUE)
  p2 = p1[,1:n] / divisor
  p3 = t(p2)
  p4 = as.data.frame(p3)

  filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'Consumption.csv',sep='',collapse='')
  c1 = read.csv(file=filename,header=TRUE,skip=6,row.names=1,na.strings=c('NA'),strip.white=TRUE)
  c2 = c1[,1:n] / divisor
  c3 = t(c2)
  c4 = as.data.frame(c3)

  filename = '/var/www/mazamascience.com/html/OilExport/BP_2008_oil_crude_prices_since_1861.csv'
  prices1 = read.csv(file=filename,header=TRUE,skip=6,row.names=1,na.strings=c('NA'),strip.white=TRUE)
  prices2 = prices1[1:2,1:n]
  prices3 = t(prices2)
  prices4 = as.data.frame(prices3)
  prices = prices4

  # For every country in the list
  # 1) production is zero if not listed (BP is keeping track of all the major producers.)
  # 2) consumption is zero if not listed (We know it won't be negative and we'd at least like to calculate a minimum.
  #    But we keep track of countries with missing consumption data because it is probably growing and we'd like to 
  #    let folks know we're only displaying a minimum here.)

  production_data_missing = FALSE
  consumption_data_missing = FALSE
  production = zeroes
  consumption = zeroes
  ei_col = countrylist
  country_index = 0
  for (country in countrylist) {  
    country_consumption_data_missing = FALSE
    country_production_data_missing = FALSE
    country_index = country_index + 1
    if (is.null(p4[[country]])) {
      country_production_data_missing = TRUE  
      production_data_missing = TRUE
      p5 = zeroes
    } else {
      p5 = as.numeric(as.character(p4[[country]]))
    }
    if (is.null(c4[[country]])) {
      country_consumption_data_missing = TRUE  
      consumption_data_missing = TRUE
      c5 = zeroes
    } else {
      c5 = as.numeric(as.character(c4[[country]]))
    }
    production = production + p5
    consumption = consumption + c5

    if (country_production_data_missing && country_consumption_data_missing) {
      ei_col[country_index] = c('grey90')
    } else if (is.na(p5[n]) || is.na(c5[n]) || country_consumption_data_missing) {
      ei_col[country_index] = c('#00AA60')
    } else {
      if (p5[n] > c5[n]) {
        ei_col[country_index] = c('#00AA60')
      } else if (c5[n] > p5[n]) {
        ei_col[country_index] = c('firebrick2')
      } else {
        ei_col[country_index] = c('gray60')
      }
    }
  }

  if (country_production_data_missing && country_consumption_data_missing && length(countrylist) == 1) {
    warning_text = text_msg_nodata
  }

  # Now that we have created the ei_col list of colors for all countries involved we
  # need to check to see if this is a special grouping that has it's own row in the 
  # BP data files.  In such a case we use the MZM_~ row instead of our sum as the sum 
  # will have missing values if even one small nation has missing values.  The BP 
  # special groupings do not have missing values and we'll just assume that BP did 
  # things right.
  mzm_groups = c('MZM_BELU','MZM_EMES','MZM_EU1','MZM_EU2','MZM_FSU','MZM_NONOPEC','MZM_OAF',
                 'MZM_OAP','MZM_OECD','MZM_OEE','MZM_OME','MZM_OPEC','MZM_OPEC10','MZM_OSCA',
                 'MZM_TAF','MZM_TAP','MZM_TEE','MZM_TME','MZM_TNA','MZM_TSCA','MZM_WORLD')
  bp_groups = c('BP_TNA','BP_OSCA','BP_TSCA','BP_OEE','BP_TEE','BP_OME','BP_TME','BP_OAF',
                'BP_TAF','BP_OAP','BP_TAP','BP_WORLD','BP_EU1','BP_EU2','BP_OECD','BP_OPEC',
                'BP_OPEC10','BP_NONOPEC','BP_FSU','BP_BELU','BP_EMES')
  special_groups = c('MZM_OME','MZM_TNA','MZM_FSU','MZM_WORLD','MZM_OPEC')
  groups_map = list('MZM_OME'='BP_OME',
                    'MZM_TNA'='BP_TNA',
                    'MZM_OME'='BP_OME',
                    'MZM_FSU'='BP_FSU',
                    'MZM_OPEC'='BP_OPEC')
  if ( cID %in% special_groups ) {
    id = groups_map[[cID]]
    if (is.null(p4[[id]])) {
      production = zeroes
    } else {
      production = as.numeric(as.character(p4[[id]]))
    }
    if (is.null(c4[[id]])) {
      consumption_data_missing = TRUE
      consumption = zeroes
    } else {
      consumption = as.numeric(as.character(c4[[id]]))
    }
  }

  # Create the special_note
  if (consumption_data_missing) {
    if (length(countrylist) == 1) {
      special_note = text_note_nodata
    } else {
      special_note = text_note_minvalue
    }
  }

  # Create a masks to identify decades and hilighted years
  #                 65 6 7 8 970 1 2 3 4 5 6 7 8 980 1 2 3 4 5 6 7 8 990 1 2 3 4 5 6 7 8 900 1 2 3 4 5 6 7
  decades =        c(0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0)
  earnings_years = c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1)
  #special_years = c(1980,1981,1982,1983,1992)
  label_years = zeroes
  for (year in special_years) {
    year_index = year - 1964
    label_years[year_index] = 1
  }

  # Line width must be just enough to cause histogram bars to overlap.  This will
  # depend upon the width of the graphic.
  lwd = 11

  # Now for the actual plot

  # Convert from million barrels/day to million $/day
  current_dollars = prices[['current_dollars']]
  production = production * current_dollars
  consumption = consumption * current_dollars

  exports = production - consumption     # Positive or negative
  exports_0 = pmax(exports, exports * 0) # Positive or zero only
  earnings = exports * earnings_years * 365 / 1000 # Convert to Billions
  total_earnings = sum(earnings,na.rm=TRUE)

  if (yscale == 0) {
    pcmax = pmax(production,consumption,na.rm=FALSE)
    ylo = min(exports,na.rm=TRUE)
    ylo = min(ylo,0)
    yhi = max(pcmax,na.rm=TRUE)
    yscale = max(abs(ylo),yhi)
    if (yscale == 0) { yscale = 1 }
  }
  
  # The production graph goes on the bottom, shaded by decade
  plot(production ~ y_p, axes=FALSE, type='h', lwd=lwd, col='gray80', 
                         xlim=c(1960,2010), ylim=c(-1.0*yscale,yscale),
                         main='', xlab='', ylab='')
  axis(1)
  axis(4)
  points(production*decades ~ y_p, type='h', lwd=lwd, col='gray75')

  # Add user selected years associated with a label
  points(production*label_years ~ y_p, type='h', lwd=lwd, col='gray50')

  # Add exports and imports on top
  if (cID != 'MZM_WORLD') {
    if (!consumption_data_missing || length(countrylist) > 1) {
      points(exports ~ y_p, type='h', lwd=lwd, col='firebrick2')
      points(exports*label_years ~ y_p, type='h', lwd=lwd, col='firebrick4')
      points(exports_0 ~ y_p, type='h', lwd=lwd, col='#00AA60')
      points(exports_0*label_years ~ y_p, type='h', lwd=lwd, col='#44DDAA')
    }
  }

  # Add year guides (thin grey lines that mark the decades)
  guide_years = c(1970,1980,1990,2000)
  guide_indices = c(6,16,26,36)
  guides = production[guide_indices]
  points(guides ~ guide_years, type='h', lwd=2, col='gray95')
  guides = exports[guide_indices]
  points(guides ~ guide_years, type='h', lwd=2, col='gray95')

  # The consumption line goes on top
  if (!consumption_data_missing || length(countrylist) > 1) {
    points(consumption ~ y, type='s', lwd=3, col='black')
    points(consumption ~ y_p1, type='S', lwd=3, col='black')
  }
# # The current_dollars line goes on top
#   #points(current_dollars ~ y, type='s', lwd=3, col='black')
#   #points(current_dollars ~ y_p1, type='S', lwd=3, col='black')

  total_earnings_string = as.character(abs(total_earnings))
  if (abs(total_earnings) > 100000) {
    total_earnings_string = strtrim(total_earnings_string,6)
  } else if (abs(total_earnings) > 10000) {
    total_earnings_string = strtrim(total_earnings_string,5)
  } else if (abs(total_earnings) > 1000) {
    total_earnings_string = strtrim(total_earnings_string,4)
  } else if (abs(total_earnings) > 100) {
    total_earnings_string = strtrim(total_earnings_string,3)
  } else if (abs(total_earnings) > 10) {
    total_earnings_string = strtrim(total_earnings_string,2)
  } else if (abs(total_earnings) > 1) {
    total_earnings_string = strtrim(total_earnings_string,1)
  }

  # Add the title
  title(main=text_main1,line=3.0,cex.main=2.0,xpd=NA)
  if (total_earnings > 0) {
    label = paste(text_fromto,': ',text_country,' ',text_earned,' $',total_earnings_string,' ',text_billion,sep='',collapse='')
  } else {
    label = paste(text_fromto,': ',text_country,' ',text_spent,' $',total_earnings_string,' ',text_billion,sep='',collapse='')
  }
  if (cID != 'MZM_WORLD') {
    title(main=label,line=1.5,xpd=NA)
    title(main=text_main3,line=0.5,xpd=NA,cex.main=0.8)
  }

  # Add the axis labels
  text(x=1952,y=-1.26*yscale,pos=4,lab=text_year,cex=1.0,xpd=TRUE)
  text(x=2020,y=0*yscale,lab=text_units,cex=1.2,srt=90,xpd=NA)

  # Add a legend
  text(x=1952,y=1.0*yscale,pos=4,lab=text_consumption,col='black',cex=0.8,font=2,xpd=TRUE)
  text(x=1952,y=0.9*yscale,pos=4,lab=text_production,col='gray60',cex=0.8,font=2,xpd=TRUE)
  text(x=1952,y=0.8*yscale,pos=4,lab=text_export,col='#00AA60',cex=0.8,font=2,xpd=TRUE)
  text(x=1952,y=0.7*yscale,pos=4,lab=text_import,col='firebrick2',cex=0.8,font=2,xpd=TRUE)

  # Add user specified label
# NOTE:  yhi and ylo have been replaced by yscale
#  y = special_y*(yhi-ylo)*0.01 + ylo
#  text(x=c(special_x),y=c(y),labels=c(special_text),cex=1.0,font=2,col='black')

  # Add the special note if found
  if (special_note != '') {
    text(x=1967,y=1.0*yscale,pos=4,lab=special_note,col='black',cex=0.7,xpd=TRUE)
  }

  # Add the warning text if found
  if (warning_text != '') {
    text(x=1985,y=0,pos=4,lab=warning_text,col='black',cex=1.2,xpd=TRUE)
  }

  # Add the mazamascience.com and datasource labels
  title(sub=text_subtitle,line=2.5,family='Times',col='black',xpd=NA)

  return(ei_col)
}

# END ##########################################################################

################################################################################
#
#  Utility functions
#
################################################################################

