*-------------------------------------------------------------------------------
* FLEXPLACE PROJECT - American Time Use Surveys
* flexplace_sample & IVs.do
* Richard Petts and Joanna Pepin
*-------------------------------------------------------------------------------

* The goal of this file is to create the flexplace and demographic variables.

********************************************************************************
* Setup the log file
********************************************************************************
local logdate = string( d(`c(current_date)'), "%dCY.N.D" ) 			// Create a macro for the date

local list : dir . files "$logdir/*flexplace_sample & IVs_*.log"	// Delete earlier versions of the log
foreach f of local list {
    erase "`f'"
}

log using "$logdir/flexplace_sample & IVs_`logdate'.log", t replace

di "$S_DATE"

********************************************************************************
* Import the data
********************************************************************************
clear
set more off

// Import flexplace and demographic data----------------------------------------
	cd $datadir
	do $demodata.do
	cd $projcode
	
// Count respondents and check for wide file format.
duplicates report caseid
assert r(N) == r(unique_value)

// Create a macro with the total number of respondents in the dataset.
	egen 	all = nvals(caseid)
	global 	all_n = all
	di 		"$all_n"

********************************************************************************
* Limit to respondents who completed the leave module
********************************************************************************

** Keep only leave module respondents-------------------------------------------
fre 		lv_resp
keep if 	lv_resp == 1 		// Leave respondent
unique 		caseid				// Number of leave respondents in sample

// Create a macro with the total number of leave module respondents in the dataset.
	egen 	lvresp = nvals(caseid)
	global 	lvresp_n = lvresp
	di 		"$lvresp_n"

** Keep only respondents who have valid data on inital flexplace question-------
fre			wrkhomeable
keep if		wrkhomeable != 98	// Blank
unique 		caseid				// Number of leave respondents in sample

// Create a macro with the total number of valid flexplace respondents in the dataset.
	egen 	flresp = nvals(caseid)
	global 	flresp_n = flresp
	di 		"$flresp_n"

********************************************************************************
* Flexplace Variables
********************************************************************************
*	"wrkhomeable"	"wrkhomeev"		"wrkhomepd"		"wrkhomersn"	"wrkhomedays"

// lujf_10 -- As part of your (main) job, can you work at home?
fre 		wrkhomeable
cap drop	flexhome
clonevar	flexhome = wrkhomeable

// lejf_11 -- Edited: Do you ever work at home?
fre 		wrkhomeev
cap drop	workhome
recode 		wrkhomeev (1=1 "Yes") (else=0 "No | NA"), generate (workhome)

// lejf_12 -- Edited: Are you paid for the hours that you work at home, or do you just take wo
fre 		wrkhomepd
cap drop	workhomepaid
recode 		wrkhomepd (1=1 "Paid") (3=1) (else=0 "No | NA"), generate (workhomepaid)

// lejf_13 -- Edited: What is the main reason why you work at home?
fre			wrkhomersn
cap drop	wkhomewhy
recode 		wrkhomersn 	(3=1 "Family reasons") (1/2=2 "Work reasons") 	///
						(4=3 "Reduce commute") (5=4 "Personal reasons")	///
						(6/7=5 "Other reasons") (99 = 6 "N/A"), generate (wkhomewhy)

cap drop	WHW*
tab			wkhomewhy, gen(WHW)	// Creates dummy variables

// lejf_14 -- Edited: Are there days when you work only at home?
fre			wrkhomedays
cap drop	onlyhome
recode 		wrkhomedays (1=1 "Yes") (else=0 "No | NA"), generate (onlyhome)

********************************************************************************
* Demographic Variables
********************************************************************************

** Respondents' Gender ---------------------------------------------------------
fre			sex
cap drop 	male
gen			male =	sex == 1

** Respondents' Age ------------------------------------------------------------

fre 		age

** Parent variables ------------------------------------------------------------
*?*?*?*?* The kidund3 and kid3to5 vars are different than RP

// Number of children in the household
clonevar	numkids = hh_numkids

// Presence of a child in the household
clonevar	child 	= hh_child

// Presence of young children in the household

cap drop	kidund3
gen			kidund3 = 0
replace		kidund3	= 1 if kidund1 == 1 | kid1to2 == 1

// Preschool child present in household
fre 		kid3to5

** Respondents' Race -----------------------------------------------------------
fre	race

cap drop			raceeth
gen					raceeth = 1 if race == 100 & hispan == 100 	// White
replace				raceeth = 2 if race == 110 & hispan == 100 	// Black
replace				raceeth = 3 if 				 hispan != 100	// Hispanic
replace				raceeth = 4 if race == 131 & hispan == 100	// Asian
replace				raceeth = 5 if race >= 132 & hispan == 100	// Othrace

gen white		=	raceeth==1
gen black		=	raceeth==2
gen hispanic	=	raceeth==3 
gen asian		=	raceeth==4
gen othrace		=	raceeth==5 // *?*?*?*?* This is different than RP. I think bc corrects hispan othrace
							// new othrace: 106 old 211
							
** Respondents' Education ------------------------------------------------------
fre educ
cap drop educat
recode educ (10/17=1 "belowhs") (20/21=2 "hs") (30/32=3 "smcoll") ///
			(40=4 "bach") (41/43=5 "addeg"), generate (educat)
			
** Respondents' Employment -----------------------------------------------------
cap drop 	fulltime
gen			fulltime = fullpart==1

** Respondents' Occupation -----------------------------------------------------
cap drop 	prof
recode		occ2 (110/127 = 1) (else = 0), gen(prof)
			
** Respondents' Marital Status -------------------------------------------------
tab marst spousepres
fre spousepres

cap drop 	married
cap drop 	cohab
gen 		married = spousepres==1
gen 		cohab	= spousepres==2


** Spouse/Partner Employment ---------------------------------------------------
fre spempnot
fre spusualhrs

cap drop 	spemp
gen			spemp = 1 if spempnot 	!= 1
replace		spemp = 2 if spempnot 	== 1 & (spusualhrs < 35 |  spusualhrs == 995)
replace		spemp = 3 if spempnot 	== 1 & (spusualhrs >=35 &  spusualhrs <= 99)

** Same-sex Couples ------------------------------------------------------------
cap drop 	samesex
gen			samesex = 0
replace		samesex = 1 if sex == spsex

** Family Income ---------------------------------------------------------------
fre faminc

** Diary Day -------------------------------------------------------------------

// Diary was completed on a holiday
fre holiday

// Diary was completed on a weekend
cap drop 	weekend
recode day (2/6=0 "weekday") (else=1 "weekend"), generate (weekend)

********************************************************************************
* SAMPLE SELECTION RESTRICTED TO PARTNERED FATHERS
********************************************************************************
// Keep male respondents
	keep if male==1
	egen 	men = nvals(caseid)
	global 	men_n = men
	di 		"$men_n"

// Keep partnered men
	keep if spousepres != 3
	egen 	part = nvals(caseid)
	global 	part_n = part
	di 		"$part_n"

// Keep fathers
	keep if child ==1
	egen 	parent = nvals(caseid)
	global 	parent_n = parent
	di 		"$parent_n"

// Keep different-sex couples
	drop if samesex==1
	egen 	diffsex = nvals(caseid)
	global 	diffsex_n = diffsex
	di 		"$diffsex_n"

// Lost cases
	di 		"$all_n"		// Total number of respondents in the dataset.
	di 		"$lvresp_n"		// Total number of leave module respondents in the dataset.
	di 		"$flresp_n"		// Total number of valid flexplace respondents in the dataset.
	di 		"$men_n"		// Total number of men in the sample
	di 		"$part_n" 		// Total number of partnered men in the sample
	di 		"$parent_n"		// Total number of partnered fathers in the sample
	di 		"$diffsex_n"	// Total number of different-sex partnered fathers in the sample
	
********************************************************************************
* Save and close
********************************************************************************
// Temporarily save the dataset

save "$tempdir\flexplace_demo.dta", replace
