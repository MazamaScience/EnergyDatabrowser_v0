#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# Name:
#       Exports_generatory.py
#
# Author:
#       Jonathan Callahan <Jonathan.S.Callahan@gmail.com>
#
# SECURITY: 1) All incoming parameter names and values are validated before being used.
# SECURITY: 2) All R commands are run inside a try/except block.

# INSTALLER: script_dir -- location of the directory containing R scripts
# INSTALLER:   This directory must be readable by the Apache user
# INSTALLER: abs_out -- absolute path of directory for R output graphics
# INSTALLER:   This directory must be writable by the Apache user.

##script_dir = "/home/jonathan/Projects/Oil/OilExport/"
##script_dir = "/var/www/mazamascience.com/html/OilExportTest/"
script_dir = "/Users/jonathancallahan/Projects/MazamaScience/OilExport/"

# INSTALLER: END OF INSTALLATION SETTINGS



import sys, cgi, os, re, time
from babel import Locale

# Make sure the LANG environment is set to UTF-8 so that international characters are supported
os.putenv('LANG','en_US.UTF-8')


# Set up the defaults
plottype = 'Exports'
datasource = 'BP_2010'

yscalecode = 'auto'
showmap = 'M'
overlay = 'MZM_NONE'
percent = '_'
conprod = 'consumption'

# Set up the lists that will be looped through
fuel = 'hydro'

if fuel == 'coal':
  units_list = ['mtoe']
elif fuel == 'oil':
  units_list = ['bbl','mtoe']
elif fuel == 'gas':
  units_list = ['ft3','m3','mtoe']
elif fuel == 'nuclear':
  units_list = ['twh','mtoe','joule']
elif fuel == 'hydro':
  units_list = ['twh','mtoe','joule']

#languages = ['de','en','es','fr','it','nl']
#countryIDs = ['MZM_WORLD','MZM_FSU','MZM_EU0','MZM_EU1','MZM_OPEC10','MZM_OPEC','MZM_NON_OPEC',
#              'MZM_G7','MZM_O5','MZM_G75','MZM_GCC','MZM_GECF','MZM_GECF11',
#              'MZM_NSE','MZM_PRG','MZM_CRB','MZM_WAF',
#              'CA','US','MX','MZM_TNA',
#              'AR','BR','CL','CO','EC','PE','TT','VE','MZM_TSCA',
#              'AT','BG','CZ','DK','FI','FR','DE','GR',
#              'HU','IS','IE','IT','NL','NO',
#              'PL','PT','RO','SK','ES','SE','CH','TR','GB','MZM_TEE',
#              'IR','IQ','KW','OM','QA','SA','SY','YE','AE','MZM_TME',
#              'DZ','AO','CM','TD','CG','EG','GQ','GA','LY',
#              'NG','SD','TN','ZA','MZM_TAF',
#              'AU','BN','BD','CN','HK','IN','ID','JP','MY',
#              'NZ','PK','PH','SG','KR','TW','TH','VN','MZM_TAP',
#              'AM','AZ','BY','EE','GE','KZ','KG','LV','LT','MD','RU','TJ','TM','UA','UZ']

fuel = 'oil'
units_list = ['bbl']
languages = ['en']
countryIDs = ['MZM_WORLD']

for units in units_list:

    for countryID in countryIDs:
    
        for language in languages:
    
            # Put each language output in its own directory
            abs_out = script_dir + "output_" + language + "/"
    
            # Create unique filename from request    
            tempString = plottype + "_" + datasource + "_" + fuel + "_" + units + "_" + str(countryID) + "_" + str(overlay) + "_" + \
                         str(yscalecode) + "_" + showmap
            tempString2 = re.sub('\W','_',tempString)
            unique_ID = re.sub('\_COND__','',tempString2)
            abs_img_pdf = abs_out + unique_ID + ".pdf"
            abs_img_png = abs_out + unique_ID + ".png"
    
            print(abs_img_png)
    
            # Generate the list of countries associated with each group
            if str(countryID) == 'MZM_WORLD':
                view = 'world'
                countrylist = ['CA','US','MX',
                               'AR','BR','CL','CO','EC','PE','TT','VE','BP_OSCA',
                               'AT','BP_BELU','BG','CZ','DK','FI','FR','DE','GR',
                               'HU','IS','IE','IT','NL','NO',
                               'PL','PT','RO','SK','ES','SE','CH','TR','GB','BP_OEE',
                               'IR','IQ','KW','OM','QA','SA','SY','YE','AE','BP_OME',
                               'DZ','AO','CM','TD','CG','EG','GQ','GA','LY',
                               'NG','SD','TN','ZA','BP_OAF',
                               'AU','BN','BD','CN','HK','IN','ID','JP','MY',
                               'NZ','PK','PH','SG','KR','TW','TH','VN','BP_OAP',
                               'AM','AZ','BY','EE','GE','KZ','KG','LV','LT','MD','RU','TJ','TM','UA','UZ']
            elif str(countryID) == 'MZM_FSU':
                view = 'former_soviet_union'
                countrylist = ['AM','AZ','BY','EE','GE','KZ','KG','LV','LT','MD','RU','TJ','TM','UA','UZ']
            elif str(countryID) == 'MZM_EU0':
                view = 'former_soviet_union'
                countrylist = ['AT', 'BP_BELU', 'BG','CZ','DK','FI','FR','DE','GR','HU','IS','IE','IT','NL','NO','PL',
                               'PT','RO','SK','ES','SE','CH','TR','GB',
                               'AL','BA','HR','CY','MK','ME','RS','SI']
            elif str(countryID) == 'MZM_EU1':
                view = 'former_soviet_union'
                countrylist = ['AT', 'BP_BELU', 'BG','CZ','DK','FI','FR','DE','GR','HU','IS','IE','IT','NL','NO','PL',
                               'PT','RO','SK','ES','SE','CH','TR','GB',
                               'AL','BA','HR','CY','MK','ME','RS','SI',
                               'AM','AZ','BY','EE','GE','KZ','KG','LV','LT','MD','RU','TJ','TM','UA','UZ']
            elif str(countryID) == 'MZM_BELU':
                view = 'northern_europe'
                countrylist = ['BP_BELU']
            elif str(countryID) == 'MZM_CRB':
                view = 'caribbean'
                countrylist = ['CO','VE','TT']
            elif str(countryID) == 'MZM_NSE':
                view = 'north_sea'
                countrylist = ['GB','NO','DK','NL']
            elif str(countryID) == 'MZM_PRG':
                view = 'middle_east'
                countrylist = ['IR','IQ','KW','QA','AE','SA','OM']
            elif str(countryID) == 'MZM_GCC':
                view = 'middle_east'
                countrylist = ['BH','KW','QA','AE','SA','OM']
            elif str(countryID) == 'MZM_WAF':
                view = 'west_africa'
                countrylist = ['NG','CM','GQ','GA','CG','AO']
            elif str(countryID) == 'MZM_TOP5EX':
                view = 'world'
                countrylist = ['SA','RU','NO','IR','AE']
            elif str(countryID) == 'MZM_OPEC':
                view = 'opec'
                countrylist = ['AO','LY','NG','DZ','IR','IQ','KW','QA','SA','AE','EC','VE','ID']
            elif str(countryID) == 'MZM_OPEC10':
                view = 'opec'
                countrylist = ['LY','NG','DZ','IR','KW','QA','SA','AE','VE','ID']
            elif str(countryID) == 'MZM_OPEC11':
                view = 'opec'
                countrylist = ['AO','LY','NG','DZ','IR','IQ','KW','QA','SA','AE','EC','VE','ID']
            elif str(countryID) == 'MZM_OPEC12':
                view = 'opec'
                countrylist = ['AO','LY','NG','DZ','IR','IQ','KW','QA','SA','AE','EC','VE','ID']
            elif str(countryID) == 'MZM_NON_OPEC':
                view = 'world'
                countrylist = ['CA','US','MX',
                               'AR','BR','CL','CO','EC','PE','TT','BP_OSCA',
                               'AT','BP_BELU','BG','CZ','DK','FI','FR','DE','GR',
                               'HU','IS','IE','IT','NL','NO',
                               'PL','PT','RO','SK','ES','SE','CH','TR','GB','BP_OEE',
                               'OM','SY','YE','BP_OME',
                               'CM','TD','CG','EG','GQ','GA',
                               'SD','TN','ZA','BP_OAF',
                               'AU','BN','BD','CN','HK','IN','JP','MY',
                               'NZ','PK','PH','SG','KR','TW','TH','VN','BP_OAP',
                               'AM','AZ','BY','EE','GE','KZ','KG','LV','LT','MD','RU','TJ','TM','UA','UZ']
            elif str(countryID) == 'MZM_GECF11':
                view = 'world'
                countrylist = ['DZ','BO','EG','GQ','IR','LY','NG','QA','RU','TT','VE']
            elif str(countryID) == 'MZM_GECF':
                view = 'world'
                countrylist = ['DZ','BO','EG','GQ','IR','KZ','LY','NG','NO','QA','RU','TT','VE']
            elif str(countryID) == 'MZM_OECD':
                view = 'world'
                countrylist = ['CA','US','MX',
                               'AT','BP_BELU','CZ','DK','FI','FR','DE','GR',
                               'HU','IS','IE','IT','NL','NO',
                               'PL','PT','RO','SK','ES','SE','CH','TR','GB',
                               'KR','JP','AU','NZ']
            elif str(countryID) == 'MZM_G7':
                view = 'world'
                countrylist = ['US','CA','GB','FR','DE','IT','JP']
            elif str(countryID) == 'MZM_O5':
                view = 'world'
                countrylist = ['BR','CN','HK','IN','MX','ZA']
            elif str(countryID) == 'MZM_G75':
                view = 'world'
                countrylist = ['US','CA','GB','FR','DE','IT','JP','BR','CN','HK','IN','MX','ZA']
            elif str(countryID) == 'MZM_US3':
                view = 'world'
                countrylist = ['US','CA','SA','MX']
    
            # Totals for different areas
            elif str(countryID) == 'MZM_TNA':
                view = 'north_america'
                countrylist = ['CA','US','MX']
            elif str(countryID) == 'MZM_TSCA':
                view = 'south_america'
                countrylist = ['AR','BR','CL','CO','EC','PE','TT','VE','BP_OSCA']
            elif str(countryID) == 'MZM_TEE':
                view = 'former_soviet_union'
                countrylist = ['AT','AZ','BY','MZ','BG','CZ','DK','FI','FR','DE','GR','HU','IS','IE','IT','KZ',
                               'LT','NL','NO','PL','PT','RO','RU','SK','ES','SE','CH','TR','TM','UA','GB','UZ','BP_OEE']
            elif str(countryID) == 'MZM_TME':
                view = 'middle_east'
                countrylist = ['IR','IQ','KW','QA','AE','SA','OM','YE','SY','BP_OME']
            elif str(countryID) == 'MZM_TAF':
                view = 'africa'
                countrylist=['DZ','AO','CM','TD','CG','EG','GQ','GA','LY','NG','ZA','SD','TN','BP_OAF']
            elif str(countryID) == 'MZM_TAP':
                view = 'asia_pacific'
                countrylist=['AU','BN','BD','CN','HK','IN','ID','JP','MY','NZ','PK','PH','SG','KR','TW','TH','VN','BP_OAP']
            else:
                view = 'auto'
                countrylist = [countryID]
             
            locale = Locale(language)
            if len(countryID) == 2:
                country = locale.territories[countryID].encode('utf-8')
            else:
                country = countryID
    
            script = script_dir + "OilExportTest.r"
    
            gs_cmd = "gs -dSAFTER -dBATCH -dNOPAUSE -sDEVICE=png16m " + \
                     "-dGraphicsAlphaBits=4 -dTextAlphaBits=4 -r300 " + \
                     "-dBackgroundColor='16#ffffff' " + \
                     "-sOutputFile=" + abs_img_png + " " + abs_img_pdf + " > /dev/null"
            try:
                from rpy import *
                r.source(script)
                r.pdf(file=abs_img_pdf,width=8,height=8,bg='white')
                ##r.OilExport(plottype=plottype,language=language,showmap=showmap,
                ##            countryID=countryID,country=country,countrylist=countrylist,
                ##            view=view,
                ##            overlay=overlay,yscalecode=yscalecode,datasource=datasource,fuel=fuel,units=units)
                r.OilExportTest(plottype=plottype,language=language,showmap=showmap,
                            countryID=countryID,country=country,countrylist=countrylist,
                            conprod=conprod,view=view,percent=percent,
                            overlay=overlay,yscalecode=yscalecode,datasource=datasource,fuel=fuel,units=units)
                r.dev_off()
                # Now convert the pdf file to png and resize 
                os.system(gs_cmd)
                os.system('mogrify -resize 500 ' + abs_img_png)
    
            except Exception, e:
                print(str(e))
                pass
