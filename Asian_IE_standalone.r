layout(matrix(c(1,2),2,1), heights=c(70,30))
par(mar=c(1,1,3,4.5), mgp=c(3,0.8,0), cex=1.0, cex.axis=1.0, cex.lab=1.2)

############################################################
# Asian_ImportExport_plot.r
#
# y - vector of years
# p - vector of annual production amounts

#Asian_ImportExport_plot <- function(countryID='MZM_WORLD',countrylist=c('BP_WORLD'),
#                         datasource='BP_2010',fuel='coal',units='mtoe',
#                         overlay='MZM_NONE',yscalecode='auto',showmap='M',
#                         special_years=c(),special_x=1975,special_y=90,special_text='',
#                         firstyear=1965,lastyear=2009,txt=list()) {

  countryID='MZM_WORLD'
  countrylist=c('BP_WORLD')
  datasource='BP_2010'
  fuel='coal'
  units='mtoe'
  overlay='MZM_NONE'
  yscalecode='auto'
  showmap='M'
  firstyear=1965
  lastyear=2009
  txt=list()

  # Default plotting parameters
  par(las=1, lend='butt')

  # set up map colors
  color_export_map = '#40CC90'  
  color_import_map = '#EE5555'
  color_missing_map = 'gray90'
  color_net_0_map = '#AAAAB9'

  # set up plot colors
  color_exports = '#00AA60'  
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
      pivisor = 1/0.042
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
  # 1) read in the CSV file, applying the appropriate row names
  # 2) leave out the columns for 'country', 'change' and 'share of total'
  # 3) transpose to get countries as columns, years as rows (converts to matrix)
  # 4) convert back into data frame

  if (units == 'joule') {
    if (fuel == 'nuclear' || fuel == 'hydro') {
      filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_consumption_twh.csv',sep='',collapse='')
    } else {
      filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_consumption_mtoe.csv',sep='',collapse='')
    }
  } else {
    ###filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_consumption_',units,'.csv',sep='',collapse='')
    filename = paste('./',datasource,'_',fuel,'_consumption_',units,'.csv',sep='',collapse='')
  }
  c1 = read.csv(file=filename,header=TRUE,skip=6,row.names=1,na.strings=c('na'),strip.white=TRUE)
  c2 = c1[,1:n] / divisor
  c3 = t(c2)
  c4 = as.data.frame(c3)

  # Production data exist for all fuel types except 'nuclear' and 'hydro' where BP assumes production = consumption
  if (fuel == 'nuclear' || fuel == 'hydro') {
    p4 = c4
  } else {
    if (units == 'joule') {
      filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_production_mtoe.csv',sep='',collapse='')
    } else {
      ###filename = paste('/var/www/mazamascience.com/html/OilExport/',datasource,'_',fuel,'_production_',units,'.csv',sep='',collapse='')
      filename = paste('./',datasource,'_',fuel,'_production_',units,'.csv',sep='',collapse='')
    }
    p1 = read.csv(file=filename,header=TRUE,skip=6,row.names=1,na.strings=c('na'),strip.white=TRUE)
    p2 = p1[,1:n] / divisor
    p3 = t(p2)
    p4 = as.data.frame(p3)
  }

cn_net_exports = p4[['CN']] - c4[['CN']]
in_net_exports = p4[['IN']] - c4[['IN']]
jp_net_exports = p4[['JP']] - c4[['JP']]
kr_net_exports = p4[['KR']] - c4[['KR']]
tw_net_exports = zeroes - c4[['TW']]
au_net_exports = p4[['AU']] - c4[['AU']]
id_net_exports = p4[['ID']] - c4[['ID']]

net_exports = cn_net_exports + in_net_exports + jp_net_exports + kr_net_exports + tw_net_exports + au_net_exports + id_net_exports

cn_ex = pmax(zeroes,cn_net_exports)
cn_im = pmin(zeroes,cn_net_exports)
in_ex = pmax(zeroes,in_net_exports)
in_im = pmin(zeroes,in_net_exports)
jp_ex = pmax(zeroes,jp_net_exports)
jp_im = pmin(zeroes,jp_net_exports)
kr_ex = pmax(zeroes,kr_net_exports)
kr_im = pmin(zeroes,kr_net_exports)
tw_ex = pmax(zeroes,tw_net_exports)
tw_im = pmin(zeroes,tw_net_exports)
au_ex = pmax(zeroes,au_net_exports)
au_im = pmin(zeroes,au_net_exports)
id_ex = pmax(zeroes,id_net_exports)
id_im = pmin(zeroes,id_net_exports)

ex1 = jp_ex
ex2 = jp_ex + kr_ex
ex3 = jp_ex + kr_ex + tw_ex
ex4 = jp_ex + kr_ex + tw_ex + in_ex
ex5 = jp_ex + kr_ex + tw_ex + in_ex + au_ex
ex6 = jp_ex + kr_ex + tw_ex + in_ex + au_ex + id_ex
ex7 = jp_ex + kr_ex + tw_ex + in_ex + au_ex + id_ex + cn_ex

im1 = jp_im
im2 = jp_im + kr_im
im3 = jp_im + kr_im + tw_im 
im4 = jp_im + kr_im + tw_im + in_im
im5 = jp_im + kr_im + tw_im + in_im + au_im
im6 = jp_im + kr_im + tw_im + in_im + au_im + id_im
im7 = jp_im + kr_im + tw_im + in_im + au_im + id_im + cn_im

lwd = 18
lwd_net_exports = 1
lwd_zero_line = 1
color_net_exports = 'black'
color_zero_line = 'white'
color_cn = 'purple'
color_au = 'gray40'
color_id = 'gray60'
color_in = 'deepskyblue2' #00B2EE
color_tw = 'deepskyblue3' #009ACD
color_kr = '#0077A8' #
color_jp = '#006080' # 'deepskyblue' = #00688B

color_exports = '#00AA60'  
color_imports = 'firebrick2'  #EE2C2C

color_labels_text = 'black'

plot(ex7 ~ y_p, axes=FALSE, type='h', lwd=lwd,
              xlim=c(1980,2010),ylim=c(-350,350),
              main='', xlab='', ylab='',
              col=color_exports)
axis(1,line=-1.0)
axis(4,las=1)

points(ex6 ~ y_p,type='h',lwd=lwd,col=color_id) # indonesia
points(ex5 ~ y_p,type='h',lwd=lwd,col=color_au) # australia
points(ex4 ~ y_p,type='h',lwd=lwd,col=color_in) # india
points(ex3 ~ y_p,type='h',lwd=lwd,col=color_tw) # taiwan
points(ex2 ~ y_p,type='h',lwd=lwd,col=color_kr) # korea
points(ex1 ~ y_p,type='h',lwd=lwd,col=color_jp) # japan

points(im7 ~ y_p,type='h',lwd=lwd,col=color_imports)
points(im6 ~ y_p,type='h',lwd=lwd,col=color_id)
points(im5 ~ y_p,type='h',lwd=lwd,col=color_au)
points(im4 ~ y_p,type='h',lwd=lwd,col=color_in)
points(im3 ~ y_p,type='h',lwd=lwd,col=color_tw)
points(im2 ~ y_p,type='h',lwd=lwd,col=color_kr)
points(im1 ~ y_p,type='h',lwd=lwd,col=color_jp)

abline(h=0,col=color_zero_line,lwd=lwd_zero_line)

# Add year guides (thin gray lines that mark the decades)
guide_years = c(1980,1985,1990,1995,2000,2005)
guide_indices = c(16,21,26,31,36,41)
guides = ex7[guide_indices]
points(guides ~ guide_years, type='h', lwd=1, col=color_guide_lines)
guides = im7[guide_indices]
points(guides ~ guide_years, type='h', lwd=1, col=color_guide_lines)

# Add the axis labels
mtext(text='million tonnes oil equivalent',side=4,line=3.0,cex=1.0,las=0,xpd=NA)

# Add the upper legend
leg_x = 1980.5
leg_y = 350
leg_xjust = 0
leg_yjust = 1
text = c('China (net export years)','Indonesia','Australia')
cols = c(color_exports,color_id,color_au)
pchs = c(15)
pt.cexs = c(1.2)
text.cols = c('black')
legend(x=leg_x, y=leg_y, xjust=leg_xjust, yjust=leg_yjust, bty='n', bg="white",
       legend=text,col=cols,pch=pchs,pt.cex=pt.cexs,cex=1.0,text.col=text.cols)

# Add the upper legend
leg_x = 1980.5
leg_y = -100
leg_xjust = 0
leg_yjust = 1
text = c('Japan','Korea','Taiwan','India','China (net import years)')
cols = c(color_jp,color_kr,color_tw,color_in,color_imports)
pchs = c(15)
pt.cexs = c(1.2)
text.cols = c('black')
# Add a legend
legend(x=leg_x, y=leg_y, xjust=leg_xjust, yjust=leg_yjust, bty='n', bg="white",
       legend=text,col=cols,pch=pchs,pt.cex=pt.cexs,cex=1.0,text.col=text.cols)


title(main="Asia's major coal exporters and importers",line=0.5,cex.main=1.6)

#}

############################################################

par(mar=c(2,1,3,4.5), mgp=c(3,0.8,0), cex=1.0, cex.axis=1.0, cex.lab=1.2)

plot(cn_ex ~ y_p, axes=FALSE, type='h', lwd=lwd,
                      xlim=c(1980,2010),ylim=c(-60,60),
                      main='', xlab='', ylab='',
                      col=color_exports)
          
#axis(1)
axis(4,las=1)
points(cn_im ~ y_p,type='h',lwd=lwd,col=color_imports)

# Add year guides (thin gray lines that mark the decades)
guide_years = c(1980,1985,1990,1995,2000,2005)
guide_indices = c(16,21,26,31,36,41)
guides = cn_ex[guide_indices]
points(guides ~ guide_years, type='h', lwd=1, col=color_guide_lines)
guides = cn_im[guide_indices]
points(guides ~ guide_years, type='h', lwd=1, col=color_guide_lines)

# Add total imports
points(net_exports ~ y,type='s',lwd=lwd_net_exports,col=color_net_exports)
points(net_exports ~ y_p1,type='S',lwd=lwd_net_exports,col=color_net_exports)

# Add the axis labels
#mtext(text=txt$year,side=1,line=0.8,cex=1.0,adj=0,xpd=TRUE)
mtext(text='mtoe',side=4,line=2.5,cex=1.0,las=0,xpd=NA)

# Add the legend
leg_x = 1980.5
leg_y = -50
leg_xjust = 0
leg_yjust = 1
#text = c('Total Imports/Exports','China (exports)','China (imports)')
text = c('Total Imports/Exports')
#cols = c(color_net_exports,color_exports,color_imports)
cols = c(color_net_exports)
#pchs = c(15,15,15)
pt.cexs = c(1.2)
text.cols = c('black')

title(main="China's role in total net exports",line=0.5,cex.main=1.4)

# Add the mazamascience.com and datasource attribution
###subtitle = 'Data: BP Statistical Review 2010    Graphic: mazamascience.com'
###title(main=txt$subtitle,line=0.0,family='Times',col=color_labels_text,xpd=NA)

title(sub="Data: BP Statistical Review 2010    Graphic: mazamascience.com",line=0.5,family='Times',cex.main=1.0)

