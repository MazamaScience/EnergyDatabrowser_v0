
# Makefile for OilExport

# INSTALLER:  Configure the following variables for your system
HTML_LOCATION = /var/www/mazamascience.com/html
CGI_LOCATION = /var/www/mazamascience.com/cgi-bin
#CGI_LOCATION = /usr/lib/cgi-bin
# INSTALLER:  End of installer configuration.

# Here is the test installation

reboot_test_clear_cache: uninstall_test uninstall_test_cache install_test install_test_cache

reboot_test: uninstall_test install_test

install_test: uninstall_test
	sed 's/OilExport/OilExportTest/g' OilExport.cgi > $(CGI_LOCATION)/OilExportTest.cgi
	chmod 775 $(CGI_LOCATION)/OilExportTest.cgi
	mkdir -p $(HTML_LOCATION)/OilExportTest
	cp *.RData $(HTML_LOCATION)/OilExportTest
	cp *.csv $(HTML_LOCATION)/OilExportTest
	cp *.xls $(HTML_LOCATION)/OilExportTest
	sed 's/OilExport/OilExportTest/g' ./index.html > $(HTML_LOCATION)/OilExportTest/index.html
	sed 's/OilExport/OilExportTest/g' ./index_de.html > $(HTML_LOCATION)/OilExportTest/index_de.html
	sed 's/OilExport/OilExportTest/g' ./index_es.html > $(HTML_LOCATION)/OilExportTest/index_es.html
	sed 's/OilExport/OilExportTest/g' ./index_fr.html > $(HTML_LOCATION)/OilExportTest/index_fr.html
	sed 's/OilExport/OilExportTest/g' ./index_it.html > $(HTML_LOCATION)/OilExportTest/index_it.html
	sed 's/OilExport/OilExportTest/g' ./index_nl.html > $(HTML_LOCATION)/OilExportTest/index_nl.html
	sed 's/OilExport/OilExportTest/g' ./OilExport.r > $(HTML_LOCATION)/OilExportTest/OilExportTest.r
	sed 's/OilExport/OilExportTest/g' ./Exports_plot.r > $(HTML_LOCATION)/OilExportTest/Exports_plot.r
	sed 's/OilExport/OilExportTest/g' ./Sources_plot.r > $(HTML_LOCATION)/OilExportTest/Sources_plot.r
	sed 's/OilExport/OilExportTest/g' ./Earnings_plot.r > $(HTML_LOCATION)/OilExportTest/Earnings_plot.r
	sed 's/OilExport/OilExportTest/g' ./Mazama_maps.r > $(HTML_LOCATION)/OilExportTest/Mazama_maps.r
	cp text_strings*.r $(HTML_LOCATION)/OilExportTest
	cp about.html data.html help.html $(HTML_LOCATION)/OilExportTest
	cp DEBUG_LOG.txt TRANSCRIPT.txt $(HTML_LOCATION)/OilExportTest
	chmod 666 $(HTML_LOCATION)/OilExportTest/*.txt
	cp -r behavior output* style images favicon.ico $(HTML_LOCATION)/OilExportTest
	chmod 777 $(HTML_LOCATION)/OilExportTest/output*
	sed 's/OilExport/OilExportTest/g' ./style/OilExport.css > $(HTML_LOCATION)/OilExportTest/style/OilExportTest.css
	sed 's/OilExport/OilExportTest/g' ./behavior/OilExport.js > $(HTML_LOCATION)/OilExportTest/behavior/OilExportTest.js

uninstall_test: FORCE
	rm -rf $(HTML_LOCATION)/OilExportTest/*
	rm -f $(CGI_LOCATION)/OilExportTest.cgi
  
uninstall_test_cache: FORCE
	rm -rf $(HTML_LOCATION)/OilExportTest/output*

install_test_cache: FORCE
	cp -r output* $(HTML_LOCATION)/OilExportTest
	chmod 777 $(HTML_LOCATION)/OilExportTest/output*

clear_cache_test: FORCE
	rm -rf $(HTML_LOCATION)/OilExportTest/output*/*

debug_test: FORCE
	cat $(HTML_LOCATION)/OilExportTest/DEBUG_LOG.txt

# Here is the real installation

reboot_production_clear_cache: uninstall_production uninstall_production_cache install_production install_production_cache

reboot_production: uninstall_production install_production

install_production_UI: FORCE
	cp index*.html $(HTML_LOCATION)/OilExport
	cp OilExport.cgi $(CGI_LOCATION)

install_production: FORCE
	cp OilExport.cgi $(CGI_LOCATION)
	chmod 775 $(CGI_LOCATION)/OilExport.cgi
	mkdir -p $(HTML_LOCATION)/OilExport
	cp *.RData $(HTML_LOCATION)/OilExport
	cp *.csv $(HTML_LOCATION)/OilExport
	cp *.xls $(HTML_LOCATION)/OilExport
	cp *.html $(HTML_LOCATION)/OilExport
	cp *.r $(HTML_LOCATION)/OilExport
	cp DEBUG_LOG.txt TRANSCRIPT.txt $(HTML_LOCATION)/OilExport
	chmod 666 $(HTML_LOCATION)/OilExport/*.txt
	cp -r behavior images style favicon.ico $(HTML_LOCATION)/OilExport

install_production_cache: FORCE
	cp -r output* $(HTML_LOCATION)/OilExport
	chmod 777 $(HTML_LOCATION)/OilExport/output*

uninstall_production: FORCE
	rm -f $(CGI_LOCATION)/OilExport.cgi
	rm -f $(HTML_LOCATION)/OilExport/*.*
	rm -rf $(HTML_LOCATION)/OilExport/behavior
	rm -rf $(HTML_LOCATION)/OilExport/images
	rm -rf $(HTML_LOCATION)/OilExport/style

uninstall_production_cache: FORCE
	rm -rf $(HTML_LOCATION)/OilExport/output*

clear_production_cache: FORCE
	rm -rf $(HTML_LOCATION)/OilExport/output_*/*

################################################################################
# Targets for checking DEBUG and TRANSCRIPT

debug: FORCE
	cat $(HTML_LOCATION)/OilExport/DEBUG_LOG.txt

transcript: FORCE
	cat $(HTML_LOCATION)/OilExport/TRANSCRIPT.txt


FORCE:

