########################################################################
# OilExport

options(warn=1)

# INSTALLER:  Set the absolute path for the Mazama_OilExport file.
source("/var/www/mazamascience.com/html/OilExport/Mazama_maps.r")
source("/var/www/mazamascience.com/html/OilExport/Exports_plot.r")
source("/var/www/mazamascience.com/html/OilExport/Sources_plot.r")
#source("/var/www/mazamascience.com/html/OilExport/Earnings_plot.r")

# NOTE:  layout() does not cause automatic reduction of the label
# NOTE:  sizes.  If, at the command line, you see this error:
# NOTE:  "error in plot.new() : plot region too large"
# NOTE:  then the combination of mgp,mar,cex needs to be modified.

OilExport <- function(countryID='US',country='United States',countrylist=c('US'),view='auto',
                      datasource='BP_2012',fuel='oil',units='bbl',conprod='consumption',
                      percent='',percapita='',
                      plottype='Exports',style='',
                      overlay='MZM_NONE',yscalecode='auto',showmap='M',
                      language='en') {

  # Decide on a language and source the appropriate file to get a language appropriate create_text_strings() method.
  text_source = paste('/var/www/mazamascience.com/html/OilExport/text_strings_',language,'.r',sep='',collapse='')
  source(text_source)
  txt = create_text_strings(plottype=plottype,country=country,fuel=fuel,units=units,conprod=conprod)

  if (plottype == 'Exports') {

    if (showmap == 'M') {

      layout(matrix(c(2,1),2,1), heights=c(40,60))

      par(mar=c(4,4,3,6), mgp=c(3,0.8,0), cex=1.0, cex.axis=1.0, cex.lab=1.2)
      ei_col = Exports_plot(countryID=countryID,countrylist=countrylist,
                            datasource=datasource,fuel=fuel,units=units,
                            overlay=overlay,yscalecode=yscalecode,showmap=showmap,
                            firstyear=1965,lastyear=2011,txt=txt)

      par(mar=c(2,4,1,4),xaxt='n',yaxt='n')
      country_map(countries=countrylist,col=ei_col,view=view,axes=TRUE)

     } else {

      par(mar=c(4,4,10,6), mgp=c(3,0.8,0), cex=1.0, cex.axis=1.0, cex.lab=1.2)
      ei_col = Exports_plot(countryID=countryID,countrylist=countrylist,
                            datasource=datasource,fuel=fuel,units=units,
                            overlay=overlay,yscalecode=yscalecode,showmap=showmap,
                            firstyear=1965,lastyear=2011,txt=txt)

    }

  } else if (plottype == 'Sources') {

    layout(matrix(c(2,1),2,1), heights=c(50,50))
    par(mar=c(4,4,3,6), mgp=c(3,0.8,0), cex=1.0, cex.axis=1.0, cex.lab=1.2)
    Sources_plot(countryID=countryID,countrylist=countrylist,
                 datasource=datasource,units=units,
                 conprod=conprod,percent=percent,
                 style='points',
                 firstyear=1965,lastyear=2011,txt=txt)

    par(mar=c(4,4,3,6), mgp=c(3,0.8,0), cex=1.0, cex.axis=1.0, cex.lab=1.2)
    Sources_plot(countryID=countryID,countrylist=countrylist,
                 datasource=datasource,units=units,
                 conprod=conprod,percent=percent,
                 style='stacked',
                 firstyear=1965,lastyear=2011,txt=txt)

  } else if (plottype == 'Earnings') {

    layout(matrix(c(2,1),2,1), heights=c(50,50))
    par(mar=c(4,4,3,6), mgp=c(3,0.8,0), cex=1.0, cex.axis=1.0, cex.lab=1.2)
    Prices_plot(datasource=datasource,denomination=denomination,
                firstyear=1965,lastyear=2011,txt=txt)

    par(mar=c(4,4,3,6), mgp=c(3,0.8,0), cex=1.0, cex.axis=1.0, cex.lab=1.2)
    Earnings_plot(countryID=countryID,countrylist=countrylist,
                  datasource=datasource,units=units,
                  conprod=conprod,percent=percent,
                  style='points',
                  firstyear=1965,lastyear=2011,txt=txt)

  }

}

#-----------------------------------------------------------------------
