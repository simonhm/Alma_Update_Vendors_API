# Alma_Update_Vendors_API

 - run_inactive.sh: read the text file (the name of file from command line), and call the update_vendor_inactive.php with the vendor code (ID) line by line
 - update_vendor_inactive.php: get the vendor info from API, replace ACTIVE status into INACTIVE, then update the vendor info (use API put method)
 - run_active.sh: read the text file (the name of file from command line), and call the update_vendor_active.php with the vendor code (ID) line by line  
 - update_vendor_active.php: get the vendor info from API, replace INACTIVE status into ACTIVE, then update the vendor info (use API put method)

Sample command:  ./run_inactive.sh list_vendor_codes.csv

list_vendor_codes.csv: text file containing vendor codes line by line ...
 
Note: It takes around 5 seconds to update one vendor, so the script will take around 8-9 hours for updating 8000+ vendors.

TODO: Clean code.
