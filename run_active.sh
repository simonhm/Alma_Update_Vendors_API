#!/bin/bash

while read LINE 
do
    php update_vendor_active.php $LINE
    #sleep 5
done < $1

#php update_vendor_inactive.php 0058265
