#!/bin/bash
while read LINE 
do
    php update_vendor_inactive.php $LINE
    #sleep 5
done < $1
