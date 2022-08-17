@echo off
echo ---
echo --- Curl down the pipeline2detailedreport converter
echo ---
curl -sSO https://raw.githubusercontent.com/cadonuno/pipeline2detailedreport/master/detailedreport.py 
echo ---
echo --- Curl the latest version of Veracode's Pipeline Scan
echo ---

if "%skip_scan%"=="true" (
	echo --- Skipping scan
) else (
	mkdir veracode
	cd veracode
	curl -sSO https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip
	echo ---
	echo --- Unzip Veracode Pipeline Scan
	echo ---
	"C:\Program Files\7-Zip\7z" e pipeline-scan-LATEST.zip
	echo ---
	echo --- run the pipeline scan
	echo ---
	cd ..
	if not "%issue_details"=="true" (
		set issue_details=false
	)
	if [%baseline_file%]==[] (
		java -jar ./veracode/pipeline-scan.jar --veracode_api_id "%veracode_api_id%" --veracode_api_key "%veracode_api_key%" -f "%file%" -id %issue_details%
	) else (
		java -jar ./veracode/pipeline-scan.jar --veracode_api_id "%veracode_api_id%" --veracode_api_key "%veracode_api_key%" -f "%file%" -id %issue_details% -bf "%baseline_file%"
	)
)

echo ---
echo --- convert the results.json file to pipeline2detailedreport
echo ---
if [%html_output%]==[] (set html_output=true)
if "%html_output%" == "true" (
	python detailedreport.py --html
) else (
python detailedreport.py
)

if not "%skip_scan%"=="true" (
	echo ---
	echo --- clean up
	echo ---
	cd veracode
	del /q pipeline-scan.jar
	del /Q pipeline-scan-LATEST.zip
	del /Q README.md
	cd ..
	rmdir veracode
)

del /Q detailedreport.py
echo --- done
echo on
