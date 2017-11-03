#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# Name:
#       OilExport.cgi
#
# Author:
#       Jonathan Callahan <Jonathan.S.Callahan@gmail.com>
#
# SECURITY: 1) All incoming parameter names and values are validated before being used.
# SECURITY: 2) All R commands are run inside a try/except block.

# INSTALLER: script_dir -- location of the directory containing R scripts
# INSTALLER:   This directory must be readable by the Apache user
# INSTALLER: is_script -- flag to convert from script to CGI
# INSTALLER:   Set is_script to 'False' to run as a CGI.
# INSTALLER: sleep_amt -- time in seconds to sleep after issuing the R plotting command
# INSTALLER:   This is to guarantee that the HTML for containing the <img...> tag is not
# INSTALLER:   returned before the image is available.  If you see "databrowser 5 img"
# INSTALLER:   appearing in the image iframe you should increase this value.

script_dir = "/var/www/mazamascience.com/html/OilExport/"
transcript = script_dir + 'TRANSCRIPT.txt'
debug_file = script_dir + 'DEBUG_LOG.txt'
is_script = False
sleep_amt = 0.2

# INSTALLER: END OF INSTALLATION SETTINGS



import sys, cgi, os, re, time
from babel import Locale

# Make sure the LANG environment is set to UTF-8 so that international characters are supported
os.putenv('LANG','en_US.UTF-8')

# NOTE:  Send the verbose info when importing RPy to /dev/null instead of stdout.
# NOTE:  Otherwise the verbose output will appear in the output.
#sys.stdout=open('/dev/null','w')
sys.stdout=open(transcript,'w')

# 'valids' contains the list of possible values for each parameter.
# 'request' is the internal request object (a dictionary)
valids = {}
request = {}

# Set up defaults for the optional parameters
request['showmap'] = '_'
request['overlay'] = 'MZM_NONE'
request['percent'] = '_'
request['conprod'] = 'consumption'

# Set up the list of valid parameters and valid values for each parameter
required_parameters = "language plottype datasource fuel units countryID yscalecode".split(' ')
optional_parameters = "showmap percapita percent conprod".split(' ')
valids['plottype'] = "Exports Sources DUMMY".split(' ')
valids['datasource'] = "BP_2012 DUMMY".split(' ')
valids['fuel'] = "coal oil gas nuclear hydro all".split(' ')
valids['units'] = "bbl ft3 m3 twh mtoe joule".split(' ')
valids['yscalecode'] = "auto us world".split(' ')
valids['language'] = "de en es fr it nl ru sk sv".split(' ')
valids['showmap'] = "M _ DUMMY".split(' ')
valids['percapita'] = "P _ DUMMY".split(' ')
valids['percent'] = "pct _ DUMMY".split(' ')
valids['conprod'] = "consumption production".split(' ')

# Fill in the request from cgi.FieldStorage unless running in test mode from a script

if is_script:  # for command line debugging
    request = {'language': 'en',
               'plottype': 'Exports',
               'datasource': 'BP_2012', 
               'percent': '_', 
               'fuel': 'oil', 
               'units': 'joule', 
               'countryID': 'MZM_GECF11',
               'yscalecode': 'auto', 
               'showmap': 'M',
               'overlay': 'MZM_NONE',
               'conprod': 'consumption'}

else:          # for use as a CGI script
    FS = cgi.FieldStorage()
    for key in required_parameters:
        if FS.has_key(key):
            if type(FS[key]) != type([]):
                request[key] = FS[key].value
            else:
                request[key] = map(lambda x: x.value, FS[key])
        else:
            request[key] = ''

    for key in optional_parameters:
        if FS.has_key(key):
            request[key] = FS[key].value

# For now, the language may or may not be transmitted
if request.has_key('language'):
    if request['language'] == '':
        request['language'] = 'en'

# Initialize the default status and message strings
status = 'OK'
error_text = ""
debug_text = ""

# Validate every parameter except 'countryID' and 'overlay' against the list of valids for that parameter
for key in request:
    if (key != 'countryID' and key != 'overlay' ):
        if request[key] not in valids[key]:
            error_text = "\"" + request[key] + "\" is not a valid value for " + key + "."
            status = 'ERROR'

# All parameters are valid so find/generate the desired product and send it back

if status == 'OK':
    # Get all of the form parameters
    language = request['language']
    plottype = request['plottype']
    datasource = request['datasource']
    fuel = request['fuel']
    units = request['units']
    countryID = request['countryID']
    yscalecode = request['yscalecode']
    showmap = request['showmap']
    overlay = request['overlay']
    percent = request['percent']
    conprod = request['conprod']

    # Put each language's output in its own directory
    rel_out = "/OilExport/output_" + language + "/"
    abs_out = script_dir + "output_" + language + "/"

    # Create unique filename from request    
    if plottype == 'Exports':
        tempString = plottype + "_" + datasource + "_" + fuel + "_" + units + "_" + str(countryID) + "_" + str(overlay) + "_" + \
                     str(yscalecode) + "_" + showmap
    elif plottype == 'Sources':
        tempString = plottype + "_" + datasource + "_" + conprod + "_" + units + "_" + str(countryID) + "_" + str(overlay) + "_" + \
                     percent

    tempString2 = re.sub('\W','_',tempString)
    unique_ID = re.sub('\_COND__','',tempString2)
    abs_img_pdf = abs_out + unique_ID + ".pdf"
    abs_img_png = abs_out + unique_ID + ".png"
    rel_img_pdf = rel_out + unique_ID + ".pdf"
    rel_img_png = rel_out + unique_ID + ".png"

    # Look for previously generated file in the output directory.
    # If not found, generate new plot.
    
    if os.path.exists(abs_img_png): # retrieve plot image from cache
        pass

    else: # generate a new plot image

        # Generate the list of countries associated with each group
        if str(countryID) == 'MZM_WORLD':
            view = 'world'
            countrylist = ['CA','US','MX',
                           'AR','BO','BR','CL','CO','EC','PE','TT','VE','BP_OSCA',
                           'AT','BP_BELU','BG','CZ','DK','FI','FR','DE','GR',
                           'HU','IS','IE','IT','NL','NO',
                           'PL','PT','RO','SK','ES','SE','CH','TR','GB','BP_OEE',
                           'BH','IR','IQ','IL','KW','OM','QA','SA','SY','YE','AE','BP_OME',
                           'DZ','AO','CM','TD','CG','EG','GQ','GA','LY',
                           'NG','SD','TN','ZA','ZW','BP_OAF',
                           'AU','BN','BD','CN','HK','IN','ID','JP','MY',
                           'NZ','PK','PH','SG','KR','MM','TW','TH','VN','BP_OAP',
                           'AM','AZ','BY','EE','GE','KZ','KG','LV','LT','MD','RU','TJ','TM','UA','UZ']
        # World (-OECD -FSU)
        elif str(countryID) == 'MZM_WORLD1':
            view = 'world'
            countrylist = ['AR','BO','BR','CL','CO','EC','PE','TT','VE','BP_OSCA',
                           'BG',
                           'BP_OEE',
                           'BH','IR','IQ','IL','KW','OM','QA','SA','SY','YE','AE','BP_OME',
                           'DZ','AO','CM','TD','CG','EG','GQ','GA','LY',
                           'NG','SD','TN','ZA','ZW','BP_OAF',
                           'BN','BD','CN','HK','IN','ID','MY',
                           'PK','PH','SG','MM','TW','TH','VN','BP_OAP']
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
        # Eurozone
        elif str(countryID) == 'MZM_EU2':
            view = 'former_soviet_union'
            countrylist = ['AT','BP_BELU','FI','FR','DE','GR','IE','IT','NL',
                           'PT','SK','ES',
                           'CY','SI','EE','MT']
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
            countrylist = ['BH','IR','IQ','IL','KW','QA','AE','SA','OM']
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
            countrylist = ['AO','LY','NG','DZ','IR','IQ','KW','QA','SA','AE','EC','VE']
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
                           'AR','BO','BR','CL','CO','PE','TT','BP_OSCA',
                           'AT','BP_BELU','BG','CZ','DK','FI','FR','DE','GR',
                           'HU','IS','IE','IT','NL','NO',
                           'PL','PT','RO','SK','ES','SE','CH','TR','GB','BP_OEE',
                           'BH','OM','SY','YE','BP_OME',
                           'CM','TD','CG','EG','GQ','GA',
                           'SD','TN','ZA','ZW','BP_OAF',
                           'AU','BN','BD','CN','HK','ID','IN','JP','MY',
                           'NZ','PK','PH','SG','KR','MM','TW','TH','VN','BP_OAP',
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
        # OECD (-US)
        elif str(countryID) == 'MZM_OECD1':
            view = 'world'
            countrylist = ['CA','MX',
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
            countrylist = ['AR','BO','BR','CL','CO','EC','PE','TT','VE','BP_OSCA']
        elif str(countryID) == 'MZM_TEE':
            view = 'former_soviet_union'
            countrylist = ['AT','AZ','BY','MZ','BG','CZ','DK','FI','FR','DE','GR','HU','IS','IE','IT','KZ',
                           'LT','NL','NO','PL','PT','RO','RU','SK','ES','SE','CH','TR','TM','UA','GB','UZ','BP_OEE']
        elif str(countryID) == 'MZM_TME':
            view = 'middle_east'
            countrylist = ['BH','IR','IQ','IL','KW','QA','AE','SA','OM','YE','SY','BP_OME']
        elif str(countryID) == 'MZM_TAF':
            view = 'africa'
            countrylist=['DZ','AO','CM','TD','CG','EG','GQ','GA','LY','NG','SD','TN','ZA','ZW','BP_OAF']
        elif str(countryID) == 'MZM_TAP':
            view = 'asia_pacific'
            countrylist=['AU','BN','BD','CN','HK','IN','ID','JP','MM','MY','NZ','PK','PH','SG','KR','TW','TH','VN','BP_OAP']
        else:
            view = 'auto'
            countrylist = [countryID]
         
        #country = get_country(language,countryID)
        # Use Babel to convert ISO-3166 codes into language specific names.
        # Special 'MZM_~' codes are handled in the language specific text_strings_~.r file.
        locale = Locale(language)
        if len(countryID) == 2:
            country = locale.territories[countryID].encode('utf-8')
        else:
            country = countryID

        script = script_dir + "OilExport.r"
        debug_text = "source('" + script + "')\n".encode('utf-8')
        debug_text += "#pdf(file='" + abs_img_pdf + "',width=8,height=8,bg='white')\n"
        tempXvar = str(countrylist)
        tempXvar2 = re.sub('\[','c(',tempXvar)
        tempXvar3 = re.sub('\]',')',tempXvar2)
        debug_text += "OilExport(plottype='" + plottype + "'" + \
                      ",language='" + language + "'" + \
                      ",showmap='" + showmap + "'" + \
                      ",percent='" + percent + "'" + \
                      ",countryID='" + countryID + "'" + \
                      ",country='" + country + "'" + \
                      ",countrylist=" + tempXvar3 + \
                      ",view=" + view + \
                      ",overlay=" + str(overlay) + \
                      ",yscalecode=" + str(yscalecode) + \
                      ",datasource='" + datasource + "'" + \
                      ",conprod='" + conprod + "'" + \
                      ",fuel='" + fuel + "'" + \
                      ",units='" + units + "')\n"
        gs_cmd = "gs -dSAFTER -dBATCH -dNOPAUSE -sDEVICE=png16m " + \
                 "-dGraphicsAlphaBits=4 -dTextAlphaBits=4 -r300 " + \
                 "-dBackgroundColor='16#ffffff' " + \
                 "-sOutputFile=" + abs_img_png + " " + abs_img_pdf + " > /dev/null"
        debug_text += gs_cmd + '\n'
        debug_text += 'mogrify -resize 500 ' + abs_img_png + ' > /dev/null\n'
        debug_text = "Issuing the following commands:\n\n" + debug_text
        print debug_text
        try:
            try:
                import rpy2.robjects as robjects
                r = robjects.r
            except Exception, e:
                status = 'ERROR'
                error_text = str(e)

            r.pdf(file=abs_img_pdf,width=8,height=8,bg='white')

            # Rpy2 requires that we convert the request into a set of arguments 
            r_command = "OilExport(plottype='" + plottype + "'" + \
                        ",language='" + language + "'" + \
                        ",showmap='" + showmap + "'" + \
                        ",countryID='" + countryID + "'" + \
                        ",country='" + country + "'" + \
                        ",countrylist=" + tempXvar3 + \
                        ",conprod='" + conprod + "'" + \
                        ",view='" + view + "'" + \
                        ",percent='" + percent + "'" + \
                        ",overlay='" + str(overlay) + "'" + \
                        ",yscalecode='" + str(yscalecode) + "'" + \
                        ",datasource='" + datasource + "'" + \
                        ",fuel='" + fuel + "'" + \
                        ",units='" + units + "')"
            r.source(script)
            r(r_command)
            r('dev.off()')

            ###from rpy import *
            ###r.source(script)
            ###r.pdf(file=abs_img_pdf,width=8,height=8,bg='white')
            ###r.OilExport(plottype=plottype,language=language,showmap=showmap,
            ###            countryID=countryID,country=country,countrylist=countrylist,
            ###            conprod=conprod,view=view,percent=percent,
            ###            overlay=overlay,yscalecode=yscalecode,datasource=datasource,fuel=fuel,units=units)
            ###
            ###r.dev_off()

            # Now convert the pdf file to png and resize 
            os.system(gs_cmd)
            os.system('mogrify -resize 500 ' + abs_img_png)

        except Exception, e:
            status = 'ERROR'
            # See INSTALLER comments on the need to sleep.
            time.sleep(sleep_amt)
            error_text = str(e)
            if error_text == 'EVERYTHING IS OK':
                 status = 'OK'
            else:
                try:
                    dbg = open(debug_file,'a')
                    dbg.write("\n\nR ERROR on " + str(time.ctime()) + ":\n")
                    dbg.write(str(e))
                    dbg.write("R COMMANDS:\n")
                    dbg.write(debug_text)
                    dbg.close()
                except Exception, e:
                    error_text = str(e)
                    print "\nAn error occurred writing the debug file: " + error_text

        else: # Successful generation of plot
            # See INSTALLER comments on the need to sleep.
            time.sleep(sleep_amt)

# NOTE:  Restore stdout (and also send errors there)?
sys.stdout.close()
sys.stdout=sys.__stdout__

if status == 'OK':
    # write out the result
    # Don't use the print statement because we don't want the '\n' appended for JSON or XML
    sys.stdout.write("Content-type: application/json\n\n")
    sys.stdout.write("{ status: \'" + status + "\', img_url: \'" + rel_img_png + \
                     "\', pdf_url: \'" + rel_img_pdf + "\' }")

elif status == 'ERROR':
    sys.stdout.write("Content-type: application/json\n\n")
    sys.stdout.write("{ status: \'" + status + "\', error_text: \'" + error_text + "\' }")

else:
    sys.stdout.write("Content-type: application/json\n\n")
    sys.stdout.write("{ status: \'ERROR\', error_text: \'An unkown error occurred.\' }")

if is_script:
    print "\n"

# All done!

