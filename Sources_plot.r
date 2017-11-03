############################################################
# Sources_plot
#
# y - vector of years
# p - vector of annual production amounts

Sources_plot <- function(countryID='US',countrylist=c('US'),
                         datasource='BP_2012',units='mtoe',
                         conprod='consumption',percent='',
                         style='points',
                         firstyear=1965,lastyear=2011,txt=list()) {

  # TODO:  1 tonne of oil ~= 42 gigajoules
  # TODO:  1 mtoe ~= 0.042 exajoules
  divisor = 1
  if (units == 'joule') {
    divisor = 1/0.042
  }

  # Set up symbols, colors and sizes
  pch_coal = 18    # solid diamond
  pch_oil = 1      # empty circle 
  pch_gas = 17     # solid triangle
  pch_nuclear = 8  # asterisk
  pch_hydro = 16   # solid circle

  color_coal = 'grey20'
  color_oil = 'grey60'
  color_gas = 'lightblue2'
  color_nuclear = 'orange1'
  color_hydro = 'royalblue1'

  color_coal_text = 'black'
  color_oil_text = 'grey50'
  color_gas_text = 'lightblue3'
  color_nuclear_text = 'orange2'
  color_hydro_text = 'royalblue3'
  color_missing_text = 'gray80'

  color_labels_text = 'black'

  color_guide_lines = 'gray90'
  color_guide_lines_lower = 'gray90'

  cex_coal = 1.5
  cex_oil = 1.2
  cex_gas = 1.2
  cex_nuclear = 1.2
  cex_hydro = 1

  lwd_coal = 1
  lwd_oil = 1.4
  lwd_gas = 1
  lwd_nuclear = 1
  lwd_hydro = 1

  # Line width must be just enough to cause histogram bars to overlap.
  # This will depend upon the width of the graphic.
  lwd = 11

  # Set up arrays of zeroes and NA's
  y = c(firstyear:lastyear)
  y_p = y + 0.5
  y_p1 = y + 1.0
  y_m = y - 0.5
  zeroes = y * 0.0
  missing = y * NA
  n_years = lastyear - firstyear + 1

  # Create data frames for each energy source:
  # 1) read in the CSV file, applying the appropriate row names
  # 2) leave out the columns for 'country', 'change' and 'share of total'
  # 3) transpose to get countries as columns, years as rows (converts to matrix)
  # 4) convert back into data frame

 filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_coal','_',conprod,'_mtoe.csv',sep='',collapse='')
  c1 = read.csv(file=filename,skip=6,na.strings=c('na'))
  c4 = c1 / divisor

  filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_oil','_',conprod,'_mtoe.csv',sep='',collapse='')
  o1 = read.csv(file=filename,skip=6,na.strings=c('na'))
  o4 = o1 / divisor

  filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_gas','_',conprod,'_mtoe.csv',sep='',collapse='')
  g1 = read.csv(file=filename,skip=6,na.strings=c('na'))
  g4 = g1 / divisor

  # NOTE:  BP ASSUMES that production = consumption for nuclear and only reports consumption
  if (units == 'joule') {
    # NOTE: 1 Watt-hour = 3600 Joules
    # NOTE: 1 Teratt-hour = 0.0036 Exajoules
    divisor = 1 / 0.0036
    filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_nuclear','_consumption_twh.csv',sep='',collapse='')
  } else {
    filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_nuclear','_consumption_mtoe.csv',sep='',collapse='')
  }
  n1 = read.csv(file=filename,skip=6,na.strings=c('na'))
  n4 = n1 / divisor

  # NOTE:  BP ASSUMES that production = consumption for hydro and only reports consumption
  if (units == 'joule') {
    # NOTE: 1 Watt-hour = 3600 Joules
    # NOTE: 1 Teratt-hour = 0.0036 Exajoules
    divisor = 1 / 0.0036
    filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_hydro','_consumption_twh.csv',sep='',collapse='')
  } else {
    filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_hydro','_consumption_mtoe.csv',sep='',collapse='')
  }
  h1 = read.csv(file=filename,skip=6,na.strings=c('na'))
  h4 = h1 / divisor

  # Set each energy source to zeroes
  coal = zeroes
  oil = zeroes
  gas = zeroes
  nuclear = zeroes
  hydro = zeroes

  # For every country in the list:
  #   If the country is found, add its values.

  for (cID in countrylist) {

    if (!is.null(c4[[cID]])) {
      coal = coal + c4[[cID]]
    }

    if (!is.null(o4[[cID]])) {
      oil = oil + o4[[cID]]
    }

    if (!is.null(g4[[cID]])) {
      gas = gas + g4[[cID]]
    }

    if (!is.null(n4[[cID]])) {
      nuclear = nuclear + n4[[cID]]
    }
  
    if (!is.null(h4[[cID]])) {
      hydro = hydro + h4[[cID]]
    }

  } # End of "for (cID in countrylist)" loop


  total = coal + oil + gas + nuclear + hydro

  # Heuristic check for 'all data missing'
  # If some of the data are missing and the rest are zero max() will return zero.
  # If all of the data are missing max() will return -Inf.
  all_data_missing = FALSE
  all_coal_missing = FALSE
  all_oil_missing = FALSE
  all_gas_missing = FALSE
  all_nuclear_missing = FALSE
  all_hydro_missing = FALSE
  if (max(coal,na.rm=TRUE) < 0.1 || max(coal,na.rm=TRUE) == -Inf) {
    all_coal_missing = TRUE
    color_coal_text = color_missing_text
  }
  if (max(oil,na.rm=TRUE) < 0.1 || max(oil,na.rm=TRUE) == -Inf) {
    all_oil_missing = TRUE
    color_oil_text = color_missing_text
  }
  if (max(gas,na.rm=TRUE) < 0.1 || max(gas,na.rm=TRUE) == -Inf) {
    all_gas_missing = TRUE
    color_gas_text = color_missing_text
  }
  if (max(nuclear,na.rm=TRUE) < 0.1 || max(nuclear,na.rm=TRUE) == -Inf) {
    all_nuclear_missing = TRUE
    color_nuclear_text = color_missing_text
  }
  if (max(hydro,na.rm=TRUE) < 0.1 || max(hydro,na.rm=TRUE) == -Inf) {
    all_hydro_missing = TRUE
    color_hydro_text = color_missing_text
  }
  if (max(total,na.rm=TRUE) < 0.1 || max(total,na.rm=TRUE) == -Inf) {
    all_data_missing = TRUE
  }

  # Make text grey if a fuel has all missing values
#  color_label_hydro = ifelse(all_hydro_missing,color_missing_text,color_labels_text)
#  color_label_gas = ifelse(all_gas_missing,color_missing_text,color_labels_text)
#  color_label_oil = ifelse(all_oil_missing,color_missing_text,color_labels_text)
#  color_label_coal = ifelse(all_coal_missing,color_missing_text,color_labels_text)
#  color_label_nuclear = ifelse(all_nuclear_missing,color_missing_text,color_labels_text)

  # Calculate percentages
  coal_pct = 100 * coal / total
  oil_pct = 100 * oil / total
  gas_pct = 100 * gas / total
  nuclear_pct = 100 * nuclear / total
  hydro_pct = 100 * hydro / total

  # Determine appropriate limits for the y-axis
  ylo = 0
  if (percent == 'pct') {
    yhi = max(c(coal_pct,oil_pct,gas_pct,nuclear_pct,hydro_pct),na.rm=TRUE)
  } else {
    yhi = max(c(coal,oil,gas,nuclear,hydro),na.rm=TRUE)
  }
  if (all_data_missing) {
    yhi = 1
  }

  ########### LOWER PLOT ###########################################

  if (style == 'points') {

    if (percent == 'pct') {
  
      plot(coal_pct ~ y_p,axes=FALSE,pch=pch_coal,col=color_coal_text,cex=cex_coal,lwd=lwd_coal,
                          xlim=c(1954,2012), ylim=c(ylo,yhi),
                          main='', xlab='', ylab='')
      axis(1)
      axis(4,las=0)

      # Add year guides (thin gray lines that mark the decades)
      guide_years = c(1970,1980,1990,2000,2010)
      guide_indices = c(6,16,26,36,46)
      guides = 100 + 0 * zeroes[guide_indices]
      points(guides ~ guide_years, type='h', lwd=2, col=color_guide_lines_lower)

      # The symbols for 'nuclear' and 'oil' don't look good on top of other symbols.  Plot them first.
      points(nuclear_pct ~ y_p,pch=pch_nuclear,cex=cex_nuclear,col=color_nuclear_text,lwd=lwd_nuclear)
      points(oil_pct ~ y_p,pch=pch_oil,cex=cex_oil,col=color_oil_text,lwd=lwd_oil)
      points(coal_pct ~ y_p,pch=pch_coal,cex=cex_coal,col=color_coal_text,lwd=lwd_coal)
      points(gas_pct ~ y_p,pch=pch_gas,cex=cex_gas,col=color_gas_text,lwd=lwd_gas)
      points(hydro_pct ~ y_p,pch=pch_hydro,cex=cex_hydro,col=color_hydro_text,lwd=lwd_hydro)
  
    } else {
  
      plot(coal ~ y_p,axes=FALSE,pch=pch_coal,col=color_coal_text,cex=cex_coal,lwd=lwd_coal,
                      xlim=c(1954,2012), ylim=c(ylo,yhi),
                      main='', xlab='', ylab='')
      axis(1)
      axis(4,las=0)

      # Add year guides (thin gray lines that mark the decades)
      guide_years = c(1970,1980,1990,2000,2010)
      guide_indices = c(6,16,26,36,46)
      guides = yhi + 0 * zeroes[guide_indices]
      points(guides ~ guide_years, type='h', lwd=2, col=color_guide_lines_lower)

      # The symbol for 'nuclear' is unsightly so put it on the bottom
      points(nuclear ~ y_p,pch=pch_nuclear,cex=cex_nuclear,col=color_nuclear_text,lwd=lwd_nuclear)
      points(oil ~ y_p,pch=pch_oil,cex=cex_oil,col=color_oil_text,lwd=lwd_oil)
      points(coal ~ y_p,pch=pch_coal,cex=cex_coal,col=color_coal_text,lwd=lwd_coal)
      points(gas ~ y_p,pch=pch_gas,cex=cex_gas,col=color_gas_text,lwd=lwd_gas)
      points(hydro ~ y_p,pch=pch_hydro,cex=cex_hydro,col=color_hydro_text,lwd=lwd_hydro)

    }

    leg_x = 1954
    leg_y = yhi * 1.1
    leg_xjust = 0
    leg_yjust = 1
    text = c(txt$hydro,txt$gas,txt$oil,txt$coal,txt$nuclear)
    cols = c(color_hydro_text,color_gas_text,color_oil_text,color_coal_text,color_nuclear_text)
    pchs = c(pch_hydro,pch_gas,pch_oil,pch_coal,pch_nuclear)
    pt.cexs = c(cex_hydro,cex_gas,cex_oil,cex_coal,cex_nuclear)

    #text.cols = c(color_label_hydro,color_label_gas,color_label_oil,color_label_coal,color_label_nuclear)
    text.cols = c(color_hydro_text,color_gas_text,color_oil_text,color_coal_text,color_nuclear_text)

    # Add a legend
    if (!all_data_missing) {
      legend(x=leg_x, y=leg_y, xjust=leg_xjust, yjust=leg_yjust, bty='n', bg="white",
             legend=text,col=cols,pch=pchs,pt.cex=pt.cexs,cex=1.2,text.col=text.cols)
    }

    # Now add all the labels for the bottom plot.

    # Add the title and attribution
    title(main=txt$main1,line=2,cex.main=2.0,xpd=NA)
    title(sub=txt$subtitle,line=2.5,family='Times',col=color_labels_text,xpd=NA)

    # Add the axis labels
    mtext(text=txt$year,side=1,line=0.8,cex=1.0,adj=0,xpd=TRUE)
    if (percent == 'pct') {
      mtext(text=txt$percent,side=4,line=3.0,cex=1.2,las=0,xpd=NA)
    } else {
      mtext(text=txt$units,side=4,line=3.0,cex=1.2,las=0,xpd=NA)
    }
  
    # Special cases
    if (all_data_missing) {
      mtext(text=txt$msg_nodata,side=3,line=0.5,cex=1.2,font=1,xpd=NA)
    }
  ########### UPPER PLOT ###########################################

  } else { # style = 'stacked'

    # Default plotting parameters
    par(las=1, lend='butt')

    # NOTE:  Missing values make stacked plots impossible.  Use 'A' as a mask.
    A = nuclear + coal + oil + gas + hydro
    B = nuclear + coal + oil + gas  + 0*A
    C = nuclear + coal + oil + 0*A
    D = nuclear + coal  + 0*A
    E = nuclear + 0*A

    ylo = 0
    yhi = max(A,na.rm=TRUE)

    A_pct = 100 * A / A
    B_pct = 100 * B / A
    C_pct = 100 * C / A
    D_pct = 100 * D / A
    E_pct = 100 * E / A

    if (percent == 'pct') {

      yhi = 100
      plot(A_pct ~ y_p,type='h',axes=FALSE,lwd=lwd,col=color_hydro,
                       xlim=c(1954,2012), ylim=c(ylo,yhi),
                       main='', xlab='', ylab='')
      axis(1)
      axis(4,las=0)

      points(B_pct ~ y_p, type='h',lwd=lwd,col=color_gas)
      points(C_pct ~ y_p, type='h',lwd=lwd,col=color_oil)
      points(D_pct ~ y_p, type='h',lwd=lwd,col=color_coal)
      points(E_pct ~ y_p, type='h',lwd=lwd,col=color_nuclear)

      # Add year guides (thin gray lines that mark the decades)
      guide_years = c(1970,1980,1990,2000,2010)
      guide_indices = c(6,16,26,36,46)
      guides = A_pct[guide_indices]
      points(guides ~ guide_years, type='h', lwd=2, col=color_guide_lines)

    } else {

      plot(A ~ y_p,type='h',axes=FALSE,lwd=lwd,col=color_hydro,
                   xlim=c(1954,2012), ylim=c(ylo,yhi),
                   main='', xlab='', ylab='')
      axis(1)
      axis(4,las=0)

      points(B ~ y_p, type='h',lwd=lwd,col=color_gas)
      points(C ~ y_p, type='h',lwd=lwd,col=color_oil)
      points(D ~ y_p, type='h',lwd=lwd,col=color_coal)
      points(E ~ y_p, type='h',lwd=lwd,col=color_nuclear)

      # Add year guides (thin gray lines that mark the decades)
      guide_years = c(1970,1980,1990,2000,2010)
      guide_indices = c(6,16,26,36,46)
      guides = A[guide_indices]
      points(guides ~ guide_years, type='h', lwd=2, col=color_guide_lines)

    }

    # Now add all the labels for the top plot.

    if (!all_data_missing) {
      if (percent == 'pct') {
        title_text = txt$percent_title
      } else {
        # Create and add the % change label in the top plot
        pct_chg = 100 * (total[n_years] - total[n_years-1]) / abs(total[n_years-1])
    
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
    
        if (total[n_years] > total[n_years-1] ) {
          if (conprod == 'production') {
            string1 = txt$energy_produced_increased
          } else {
            string1 = txt$energy_consumed_increased
          }
        } else {
          if (conprod == 'production') {
            string1 = txt$energy_produced_decreased
          } else {
            string1 = txt$energy_consumed_decreased
          }
        }
        title_text = paste(lastyear,':',string1,pct_chg_string,'%')
      }
      title(main=title_text,line=1,cex.main=1.2,xpd=NA)
    }

    # Add the axis labels
    if (percent == 'pct') {
      mtext(text=txt$percent,side=4,line=2.5,cex=1.2,las=0,xpd=NA)
    } else {
      if (units == 'mtoe') {
        # Use something smaller than "million tonnes oil equiv." to declutter the chart.
        mtext(text='\'mtoe\'',side=4,line=2.5,cex=1.2,las=0,xpd=NA)
      } else {
        mtext(text=txt$units,side=4,line=2.5,cex=1.2,las=0,xpd=NA)
      }
    }

  }


}
