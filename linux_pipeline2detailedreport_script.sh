#!/bin/bash
echo off
echo ---
echo --- Curl down the pipeline2detailedreport converter
echo ---
curl -sSO https://raw.githubusercontent.com/cadonuno/pipeline2detailedreport/master/detailedreport.py
echo ---
echo --- Curl the latest version of Veracode\'s Pipeline Scan
echo ---
mkdir veracode
cd veracode
curl -sSO https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip
echo ---
echo --- Unzip Veracode Pipeline Scan
echo ---
unzip pipeline-scan-LATEST.zip
echo ---
echo --- run the pipeline scan
echo ---
cd ..
java -jar ./veracode/pipeline-scan.jar --veracode_api_id "$veracode_api_id" --veracode_api_key "$veracode_api_key" -f "$file"
echo ---
echo --- convert the results.json file to pipeline2detailedreport
echo ---
python detailedreport.py
echo ---
echo --- clean up
echo ---
rm -r veracode
rm detailedreport.py
echo ---done
echo on
