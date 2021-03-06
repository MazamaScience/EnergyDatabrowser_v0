"""
Mazama_BP_2008.py

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
  # a code that cannot possibly be confused with a country code (e.g. 'BP_TNA').
  try: 
    code = English_to_ISO[up_country]
  except:
    # Regions first encountered on oil the production worksheet
    if up_country == "THOUSAND BARRELS DAILY":
      code = 'YEAR'
    elif up_country == "US":
      code = 'US'
    elif up_country == "TOTAL NORTH AMERICA":
      code = 'BP_TNA'
    elif up_country == "TRINIDAD & TOBAGO":
      code = 'TT'
    elif up_country == "OTHER S. & CENT. AMERICA":
      code = 'BP_OSCA'
    elif up_country == "TOTAL S. & CENT. AMERICA":
      code = 'BP_TSCA'
    elif up_country == "OTHER EUROPE & EURASIA":
      code = 'BP_OEE'
    elif up_country == "TOTAL EUROPE & EURASIA":
      code = 'BP_TEE'
    elif up_country == 'IRAN':
      code = 'IR'
    elif up_country == 'SYRIA':
      code = 'SY'
    elif up_country == 'OTHER MIDDLE EAST':
      code = 'BP_OME'
    elif up_country == 'TOTAL MIDDLE EAST':
      code = 'BP_TME'
    elif up_country == "REP. OF CONGO (BRAZZAVILLE)":
      code = 'CG'
    elif up_country == "REPUBLIC OF CONGO (BRAZZAVILLE)":
      code = 'CG'
    elif up_country == "LIBYA":
      code = 'LY'
    elif up_country == "OTHER AFRICA":
      code = 'BP_OAF'
    elif up_country == "TOTAL AFRICA":
      code = 'BP_TAF'
    elif up_country == "BRUNEI":
      code = 'BN'
    elif up_country == "VIETNAM":
      code = 'VN'
    elif up_country == "OTHER ASIA PACIFIC":
      code = 'BP_OAP'
    elif up_country == "TOTAL ASIA PACIFIC":
      code = 'BP_TAP'
    elif up_country == "TOTAL WORLD":
      code = 'BP_WORLD'
    elif up_country == "OF WHICH: EUROPEAN UNION #":
      code = 'BP_EU1'
    elif up_country == "EUROPEAN UNION #":
      code = 'BP_EU2'
    elif up_country == "OECD":
      code = 'BP_OECD'
    elif up_country == "OPEC":
      code = 'BP_OPEC'
    elif up_country == "OPEC 10":
      code = 'BP_OPEC10'
    elif up_country == "NON-OPEC":
      code = 'BP_NONOPEC'
    elif up_country == "FORMER SOVIET UNION":
      code = 'BP_FSU'
    # Regions first encountered on the oil consumption worksheet
    elif up_country == "BELGIUM & LUXEMBOURG":
      code = 'BP_BELU'
    elif up_country == "REPUBLIC OF IRELAND":
      code = 'IE'
    elif up_country == "CHINA HONG KONG SAR":
      code = 'HK'
    elif up_country == "SOUTH KOREA":
      code = 'KR'
    elif up_country == "TAIWAN":
      code = 'TW'
    elif up_country == "OTHER EMES":
      code = 'BP_EMES'
    # Regions first encountered on the gas production worksheet
    elif up_country == "BILLION CUBIC FEET PER DAY":
      code = 'YEAR'
    elif up_country == "MILLION TONNES OIL EQUIVALENT":
      code = 'YEAR'
    # Regions first encountered on the gas consumption worksheet
    # Regions first encountered on the oil (mtoe) worksheet
    elif up_country == "MILLION TONNES":
      code = 'YEAR'
    # Regions first encountered on the gas production (bcm) worksheet
    elif up_country == "BILLION CUBIC METRES":
      code = 'YEAR'
    # Regions first encountered on the nuclear consumption worksheets
    elif up_country == "TERAWATT-HOURS":
      code = 'YEAR'
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
    #   u'n/a' is converted to "na"
    if cell_type == xlrd.XL_CELL_TEXT:
      value = cell_value
      if cell_value == u'-':
        value = float(0.0)
        cell_type = xlrd.XL_CELL_NUMBER
      elif cell_value == u'^':
        value = float(0.0)
        cell_type = xlrd.XL_CELL_NUMBER
      elif cell_value == u'n/a':
        value = "na"
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

  logfile = open('Mazama_2008.log', 'w')
  # NOTE:  The original 2006 BP file was called 'statistical_review_full_report_workbook_2006.xls'
  # NOTE:  BP doesn't keep the old reports around so I grabbed 2002-2008 from ASPO at this URL:
  # NOTE:    http://www.tsl.uu.se/uhdsg/Data/
  stat_review = 'BP_2008.xls'

  try:
    workbook = xlrd.open_workbook(stat_review, logfile=logfile)
  except xlrd.XLRDError:
    print >> logfile, "*** Open failed: %s: %s" % sys.exc_info()[:2]
  except:
    print >> logfile, "*** Open failed: %s: %s" % sys.exc_info()[:2]

  # OIL PRODUCTION (bbl) ___________________________________

  oil_production = open('BP_2008_oil_production_bbl.csv','w')
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
  # 71-77 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,31)
  ME = range(32,43)
  Africa = range(44,58)
  Asia = range(59,69)
  Special = range(70,77)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)

  oil_production.write("title         = ASCII CSV version of Oil Production data from the 2008 British Petroleum Statistical Review (worksheet 4)\n")
  oil_production.write("file URL      = http://mazamascience.com/OilExport/BP_2008_oil_production.csv\n")
  oil_production.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  oil_production.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  oil_production.write("units         = thousand barrels per day\n")
  oil_production.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Remove pound sterling sign (u'\xa3') from 'Non-OPEC'
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###production.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
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

    oil_production.write("\n")

  oil_production.close()

  print "Finished with Oil Production (bbl) Worksheet"

  # OIL PRODUCTION (mtoe) __________________________________

  oil_production = open('BP_2008_oil_production_mtoe.csv','w')
  # Worksheet 5 (python index 4) is titled "Oil Production_tonnes"
  sheet = workbook.sheet_by_index(4)

  # Rows as seen in Excel (subtract 1 to get the initial python indexes)
  # The python range(n,m) function produces [n,n+1,n+2,...,m-1]
  # 3     Years
  # 5-8   North America
  # 10-18 South America
  # 20-31 Europe
  # 33-43 Middle East
  # 45-58 Africa
  # 60-69 Asia
  # 71-77 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,31)
  ME = range(32,43)
  Africa = range(44,58)
  Asia = range(59,69)
  Special = range(70,77)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)

  oil_production.write("title         = ASCII CSV version of Oil Production data from the 2008 British Petroleum Statistical Review (worksheet 5)\n")
  oil_production.write("file URL      = http://mazamascience.com/OilExport/BP_2008_oil_production_mtoe.csv\n")
  oil_production.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  oil_production.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  oil_production.write("units         = million tonnes per year\n")
  oil_production.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Remove pound sterling sign (u'\xa3') from 'Non-OPEC'
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###production.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
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

    oil_production.write("\n")

  oil_production.close()

  print "Finished with Oil Production (mtoe) Worksheet"

  # OIL CONSUMPTION (bbl) ___________________________________

  oil_consumption = open('BP_2008_oil_consumption_bbl.csv','w')
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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  oil_consumption.write("title         = ASCII CSV version of Oil consumption data from the 2008 British Petroleum Statistical Review (worksheet 6)\n")
  oil_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_oil_consumption_bbl.csv\n")
  oil_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  oil_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  oil_consumption.write("units         = thousand barrels per day\n")
  oil_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
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

    oil_consumption.write("\n")

  oil_consumption.close()

  print "Finished with Oil Consumption (bbl) Worksheet"


  # OIL CONSUMPTION (mtoe) __________________________________

  oil_consumption = open('BP_2008_oil_consumption_mtoe.csv','w')
  # Worksheet 7 (python index 6) is titled "Oil Consumption_barrels"
  sheet = workbook.sheet_by_index(6)

  # Rows as seen in Excel (subtract 1 to get initial python indexes)
  # The python range(n,m) function produces [n,n+1,n+2,...,m-1]
  # 3     Years
  # 5-8   North America
  # 10-18 South America
  # 20-53 Europe
  # 55-61 Middle East
  # 63-67 Africa
  # 69-85 Asia
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  oil_consumption.write("title         = ASCII CSV version of Oil consumption data from the 2008 British Petroleum Statistical Review (worksheet 7)\n")
  oil_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_oil_consumption_mtoe.csv\n")
  oil_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  oil_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  oil_consumption.write("units         = million tonnes per year\n")
  oil_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
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

    oil_consumption.write("\n")

  oil_consumption.close()

  print "Finished with Oil Consumption (bbl) Worksheet"


  # CRUDE PRICES  ________________________________________

  crude_prices = open('BP_2008_oil_crude_prices_since_1861.csv','w')
  # Worksheet 10 (python index 9) is titled "Oil_crude prices since 1861"
  sheet = workbook.sheet_by_index(9)

  # Rows as seen in Excel (subtract 1 to get the initial python indexes
  # but leave the final indices as they are).  The python range(n,m) 
  # function produces [n,n+1,n+2,...,m-1]
  # 109    1965
  # 151    2007
  rowrange = range(108,151)
  colrange = range(0,3)
  crude_prices.write("title            = ASCII CSV version of crude prices from the 2008 British Petroleum Statistical Review (worksheet 10, years 1965-2007 only)\n")
  crude_prices.write("file URL         = http://mazamascience.com/OilExport/BP_2008_oil_crude_prices_since_1861.csv\n")
  crude_prices.write("original data    = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  crude_prices.write("nominal_dollars  = money of the day\n")
  crude_prices.write("current_dollars  = 2007 dollars\n")
  crude_prices.write("\n")
  year = []
  nominal_dollars = []
  current_dollars = []
  for row in rowrange:
    row_values = sheet.row_values(row)
    year.append(int(row_values[0]))
    nominal_dollars.append(row_values[1])
    current_dollars.append(row_values[2])

  crude_prices.write("\"YEAR\"," + str(year).replace('[','').replace(']','').replace(' ','') + "\n")
  crude_prices.write("\"nominal_dollars\"")
  for price in nominal_dollars:
    crude_prices.write(",%.2f" % price)
  crude_prices.write("\n")
  crude_prices.write("\"current_dollars\"")
  for price in current_dollars:
    crude_prices.write(",%.2f" % price)
  crude_prices.write("\n")

  crude_prices.close()

  print "Finished with 'Oil_prices since 1861' Workheet"


  # GAS PRODUCTION (m3) ____________________________________

  gas_production = open('BP_2008_gas_production_m3.csv','w')
  # Worksheet 19 (python index 18) is titled "Gas Production_bcm"
  sheet = workbook.sheet_by_index(18)

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
  # 69-73 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,17)
  Europe = range(18,34)
  ME = range(35,45)
  Africa = range(46,52)
  Asia = range(53,67)
  Special = range(68,73)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,39)
  gas_production.write("title         = ASCII CSV version of Natural Gas production data from the 2008 British Petroleum Statistical Review (worksheet 19)\n")
  gas_production.write("file URL      = http://mazamascience.com/OilExport/BP_2008_gas_production_m3.csv\n")
  gas_production.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  gas_production.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  gas_production.write("units         = billion cubic meters per year\n")
  gas_production.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Remove pound sterling sign (u'\xa3') from 'Non-OPEC'
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###production.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    gas_production.write("\"%s\"" % ISO_code)
    for year in range(1965,1970):
      if row == 2:
        gas_production.write(",%d" % year)
      else:
        gas_production.write(",\"na\"")
     
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

    gas_production.write("\n")

  gas_production.close()

  print "Finished with Gas Production (m3) Worksheet"


  # GAS PRODUCTION (ft3) ___________________________________

  gas_production = open('BP_2008_gas_production_ft3.csv','w')
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
  # 69-73 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,17)
  Europe = range(18,34)
  ME = range(35,45)
  Africa = range(46,52)
  Asia = range(53,67)
  Special = range(68,73)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,39)
  gas_production.write("title         = ASCII CSV version of Natural Gas production data from the 2008 British Petroleum Statistical Review (worksheet 20)\n")
  gas_production.write("file URL      = http://mazamascience.com/OilExport/BP_2008_gas_production_ft3.csv\n")
  gas_production.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  gas_production.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  gas_production.write("units         = billion cubic feet per day\n")
  gas_production.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Remove pound sterling sign (u'\xa3') from 'Non-OPEC'
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###production.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    gas_production.write("\"%s\"" % ISO_code)
    for year in range(1965,1970):
      if row == 2:
        gas_production.write(",%d" % year)
      else:
        gas_production.write(",\"na\"")
     
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

    gas_production.write("\n")

  gas_production.close()

  print "Finished with Gas Production (ft3) Worksheet"


  # GAS PRODUCTION (mtoe) __________________________________

  gas_production = open('BP_2008_gas_production_mtoe.csv','w')
  # Worksheet 21 (python index 20) is titled "Gas Production_mtoe"
  sheet = workbook.sheet_by_index(20)

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
  # 69-73 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,17)
  Europe = range(18,34)
  ME = range(35,45)
  Africa = range(46,52)
  Asia = range(53,67)
  Special = range(68,73)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,39)
  gas_production.write("title         = ASCII CSV version of Natural Gas production data from the 2008 British Petroleum Statistical Review (worksheet 21)\n")
  gas_production.write("file URL      = http://mazamascience.com/OilExport/BP_2008_gas_production_mtoe.csv\n")
  gas_production.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  gas_production.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  gas_production.write("units         = million tonnes oil equivalent per year\n")
  gas_production.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Remove pound sterling sign (u'\xa3') from 'Non-OPEC'
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###production.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    gas_production.write("\"%s\"" % ISO_code)
    for year in range(1965,1970):
      if row == 2:
        gas_production.write(",%d" % year)
      else:
        gas_production.write(",\"na\"")
     
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

    gas_production.write("\n")

  gas_production.close()

  print "Finished with Gas Production (mtoe) Worksheet"


  # GAS CONSUMPTION (m3) ___________________________________

  gas_consumption = open('BP_2008_gas_consumption_m3.csv','w')
  # Worksheet 22 (python index 21) is titled "Gas Consumption_bcm"
  sheet = workbook.sheet_by_index(21)

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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  gas_consumption.write("title         = ASCII CSV version of Natural Gas consumption data from the 2008 British Petroleum Statistical Review (worksheet 22)\n")
  gas_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_gas_consumption_m3.csv\n")
  gas_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  gas_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  gas_consumption.write("units         = billion cubic meters per year\n")
  gas_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
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

    gas_consumption.write("\n")

  gas_consumption.close()

  print "Finished with Gas Consumption (m3) Worksheet"


  # GAS CONSUMPTION (bcf) ___________________________________

  gas_consumption = open('BP_2008_gas_consumption_ft3.csv','w')
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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  gas_consumption.write("title         = ASCII CSV version of Natural Gas consumption data from the 2008 British Petroleum Statistical Review (worksheet 23)\n")
  gas_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_gas_consumption_ft3.csv\n")
  gas_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  gas_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  gas_consumption.write("units         = billion cubic feet per day\n")
  gas_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
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

    gas_consumption.write("\n")

  gas_consumption.close()

  print "Finished with Gas Consumption (ft3) Worksheet"


  # GAS CONSUMPTION (mtoe) __________________________________

  gas_consumption = open('BP_2008_gas_consumption_mtoe.csv','w')
  # Worksheet 24 (python index 23) is titled "Gas Consumption_mtoe"
  sheet = workbook.sheet_by_index(23)

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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  gas_consumption.write("title         = ASCII CSV version of Natural Gas consumption data from the 2008 British Petroleum Statistical Review (worksheet 24)\n")
  gas_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_gas_consumption_mtoe.csv\n")
  gas_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  gas_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  gas_consumption.write("units         = million tonnes oil equivalent per year\n")
  gas_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
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

    gas_consumption.write("\n")

  gas_consumption.close()

  print "Finished with Gas Consumption (mtoe) Worksheet"


  # COAL PRODUCTION (mtoe) __________________________________

  coal_production = open('BP_2008_coal_production_mtoe.csv','w')
  # Worksheet 30 (python index 29) is titled "Coal Production_mtoe"
  sheet = workbook.sheet_by_index(29)

  # Rows as seen in Excel (subtract 1 to get the initial python indexes
  # but leave the final indices as they are).  The python range(n,m) 
  # function produces [n,n+1,n+2,...,m-1]
  #
  # 3     Years
  # 5-8   North America
  # 10-14 South America
  # 16-31 Europe
  # 33    Middle East
  # 35-38 Africa
  # 40-51 Asia
  # 53-57 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,14)
  Europe = range(15,31)
  ME = [32]
  Africa = range(34,38)
  Asia = range(39,51)
  Special = range(52,57)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,28)
  coal_production.write("title         = ASCII CSV version of Coal production data from the 2008 British Petroleum Statistical Review (worksheet 30)\n")
  coal_production.write("file URL      = http://mazamascience.com/OilExport/BP_2008_coal_production_mtoe.csv\n")
  coal_production.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  coal_production.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  coal_production.write("units         = million tonnes oil equivalent per year\n")
  coal_production.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Remove pound sterling sign (u'\xa3') from 'Non-OPEC'
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###production.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    coal_production.write("\"%s\"" % ISO_code)
    for year in range(1965,1981):
      if row == 2:
        coal_production.write(",%d" % year)
      else:
        coal_production.write(",\"na\"")
     
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          coal_production.write(",%d" % int(value))
        else:
          coal_production.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        coal_production.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    coal_production.write("\n")

  coal_production.close()

  print "Finished with Coal Production (mtoe) Worksheet"


  # COAL CONSUMPTION (mtoe) __________________________________

  coal_consumption = open('BP_2008_coal_consumption_mtoe.csv','w')
  # Worksheet 31 (python index 30) is titled "Coal_Consumption mtoe"
  sheet = workbook.sheet_by_index(30)

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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  coal_consumption.write("title         = ASCII CSV version of Coal consumption data from the 2008 British Petroleum Statistical Review (worksheet 31)\n")
  coal_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_coal_consumption_mtoe.csv\n")
  coal_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  coal_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  coal_consumption.write("units         = million tonnes oil equivalent per year\n")
  coal_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    coal_consumption.write("\"%s\"" % ISO_code)
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          coal_consumption.write(",%d" % int(value))
        else:
          coal_consumption.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        coal_consumption.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    coal_consumption.write("\n")

  coal_consumption.close()

  print "Finished with Coal Consumption (mtoe) Worksheet"


  # NUCLEAR CONSUMPTION (twh) ___________________________________

  nuclear_consumption = open('BP_2008_nuclear_consumption_twh.csv','w')
  # Worksheet 33 (python index 32) is titled "Nuclear_Energy_Consumption TWh"
  sheet = workbook.sheet_by_index(32)

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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  nuclear_consumption.write("title         = ASCII CSV version of Nuclear consumption data from the 2008 British Petroleum Statistical Review (worksheet 33)\n")
  nuclear_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_nuclear_consumption_twh.csv\n")
  nuclear_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  nuclear_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  nuclear_consumption.write("units         = Terawatt-hours per year\n")
  nuclear_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    nuclear_consumption.write("\"%s\"" % ISO_code)
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          nuclear_consumption.write(",%d" % int(value))
        else:
          nuclear_consumption.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        nuclear_consumption.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    nuclear_consumption.write("\n")

  nuclear_consumption.close()

  print "Finished with Nuclear Consumption (twh) Worksheet"


  # NUCLEAR CONSUMPTION (mtoe) ___________________________________

  nuclear_consumption = open('BP_2008_nuclear_consumption_mtoe.csv','w')
  # Worksheet 34 (python index 33) is titled "Nuclear_Energy_Consumption mtoe"
  sheet = workbook.sheet_by_index(33)

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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  nuclear_consumption.write("title         = ASCII CSV version of Nuclear consumption data from the 2008 British Petroleum Statistical Review (worksheet 34)\n")
  nuclear_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_nuclear_consumption_mtoe.csv\n")
  nuclear_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  nuclear_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  nuclear_consumption.write("units         = million tonnes oil equivalent per year\n")
  nuclear_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    nuclear_consumption.write("\"%s\"" % ISO_code)
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          nuclear_consumption.write(",%d" % int(value))
        else:
          nuclear_consumption.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        nuclear_consumption.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    nuclear_consumption.write("\n")

  nuclear_consumption.close()

  print "Finished with Nuclear Consumption (mtoe) Worksheet"


  # HYDRO CONSUMPTION (twh) ___________________________________

  hydro_consumption = open('BP_2008_hydro_consumption_twh.csv','w')
  # Worksheet 35 (python index 34) is titled "Hydro_Energy_Consumption twh"
  sheet = workbook.sheet_by_index(34)

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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  hydro_consumption.write("title         = ASCII CSV version of Hydro consumption data from the 2008 British Petroleum Statistical Review (worksheet 35)\n")
  hydro_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_hydro_consumption_twh.csv\n")
  hydro_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  hydro_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  hydro_consumption.write("units         = Terawatt-hours per year\n")
  hydro_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    hydro_consumption.write("\"%s\"" % ISO_code)
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          hydro_consumption.write(",%d" % int(value))
        else:
          hydro_consumption.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        hydro_consumption.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    hydro_consumption.write("\n")

  hydro_consumption.close()

  print "Finished with Hydro Consumption (twh) Worksheet"


  # HYDRO CONSUMPTION (mtoe) ___________________________________

  hydro_consumption = open('BP_2008_hydro_consumption_mtoe.csv','w')
  # Worksheet 36 (python index 35) is titled "Hydro_Energy_Consumption mtoe"
  sheet = workbook.sheet_by_index(35)

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
  # 87-91 Special
  years = [2]
  NAm = range(4,8)
  SAm = range(9,18)
  Europe = range(19,53)
  ME = range(54,61)
  Africa = range(62,67)
  Asia = range(68,85)
  Special = range(86,91)
  rowrange = years + NAm + SAm + Europe + ME + Africa + Asia + Special
  colrange = range(1,44)
  hydro_consumption.write("title         = ASCII CSV version of Hydro consumption data from the 2008 British Petroleum Statistical Review (worksheet 36)\n")
  hydro_consumption.write("file URL      = http://mazamascience.com/OilExport/BP_2008_hydro_consumption_mtoe.csv\n")
  hydro_consumption.write("original data = http://www.bp.com/liveassets/bp_internet/globalbp/globalbp_uk_english/reports_and_publications/statistical_energy_review_2008/STAGING/local_assets/downloads/spreadsheets/statistical_review_full_report_workbook_2008.xls\n")
  hydro_consumption.write("country codes = ISO3166-1 two-letter codes or 'BP_~~~' for special groups (e.g. BP_TNA = Total North America)\n")
  hydro_consumption.write("units         = million tonnes oil equivalent per year\n")
  hydro_consumption.write("\n")
  for row in rowrange:
    region = sheet.cell_value(row,0)
    # TODO:  Strip out any non-ascii characters
    # NOTE:  Strip initial and trailing space
    region = region.strip(u'\xa3')
    region = region.strip()
    ###consumption.write("\"%s\"" % region)
    ISO_code = get_ISO_code(region)
    hydro_consumption.write("\"%s\"" % ISO_code)
    for cell_type, value in get_row_data(workbook, sheet, row, colrange):
      if cell_type == xlrd.XL_CELL_NUMBER:
        if row == 2:
          hydro_consumption.write(",%d" % int(value))
        else:
          hydro_consumption.write(",%.1f" % value)
      elif cell_type == xlrd.XL_CELL_TEXT:
        hydro_consumption.write(",\"%s\"" % value)
      else:
        print "UNKNOWN cell_type %d" % cell_type
        sys.exit(1)

    hydro_consumption.write("\n")

  hydro_consumption.close()

  print "Finished with Hydro Consumption (mtoe) Worksheet"


################################################################################

if __name__ == "__main__":
  main()
