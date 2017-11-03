"""
Mazama_BP_2007.py

A script to obtain the British Petroleum Statistical Review Excel
spreadsheet and convert the contents of the worksheets into ASCII
CSV files for ingest by other software:

 * Oil Production_barrels
 * Oil Consumption_barrels
 * Gas Production_bcf
 * Gas Consumption_bcf

The xlrd module (0.6.0a1 or higher) for reading Excel files  must
be installed before this script can be run.  It is available at:

  http://www.lexicon.net/sjmachin/xlrd.htm
"""

import xlrd
import sys

########################################
# get_ISO_code
#
# Converts BP country names to ISO-3166 two-character country codes.
#
# ISO codes obtained from:
# http://www.iso.org/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1-semic.txt

def get_ISO_code(country):
  English_to_ISO = {
    "AFGHANISTAN" : "AF",
    "ALAND ISLANDS" : "AX",         # Modified original list by converting Swedish A-ring-above to 'A'
    "ALBANIA" : "AL",
    "ALGERIA" : "DZ",
    "AMERICAN SAMOA" : "AS",
    "ANDORRA" : "AD",
    "ANGOLA" : "AO",
    "ANGUILLA" : "AI",
    "ANTARCTICA" : "AQ",
    "ANTIGUA AND BARBUDA" : "AG",
    "ARGENTINA" : "AR",
    "ARMENIA" : "AM",
    "ARUBA" : "AW",
    "AUSTRALIA" : "AU",
    "AUSTRIA" : "AT",
    "AZERBAIJAN" : "AZ",
    "BAHAMAS" : "BS",
    "BAHRAIN" : "BH",
    "BANGLADESH" : "BD",
    "BARBADOS" : "BB",
    "BELARUS" : "BY",
    "BELGIUM" : "BE",
    "BELIZE" : "BZ",
    "BENIN" : "BJ",
    "BERMUDA" : "BM",
    "BHUTAN" : "BT",
    "BOLIVIA" : "BO",
    "BOSNIA AND HERZEGOVINA" : "BA",
    "BOTSWANA" : "BW",
    "BOUVET ISLAND" : "BV",
    "BRAZIL" : "BR",
    "BRITISH INDIAN OCEAN TERRITORY" : "IO",
    "BRUNEI DARUSSALAM" : "BN",
    "BULGARIA" : "BG",
    "BURKINA FASO" : "BF",
    "BURUNDI" : "BI",
    "CAMBODIA" : "KH",
    "CAMEROON" : "CM",
    "CANADA" : "CA",
    "CAPE VERDE" : "CV",
    "CAYMAN ISLANDS" : "KY",
    "CENTRAL AFRICAN REPUBLIC" : "CF",
    "CHAD" : "TD",
    "CHILE" : "CL",
    "CHINA" : "CN",
    "CHRISTMAS ISLAND" : "CX",
    "COCOS (KEELING) ISLANDS" : "CC",
    "COLOMBIA" : "CO",
    "COMOROS" : "KM",
    "CONGO" : "CG",
    "CONGO, THE DEMOCRATIC REPUBLIC OF THE" : "CD",
    "COOK ISLANDS" : "CK",
    "COSTA RICA" : "CR",
    "COTE D'IVOIRE" : "CI",
    "CROATIA" : "HR",
    "CUBA" : "CU",
    "CYPRUS" : "CY",
    "CZECH REPUBLIC" : "CZ",
    "DENMARK" : "DK",
    "DJIBOUTI" : "DJ",
    "DOMINICA" : "DM",
    "DOMINICAN REPUBLIC" : "DO",
    "ECUADOR" : "EC",
    "EGYPT" : "EG",
    "EL SALVADOR" : "SV",
    "EQUATORIAL GUINEA" : "GQ",
    "ERITREA" : "ER",
    "ESTONIA" : "EE",
    "ETHIOPIA" : "ET",
    "FALKLAND ISLANDS (MALVINAS)" : "FK",
    "FAROE ISLANDS" : "FO",
    "FIJI" : "FJ",
    "FINLAND" : "FI",
    "FRANCE" : "FR",
    "FRENCH GUIANA" : "GF",
    "FRENCH POLYNESIA" : "PF",
    "FRENCH SOUTHERN TERRITORIES" : "TF",
    "GABON" : "GA",
    "GAMBIA" : "GM",
    "GEORGIA" : "GE",
    "GERMANY" : "DE",
    "GHANA" : "GH",
    "GIBRALTAR" : "GI",
    "GREECE" : "GR",
    "GREENLAND" : "GL",
    "GRENADA" : "GD",
    "GUADELOUPE" : "GP",
    "GUAM" : "GU",
    "GUATEMALA" : "GT",
    "GUERNSEY" : "GG",
    "GUINEA" : "GN",
    "GUINEA-BISSAU" : "GW",
    "GUYANA" : "GY",
    "HAITI" : "HT",
    "HEARD ISLAND AND MCDONALD ISLANDS" : "HM",
    "HOLY SEE (VATICAN CITY STATE)" : "VA",
    "HONDURAS" : "HN",
    "HONG KONG" : "HK",
    "HUNGARY" : "HU",
    "ICELAND" : "IS",
    "INDIA" : "IN",
    "INDONESIA" : "ID",
    "IRAN, ISLAMIC REPUBLIC OF" : "IR",
    "IRAQ" : "IQ",
    "IRELAND" : "IE",
    "ISLE OF MAN" : "IM",
    "ISRAEL" : "IL",
    "ITALY" : "IT",
    "JAMAICA" : "JM",
    "JAPAN" : "JP",
    "JERSEY" : "JE",
    "JORDAN" : "JO",
    "KAZAKHSTAN" : "KZ",
    "KENYA" : "KE",
    "KIRIBATI" : "KI",
    "KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF" : "KP",
    "KOREA, REPUBLIC OF" : "KR",
    "KUWAIT" : "KW",
    "KYRGYZSTAN" : "KG",
    "LAO PEOPLE'S DEMOCRATIC REPUBLIC" : "LA",
    "LATVIA" : "LV",
    "LEBANON" : "LB",
    "LESOTHO" : "LS",
    "LIBERIA" : "LR",
    "LIBYAN ARAB JAMAHIRIYA" : "LY",
    "LIECHTENSTEIN" : "LI",
    "LITHUANIA" : "LT",
    "LUXEMBOURG" : "LU",
    "MACAO" : "MO",
    "MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF" : "MK",
    "MADAGASCAR" : "MG",
    "MALAWI" : "MW",
    "MALAYSIA" : "MY",
    "MALDIVES" : "MV",
    "MALI" : "ML",
    "MALTA" : "MT",
    "MARSHALL ISLANDS" : "MH",
    "MARTINIQUE" : "MQ",
    "MAURITANIA" : "MR",
    "MAURITIUS" : "MU",
    "MAYOTTE" : "YT",
    "MEXICO" : "MX",
    "MICRONESIA, FEDERATED STATES OF" : "FM",
    "MOLDOVA, REPUBLIC OF" : "MD",
    "MONACO" : "MC",
    "MONGOLIA" : "MN",
    "MONTENEGRO" : "ME",
    "MONTSERRAT" : "MS",
    "MOROCCO" : "MA",
    "MOZAMBIQUE" : "MZ",
    "MYANMAR" : "MM",
    "NAMIBIA" : "NA",
    "NAURU" : "NR",
    "NEPAL" : "NP",
    "NETHERLANDS" : "NL",
    "NETHERLANDS ANTILLES" : "AN",
    "NEW CALEDONIA" : "NC",
    "NEW ZEALAND" : "NZ",
    "NICARAGUA" : "NI",
    "NIGER" : "NE",
    "NIGERIA" : "NG",
    "NIUE" : "NU",
    "NORFOLK ISLAND" : "NF",
    "NORTHERN MARIANA ISLANDS" : "MP",
    "NORWAY" : "NO",
    "OMAN" : "OM",
    "PAKISTAN" : "PK",
    "PALAU" : "PW",
    "PALESTINIAN TERRITORY, OCCUPIED" : "PS",
    "PANAMA" : "PA",
    "PAPUA NEW GUINEA" : "PG",
    "PARAGUAY" : "PY",
    "PERU" : "PE",
    "PHILIPPINES" : "PH",
    "PITCAIRN" : "PN",
    "POLAND" : "PL",
    "PORTUGAL" : "PT",
    "PUERTO RICO" : "PR",
    "QATAR" : "QA",
    "REUNION" : "RE",
    "ROMANIA" : "RO",
    "RUSSIAN FEDERATION" : "RU",
    "RWANDA" : "RW",
    "SAINT HELENA" : "SH",
    "SAINT KITTS AND NEVIS" : "KN",
    "SAINT LUCIA" : "LC",
    "SAINT PIERRE AND MIQUELON" : "PM",
    "SAINT VINCENT AND THE GRENADINES" : "VC",
    "SAMOA" : "WS",
    "SAN MARINO" : "SM",
    "SAO TOME AND PRINCIPE" : "ST",
    "SAUDI ARABIA" : "SA",
    "SENEGAL" : "SN",
    "SERBIA" : "RS",
    "SEYCHELLES" : "SC",
    "SIERRA LEONE" : "SL",
    "SINGAPORE" : "SG",
    "SLOVAKIA" : "SK",
    "SLOVENIA" : "SI",
    "SOLOMON ISLANDS" : "SB",
    "SOMALIA" : "SO",
    "SOUTH AFRICA" : "ZA",
    "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS" : "GS",
    "SPAIN" : "ES",
    "SRI LANKA" : "LK",
    "SUDAN" : "SD",
    "SURINAME" : "SR",
    "SVALBARD AND JAN MAYEN" : "SJ",
    "SWAZILAND" : "SZ",
    "SWEDEN" : "SE",
    "SWITZERLAND" : "CH",
    "SYRIAN ARAB REPUBLIC" : "SY",
    "TAIWAN, PROVINCE OF CHINA" : "TW",
    "TAJIKISTAN" : "TJ",
    "TANZANIA, UNITED REPUBLIC OF" : "TZ",
    "THAILAND" : "TH",
    "TIMOR-LESTE" : "TL",
    "TOGO" : "TG",
    "TOKELAU" : "TK",
    "TONGA" : "TO",
    "TRINIDAD AND TOBAGO" : "TT",
    "TUNISIA" : "TN",
    "TURKEY" : "TR",
    "TURKMENISTAN" : "TM",
    "TURKS AND CAICOS ISLANDS" : "TC",
    "TUVALU" : "TV",
    "UGANDA" : "UG",
    "UKRAINE" : "UA",
    "UNITED ARAB EMIRATES" : "AE",
    "UNITED KINGDOM" : "GB",
    "UNITED STATES" : "US",
    "UNITED STATES MINOR OUTLYING ISLANDS" : "UM",
    "URUGUAY" : "UY",
    "UZBEKISTAN" : "UZ",
    "VANUATU" : "VU",
    "VENEZUELA" : "VE",
    "VIET NAM" : "VN",
    "VIRGIN ISLANDS, BRITISH" : "VG",
    "VIRGIN ISLANDS, U.S." : "VI",
    "WALLIS AND FUTUNA" : "WF",
    "WESTERN SAHARA" : "EH",
    "YEMEN" : "YE",
    "ZAMBIA" : "ZM",
    "ZIMBABWE" : "ZW"
  }

  # Convert country argument to upper case
  up_country = country.upper()

  # Attempt to convert all region names to ISO codes.
  # Catch any exceptions and test those against other acceptable names.
  # Where a region is used that has no ISO country counterpart, create
  # a code that cannot possibly be confused with a country code (e.g. 'BP_01').
  try: 
    code = English_to_ISO[up_country]
  except:
    # Regions first encountered on oil the production worksheet
    if up_country == "THOUSAND BARRELS DAILY":
      code = up_country
    elif up_country == "USA":
      code = 'US'
    elif up_country == "TOTAL NORTH AMERICA":
      code = 'BP_01'
    elif up_country == "TRINIDAD & TOBAGO":
      code = 'TT'
    elif up_country == "OTHER S. & CENT. AMERICA":
      code = 'BP_02'
    elif up_country == "TOTAL S. & CENT. AMERICA":
      code = 'BP_03'
    elif up_country == "OTHER EUROPE & EURASIA":
      code = 'BP_04'
    elif up_country == "TOTAL EUROPE & EURASIA":
      code = 'BP_05'
    elif up_country == 'IRAN':
      code = 'IR'
    elif up_country == 'SYRIA':
      code = 'SY'
    elif up_country == 'OTHER MIDDLE EAST':
      code = 'BP_06'
    elif up_country == 'TOTAL MIDDLE EAST':
      code = 'BP_07'
    elif up_country == "REP. OF CONGO (BRAZZAVILLE)":
      code = 'CG'
    elif up_country == "LIBYA":
      code = 'LY'
    elif up_country == "OTHER AFRICA":
      code = 'BP_08'
    elif up_country == "TOTAL AFRICA":
      code = 'BP_09'
    elif up_country == "BRUNEI":
      code = 'BN'
    elif up_country == "VIETNAM":
      code = 'VN'
    elif up_country == "OTHER ASIA PACIFIC":
      code = 'BP_10'
    elif up_country == "TOTAL ASIA PACIFIC":
      code = 'BP_11'
    elif up_country == "TOTAL WORLD":
      code = 'BP_12'
    elif up_country == "OF WHICH: EUROPEAN UNION 25 #":
      code = 'BP_13'
    elif up_country == "EUROPEAN UNION 27 #":
      code = 'BP_14'
    elif up_country == "OECD":
      code = 'BP_15'
    elif up_country == "OPEC 11":
      code = 'BP_16'
    elif up_country == "OPEC 12":
      code = 'BP_17'
    elif up_country == "NON-OPEC":
      code = 'BP_18'
    elif up_country == "FORMER SOVIET UNION":
      code = 'BP_19'
    # Regions first encountered on the oil consumption worksheet
    elif up_country == "BELGIUM & LUXEMBOURG":
      code = 'BP_20'
    elif up_country == "REPUBLIC OF IRELAND":
      code = 'IE'
    elif up_country == "CHINA HONG KONG SAR":
      code = 'BP_21'
    elif up_country == "SOUTH KOREA":
      code = 'KR'
    elif up_country == "TAIWAN":
      code = 'TW'
    elif up_country == "OTHER EMES":
      code = 'BP_22'
    # Regions first encountered on the gas production worksheet
    elif up_country == "BILLION CUBIC FEET PER DAY":
      code = up_country
    # Regions first encountered on the gas consumption worksheet
    # Regions that are still unrecognized
    else:
      print "Cannot convert \"%s\" to ISO code" % (up_country)
      sys.exit(1)

  return code

########################################
# get_row_data
# 
# Reads part of a row of numeric data from a worksheet, converting
# string values to float where appropriate.
#
# From help(xlrd):
#   XL_CELL_EMPTY   = 0
#   XL_CELL_TEXT    = 1
#   XL_CELL_NUMBER  = 2
#   XL_CELL_DATE    = 3
#   XL_CELL_BOOLEAN = 4
#   XL_CELL_ERROR   = 5
#   XL_CELL_BLANK   = 6

def get_row_data(workbook, sheet, row, colrange):
  result = []
  row_types = sheet.row_types(row)
  row_values = sheet.row_values(row)

  # Go through every in this row cell and check it's type.
  for col in colrange:
    cell_type = row_types[col]
    cell_value = row_values[col]

    # Cells with text are converted directly to float with the following
    # exceptions:
    #   u'-'   is converted to 0.0
    #   u'^'   is converted to 0.0
    #   u'n/a' is converted to "NA"
    if cell_type == xlrd.XL_CELL_TEXT:
      value = cell_value
      if cell_value == u'-':
        value = float(0.0)
        cell_type = xlrd.XL_CELL_NUMBER
      elif cell_value == u'^':
        value = float(0.0)
        cell_type = xlrd.XL_CELL_NUMBER
      elif cell_value == u'n/a':
        value = "NA"
      else:
        value = float(cell_value)
        cell_type = xlrd.XL_CELL_NUMBER

    # Cells with numbers do not need conversion.
    elif cell_type == xlrd.XL_CELL_NUMBER:
      value = cell_value

    # Cells of any other type are considered errors.
    else:
      print "UNKNOWN data type in row %d, col %d" % (row,col)
      sys.exit(1)

    result.append((cell_type, value))
  return result

##############################################################################
# Main program
#
def main():

  logfile = open('Mazama_2007.log', 'w')
  # NOTE:  The original 2006 BP file was called 'statistical_review_full_report_workbook_2006.xls'
  # NOTE:  BP doesn't keep the old reports around so I grabbed 2002-2007 from ASPO at this URL:
  # NOTE:    http://www.tsl.uu.se/uhdsg/Data/
  stat_review = 'BP_2007.xls'
  oil_production = open('BP_2007_OilProduction.csv','w')
  oil_consumption = open('BP_2007_OilConsumption.csv','w')
  gas_production = open('BP_2007_GasProduction.csv','w')
  gas_consumption = open('BP_2007_GasConsumption.csv','w')

  try:
    workbook = xlrd.open_workbook(stat_review, logfile=logfile)
  except xlrd.XLRDError:
    print >> logfile, "*** Open failed: %s: %s" % sys.exc_info()[:2]
  except:
    print >> logfile, "*** Open failed: %s: %s" % sys.exc_info()[:2]

  # OIL PRODUCTION ________________________________________

  # Worksheet 4 (python index 3) is titled "Oil Production_barrels"
  sheet = workbook.sheet_by_index(3)

  # Rows as seen in Excel (subtract 1 to get the initial python indexes)
  # The python range(n,m) function produces [n,n+1,n+2,...,m-1]
  # 3     Years
  # 5-8   North America
  # 10-18 South America
  # 20-31 Europe
  # 33-43 Middle East
  # 45-58 Africa
  # 60-69 Asia
  # 71-78 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,31)
  ME = range(32,43)
  Africa = range(44,58)
  Asia = range(59,69)
  Special = range(70,78)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = xrange(1,43)
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Remove pound sterling sign (u'\xa3') from 'Non-OPEC'
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###production.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region);
    oil_production.write("\"%s\"" % ISO_code)
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          oil_production.write(",%d" % int(value))
        else:
          oil_production.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        oil_production.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    oil_production.write("\n");

  print "Finished with Oil Production Worksheet"

  # OIL CONSUMPTION ________________________________________

  # Worksheet 6 (python index 5) is titled "Oil Consumption_barrels"
  sheet = workbook.sheet_by_index(5)

  # Rows as seen in Excel (subtract 1 to get initial python indexes)
  # The python range(n,m) function produces [n,n+1,n+2,...,m-1]
  # 3     Years
  # 5-8   North America
  # 10-18 South America
  # 20-53 Europe
  # 55-61 Middle East
  # 63-67 Africa
  # 69-85 Asia
  # 87-92 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,92)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = xrange(1,43)
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region);
    oil_consumption.write("\"%s\"" % ISO_code)
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          oil_consumption.write(",%d" % int(value))
        else:
          oil_consumption.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        oil_consumption.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    oil_consumption.write("\n");

  print "Finished with Oil Consumption Worksheet"


  # GAS PRODUCTION ________________________________________

  # Worksheet 20 (python index 19) is titled "Gas Production_bcf"
  sheet = workbook.sheet_by_index(19)

  # Rows as seen in Excel (subtract 1 to get the initial python indexes
  # but leave the final indices as they are).  The python range(n,m) 
  # function produces [n,n+1,n+2,...,m-1]
  #
  # 3     Years
  # 5-8   North America
  # 10-17 South America
  # 19-34 Europe
  # 36-45 Middle East
  # 47-52 Africa
  # 54-67 Asia
  # 69-74 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,17)
  Europe = range(18,34)
  ME = range(35,45)
  Africa = range(46,52)
  Asia = range(53,67)
  Special = range(68,74)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = xrange(1,38)
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Remove pound sterling sign (u'\xa3') from 'Non-OPEC'
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###production.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region);
    gas_production.write("\"%s\"" % ISO_code)
    for year in range(1965,1970):
      if row == 2:
        gas_production.write(",%d" % year)
      else:
        gas_production.write(",NA")
     
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          gas_production.write(",%d" % int(value))
        else:
          gas_production.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        gas_production.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    gas_production.write("\n");

  print "Finished with Gas Production Worksheet"

  # GAS CONSUMPTION ________________________________________

  # Worksheet 23 (python index 22) is titled "Gas Consumption_bcf"
  sheet = workbook.sheet_by_index(22)

  # Rows as seen in Excel (subtract 1 to get the initial python indexes
  # but leave the final indices as they are).  The python range(n,m) 
  # function produces [n,n+1,n+2,...,m-1]
  # 3     Years
  # 5-8   North America
  # 10-18 South America
  # 20-53 Europe
  # 55-61 Middle East
  # 63-67 Africa
  # 69-85 Asia
  # 87-92 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,92)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = xrange(1,43)
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region);
    gas_consumption.write("\"%s\"" % ISO_code)
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          gas_consumption.write(",%d" % int(value))
        else:
          gas_consumption.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        gas_consumption.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    gas_consumption.write("\n");

  print "Finished with Gas Consumption Worksheet"

if __name__ == "__main__":
  main()
