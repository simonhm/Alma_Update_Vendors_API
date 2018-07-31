#!/bin/bash
while read LINE 
do
    php update_vendor_active.php $LINE
    #sleep 5
done < $1

