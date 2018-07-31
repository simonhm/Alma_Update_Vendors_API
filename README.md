# Alma_Update_Vendors_API

 run_active.sh: read the text file (the name of file from command line), and call the update_vendor_active.php with the vendor code (ID) line by line
#!/bin/bash
while read LINE 
do
    php update_vendor_inactive.php $LINE
    #sleep 5
done < $1
 update_vendor_inactive.php: get the vendor info from API, replace ACTIVE status into INACTIVE in vendor XML info data, then update the vendor info (use API put method)
<?php

function str_replace_first($from, $to, $content)
{
    $from = '/'.preg_quote($from, '/').'/';

    return preg_replace($from, $to, $content, 1);
}

$line = $argv[1];

      // begin 
      $ch = curl_init();
      echo "Processing: " . $line . " | ";

      //$fp = fopen($_FILES['fileToUpload']['tmp_name'], 'rb');

$url = 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/acq/vendors/{vendorCode}';
$templateParamNames = array('{vendorCode}');

// vendor code
$templateParamValues = array(urlencode("$line"));

$url = str_replace($templateParamNames, $templateParamValues, $url);
$queryParams = '?' . urlencode('apikey') . '=' . urlencode('l7xx5a40198c0bd240e381d94eca8050a722');
curl_setopt($ch, CURLOPT_URL, $url . $queryParams);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
curl_setopt($ch, CURLOPT_HEADER, FALSE);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');

// get Vendor info
$vendor_info_api = "https://api-na.hosted.exlibrisgroup.com/almaws/v1/acq/vendors/$line?apikey=l7xx5a40198c0bd240e381d94eca8050a722";
$vendor_info = file_get_contents($vendor_info_api);

// check if active or not
$tmp = substr($vendor_info, strpos($vendor_info, '<status'), strpos($vendor_info, '<liable_for'));
if (strpos($tmp, 'desc="Active"') > 0) {

$vendor_info = str_replace_first("ACTIVE","INACTIVE",$vendor_info);
$vendor_info = str_replace_first("Active","Inactive",$vendor_info);
}

// remove current address of vendor, replace empty address
$vendor_info_1 = substr($vendor_info, 0, strripos($vendor_info, "<contact_info>"));
$vendor_info_2 = "<contact_info><addresses/><emails/><phones/></contact_info>";
$vendor_info_3 = substr($vendor_info, strpos($vendor_info, "<edi_info/>"), strlen($vendor_info)-1);

$vendor_info = $vendor_info_1 . $vendor_info_2 . $vendor_info_3;


//echo " | " . $vendor_info . " | ";

// update XML vendor info
curl_setopt($ch, CURLOPT_POSTFIELDS, $vendor_info);

curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/xml'));
$response = curl_exec($ch);
var_dump($response);

         echo " - Vendor: $line updated.\n";

       // finish
       curl_close($ch);

?>
 run_active.sh
#!/bin/bash
while read LINE 
do
    php update_vendor_active.php $LINE
    #sleep 5
done < $1
 update_vendor_active.php: get the vendor info from API, replace INACTIVE status into ACTIVE in vendor XML info data, then update the vendor info (use API put method)
<?php

function str_replace_first($from, $to, $content)
{
    $from = '/'.preg_quote($from, '/').'/';

    return preg_replace($from, $to, $content, 1);
}

$line = $argv[1];

      // begin 
      $ch = curl_init();
      echo "Processing: " . $line . " | ";

      //$fp = fopen($_FILES['fileToUpload']['tmp_name'], 'rb');

$url = 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/acq/vendors/{vendorCode}';
$templateParamNames = array('{vendorCode}');

// vendor code
$templateParamValues = array(urlencode("$line"));

$url = str_replace($templateParamNames, $templateParamValues, $url);
$queryParams = '?' . urlencode('apikey') . '=' . urlencode('l7xx5a40198c0bd240e381d94eca8050a722');
curl_setopt($ch, CURLOPT_URL, $url . $queryParams);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
curl_setopt($ch, CURLOPT_HEADER, FALSE);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');

// get Vendor info
$vendor_info_api = "https://api-na.hosted.exlibrisgroup.com/almaws/v1/acq/vendors/$line?apikey=l7xx5a40198c0bd240e381d94eca8050a722";
$vendor_info = file_get_contents($vendor_info_api);

// check if active or not
$tmp = substr($vendor_info, strpos($vendor_info, '<status'), strpos($vendor_info, '<liable_for'));
if (strpos($tmp, 'desc="Inactive"') > 0) {

$vendor_info = str_replace_first("INACTIVE","ACTIVE",$vendor_info);
$vendor_info = str_replace_first("Inactive","Active",$vendor_info);

}

// remove current address of vendor, replace empty address
$vendor_info_1 = substr($vendor_info, 0, strripos($vendor_info, "<contact_info>"));
$vendor_info_2 = "<contact_info><addresses/><emails/><phones/></contact_info>";
$vendor_info_3 = substr($vendor_info, strpos($vendor_info, "<edi_info/>"), strlen($vendor_info)-1);

$vendor_info = $vendor_info_1 . $vendor_info_2 . $vendor_info_3;


//echo " | " . $vendor_info . " | ";

// update XML vendor info
curl_setopt($ch, CURLOPT_POSTFIELDS, $vendor_info);

curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/xml'));
$response = curl_exec($ch);
var_dump($response);

//} // end check active or not

         echo " - Vendor: $line updated.\n";

       // finish
       curl_close($ch);

?>
 Sample command lines:
  ./run_inactive.sh list_vendor_codes.csv
 list_vendor_codes.csv: text file containing vendor codes line by line ...
 
 Note: It takes around 5 seconds to update one vendor, so the script will take around 8-9 hours for updating 8000+ vendors.

TODO: Clean code.
