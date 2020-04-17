*-------------------------------------------------------------------------------
* FLEXPLACE PROJECT - American Time Use Surveys
* flexplace_activities.do
* Richard Petts and Joanna Pepin
*-------------------------------------------------------------------------------

* The goal of this file is to create the activity variables.

********************************************************************************
* Setup the log file
********************************************************************************
local logdate = string( d(`c(current_date)'), "%dCY.N.D" ) 			// Create a macro for the date

local list : dir . files "$logdir/*flexplace_activities_*.log"		// Delete earlier versions of the log
foreach f of local list {
    erase "`f'"
}

log using "$logdir/flexplace_activities_`logdate'.log", replace

di "$S_DATE"

********************************************************************************
* Import the data
********************************************************************************
clear
set more off

// Import flexplace and demographic data----------------------------------------
	cd $datadir
	do $actdata.do
	cd $projcode
	
// Keep only activity records
fre 	rectype
keep if rectype == 3

// Keep only leave module years
keep if year == 2017 | year == 2018

********************************************************************************
* HOUSEWORK VARIABLES
********************************************************************************
// All household labor
cap drop 		hwtotal
gen 			hwtotal=.
foreach i in 	020101 	020102 	020103 	020104 	020199							///
				020201 	020202 	020203 	020299									///
				070101 	180701													///
				020301 	020302 	020303 	020399									///
				020401 	020402 	020499 											///
				020501 	020502 	020599 	180904									///
				020681 	020699 	180807 	180903									///
				020701 	020799 	020801 	020899									///
				020901 	020902 	020903 	020904 	020905 	020999					///
				029999															///
				080201 	080202 	080203 	080299									///
				080701 	080702 	080799 	080699 									///
				090101 	090102 	090103 	090104 	090199							///
				090201 	090202 	090299 	090301 	090302 	090399 	090401 			///
				090402 	090499	090501 	090502 	090599 	099999 	160106			///
				180901	180902	180905	180999	180208	{
	replace 	hwtotal=1 if activity == `i'
 	 }
replace 		hwtotal=0 if hwtotal==.

cap drop		hwall
egen			hwall 		= total(duration) if hwtotal==1, by(caseid) 
replace			hwall		=0 if hwall==.
label var 		hwall "All household work"

// Routine Housework
cap drop		hwcore
gen 			hwcore=.
foreach i in 	020101 	020102	020103	020104	020199		/// 	/* Cleaning Laundry Sewing Storing MiscHW 	*/
				070101	180701 								/// 	/* Grocery GroTravel					  	*/
				020201 	020202	020203	020299	{ 					/* Cooking FoodPres Dishes Miscfood 		*/
	replace 	hwcore=1 if activity == `i'
 	 }

cap drop		hwdaily
egen			hwdaily 	= total(duration) if hwcore==1, by(caseid) 
replace			hwdaily		=0 if hwdaily==.
label var 		hwdaily "Routine housework"

// Non-routine Housework
cap drop 		hwnotd
gen 			hwnotd=.
foreach i in 	020401 	020402 	020499 											///
				020501 	020502 	020599 	180904									///
				020681 	020699 	180807 	180903									///
				020701 	020799 	020801 	020899									///
				020901 	020902 	020903 	020904 	020905 	020999					///
				029999															///
				080201 	080202 	080203 	080299									///
				080701 	080702 	080799 	080699 									///
				090101 	090102 	090103 	090104 	090199							///
				090201 	090202 	090299 	090301 	090302 	090399 	090401 			///
				090402 	090499	090501 	090502 	090599 	099999 	160106			{
	replace 	hwnotd=1 if activity == `i'
 	 }
replace 		hwnotd=0 if hwnotd==.

cap drop		hwelse
egen			hwelse 		= total(duration) if hwnotd==1, by(caseid) 
replace			hwelse		=0 if hwelse==.
label var 		hwelse "Non-routine housework"
	 
********************************************************************************
* CHILDCARE VARIABLES
********************************************************************************
// All childcare activities
cap drop 		childcare
gen 			childcare=.
foreach i in 		030101 	030102 	030103 	030104 	030105	030108 	030109 	030110 	///
					030111 	030112 	030199	030201 	030202 	030203 	030204 	030299 	///
					030301 	030302 	030303 	030399 	030186	{
	replace 	childcare=1 if activity == `i'
 	 }
replace 		childcare=0 if childcare==.

cap drop		ccall
egen			ccall 		= total(duration) if childcare==1, by(caseid) 
replace			ccall		=0 if ccall==.
label var 		ccall "All Childcare"

// Physical childcare
cap drop		physicalcc
gen 			physicalcc=.
foreach i in 		030101 		{
	replace 	physicalcc=1 if activity == `i'
 	 }
replace 		physicalcc=0 if physicalcc==.

cap drop		ccphys
egen			ccphys 		= total(duration) if physicalcc==1, by(caseid) 
replace			ccphys		=0 if ccphys==.
label var 		ccphys "Physical Childcare"

// Daily childcare
*?*?*?*? Think about replacing physical with routine??
cap drop		dailycare
gen 			dailycare=.
foreach i in 		030101 	030108	030109	030110 	030111 	030112 	030199 	030204 	///
					030299 	030301 	030302 	030303 	030399	{
	replace		dailycare=1 if activity == `i'
	}
replace			dailycare=0 if dailycar==.

cap drop		ccdaily
egen			ccdaily 	= total(duration) if dailycare==1, by(caseid) 
replace			ccdaily		=0 if ccdaily==.
label var		ccdaily "Routine care of kids"

********************************************************************************
* Create Summary Activity variables
********************************************************************************
collapse (max) hwall hwdaily hwelse ccall ccphys ccdaily, by(caseid)

********************************************************************************
* Merge with demographic dataset
********************************************************************************
* The dataset was produced by "01_flexplace_sample & IVs"

// Temporarily save the activity dataset
save "$tempdir\flexplace_act.dta", replace

// Open demographic dataset
use "$tempdir\flexplace_demo.dta", clear

// Merge the two data files
merge 1:1 	caseid using "$tempdir\flexplace_act.dta"
keep if 	_merge==3 	// Only keep respondents in the analytic sample
drop 		_merge

// Save merged datafile
save "$datadir\flexplace.dta", replace

// Erase temporary datasets
capture erase  "$tempdir\flexplace_act.dta"
capture erase  "$tempdir\flexplace_demo.dta"

log close
