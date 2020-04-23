*-------------------------------------------------------------------------------
* FLEXPLACE PROJECT - American Time Use Surveys
* flexplace_analyses.do
* By: Daniel Carlson, Richard Petts, Joanna Pepin
*-------------------------------------------------------------------------------
* The goal of this file is to create the tables and figures.
* The data used in this file was produced by 02_flexplace_activities

********************************************************************************
* Setup the log file
********************************************************************************
local logdate = string( d(`c(current_date)'), "%dCY.N.D" ) 		// Create a macro for the date

local list : dir . files "$logdir/*flexplace_analyses_*.log"	// Delete earlier versions of the log
foreach f of local list {
    erase "`f'"
}

log using "$logdir/flexplace_analyses_`logdate'.log", t replace

di "$S_DATE"

********************************************************************************
* Import the data
********************************************************************************
clear
set more off

use "$datadir\flexplace.dta", clear

// Set as survey data
svyset [pw=lvwt], sdrweight(rlvwt_1-rlvwt_160) 

// Flexplace variables
	* flexhome workhome workhomepaid wkhomewhy onlyhome dayshome WHW* OHW* DH*
// Demographic variables
	* age numkids kidund3 kid3to5 
	* white black hispanic asian othrace raceeth
	* belowhs hs smcoll bach addeg educat
	* married cohab 
	* spFT professional fulltime faminc
	* holiday weekend
// Activity variables
	* hwall hwdaily hwelse ccall ccdaily ccphys

********************************************************************************
* Table 1. Summary Statistics
********************************************************************************
putexcel set "$results\flexplace_table1", replace
putexcel A1 = "Variable"
putexcel A2 = "Mean"
putexcel A3 = "Std. Dev."


// Descriptive statistics
svy: mean 	hwall hwdaily hwelse ccall ccdaily ccphys  	///
			onlyhome OHW1-OHW5 DH1-DH5 					///
			age numkids kidund3 kid3to5  				///
			white black hispanic asian othrace 			///
			belowhs hs smcoll bach addeg 				///
			cohab 										///
			spFT prof fulltime faminc 					///
			weekend holiday 
estat sd

putexcel B1=matrix(r(mean)),	nformat("#.##") colnames 
putexcel B3=matrix(r(sd)), 		nformat("#.##")

********************************************************************************
* Main Effects
********************************************************************************
// Create a list of the independent variables
global IV1 "spFT 	i.cohab numkids kidund3 kid3to5 ib2.educat prof fulltime faminc age i.raceeth weekend holiday"
// Create a list of the independent variables without spouse' employment
global IV2 "		i.cohab numkids kidund3 kid3to5 ib2.educat prof fulltime faminc age i.raceeth weekend holiday"

// Create a list of the table format options
global format "excel sideway stats(coef aster se) dec(2) alpha(0.001, 0.01, 0.05) label noparen"

// Table 2 ---------------------------------------------------------------------
* Association between Working from Home and Total Housework 
svy: reg hwall 		onlyhome 				$IV1
	outreg2 using "$results\flexplace_table2", replace 	ctitle(Model 1) $format
svy: reg hwall 		ib5.ONhomewhy 			$IV1
	outreg2 using "$results\flexplace_table2", append	ctitle(Model 2)	$format
svy: reg hwall 		i.dayshome	 			$IV1
	outreg2 using "$results\flexplace_table2", append	ctitle(Model 3) $format sortvar(onlyhome ONhomewhy dayshome)

// Table 3 ---------------------------------------------------------------------
* Association between Working from Home and Routine/Nonroutine Housework 

// Routine Housework
svy: reg hwdaily 	onlyhome 				$IV1
	outreg2 using "$results\flexplace_table3", replace 	ctitle(Model 1) $format
svy: reg hwdaily 	ib5.ONhomewhy 			$IV1
	outreg2 using "$results\flexplace_table3", append 	ctitle(Model 2) $format
svy: reg hwdaily 	i.dayshome	 			$IV1
	outreg2 using "$results\flexplace_table3", append 	ctitle(Model 3) $format
//Nonroutine Housework
svy: reg hwelse 	onlyhome 				$IV1
	outreg2 using "$results\flexplace_table3", append 	ctitle(Model 4) $format
svy: reg hwelse 	ib5.ONhomewhy 			$IV1
	outreg2 using "$results\flexplace_table3", append 	ctitle(Model 5) $format
svy: reg hwelse 	i.dayshome	 			$IV1
	outreg2 using "$results\flexplace_table3", append 	ctitle(Model 6) $format sortvar(onlyhome ONhomewhy dayshome)

// Table 4 ---------------------------------------------------------------------
* Association between Working from Home and Childcare 

// Total Childcare	------------------------------------------------------------
svy: reg ccall 		onlyhome 				$IV1
	outreg2 using "$results\flexplace_table4", replace 	ctitle(Model 1) $format
svy: reg ccall 		ib5.ONhomewhy 			$IV1
	outreg2 using "$results\flexplace_table4", append 	ctitle(Model 2) $format
svy: reg ccall 		i.dayshome	 			$IV1
	outreg2 using "$results\flexplace_table4", append 	ctitle(Model 3) $format
// Routine Childcare -----------------------------------------------------------
svy: reg ccdaily 	onlyhome 				$IV1
	outreg2 using "$results\flexplace_table4", append 	ctitle(Model 4) $format
svy: reg ccdaily 	ib5.ONhomewhy 			$IV1
	outreg2 using "$results\flexplace_table4", append 	ctitle(Model 5) $format
svy: reg ccdaily 	i.dayshome				$IV1
	outreg2 using "$results\flexplace_table4", append 	ctitle(Model 6) $format sortvar(onlyhome ONhomewhy dayshome)

********************************************************************************
* Interactions with spouse employment
********************************************************************************
// Table 5 ---------------------------------------------------------------------
* Interactions between Working from Home and Partner Employment Status

// Panel A: WORKS FROM HOME ----------------------------------------------------
svy: reg hwall 		i.onlyhome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5A", replace ctitle(Model 1) $format drop($IV2)
svy: reg hwdaily 	i.onlyhome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5A", append 	ctitle(Model 2) $format drop($IV2)
svy: reg hwelse 	i.onlyhome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5A", append 	ctitle(Model 3) $format drop($IV2)
svy: reg ccall	 	i.onlyhome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5A", append 	ctitle(Model 4) $format drop($IV2)
svy: reg ccdaily 	i.onlyhome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5A", append 	ctitle(Model 5) $format drop($IV2) sortvar(onlyhome ONhomewhy dayshome)

// Panel B: WHY WORKS FROM HOME ------------------------------------------------
svy: reg hwall 		ib5.ONhomewhy##i.spFT 	$IV2
	outreg2 using "$results\flexplace_table5B", replace ctitle(Model 1) $format drop($IV2)
svy: reg hwdaily 	ib5.ONhomewhy##i.spFT 	$IV2
	outreg2 using "$results\flexplace_table5B", append 	ctitle(Model 2) $format drop($IV2)
svy: reg hwelse 	ib5.ONhomewhy##i.spFT 	$IV2
	outreg2 using "$results\flexplace_table5B", append 	ctitle(Model 3) $format drop($IV2)
svy: reg ccall 		ib5.ONhomewhy##i.spFT 	$IV2
	outreg2 using "$results\flexplace_table5B", append 	ctitle(Model 4) $format drop($IV2)
svy: reg ccdaily 	ib5.ONhomewhy##i.spFT 	$IV2
	outreg2 using "$results\flexplace_table5B", append 	ctitle(Model 5) $format drop($IV2) sortvar(onlyhome ONhomewhy dayshome)

	// Calculate predicted minutes for paper write-up
	svy: reg hwdaily 	ib5.ONhomewhy##i.spFT 	$IV2
	margins ONhomewhy, over(spFT)
	margins, at(ONhomewhy=(1 2 3 4 5) spFT=(0 1)) post
			mlincom 2-1
			mlincom 4-3
			mlincom (4-3) - (2-1)
			mlincom 6-5
			mlincom (4-3) - (6-5)
			mlincom 8-7
			mlincom (4-3) - (8-7)
			mlincom 10-9
			mlincom (4-3)- (10-9)
			mlincom 4-10
			mlincom 4-6
			mlincom 4-8

// Panel C: DAYS WORK FROM HOME ------------------------------------------------
svy: reg hwall 		i.dayshome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5C", replace ctitle(Model 1) $format drop($IV2)
svy: reg hwdaily 	i.dayshome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5C", append 	ctitle(Model 2) $format drop($IV2)
svy: reg hwelse 	i.dayshome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5C", append 	ctitle(Model 3) $format drop($IV2)
svy: reg ccall 		i.dayshome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5C", append 	ctitle(Model 4) $format drop($IV2)
svy: reg ccdaily 	i.dayshome##i.spFT 		$IV2
	outreg2 using "$results\flexplace_table5C", append 	ctitle(Model 5) $format drop($IV2) sortvar(onlyhome ONhomewhy dayshome)

********************************************************************************
* Figures
********************************************************************************

// Figure 1 --------------------------------------------------------------------
svy: reg hwdaily 	i.onlyhome##i.spFT 		$IV2
	est store int1	// Store the model estimates in memory

			// Calcuate the predictions for paper write-up
			margins, at(spFT=(0 1) onlyhome=(0 1)) post
				mlincom 2-1
				mlincom 4-3
				mlincom 4-2
				mlincom 3-1
				mlincom 4-1
				mlincom (4-2) - (3-1)

	// Predicted estimtes when partner not-employed full-time
	est restore int1
	margins if spFT==0, at(onlyhome=(0 1)) post
	est store int1a
	 
	// Predicted estimtes when partner is employed full-time
	est restore int1
	margins if spFT==1, at(onlyhome=(0 1)) post
	est store int1b

	// Create Figure 1
	coefplot (int1a) (int1b), 													///
		vertical recast(bar) barw(0.3) level(68) 								///
		ciopts(recast(rcap) color(gs10)) citop 									///
		legend(order(1 "Does Not Work Full Time" 3 "Works Full Time") 			///
		title("Partner Work Status", size(medsmall))) 							///
		xlab(	1 `" "Father Does Not" "Work from Home" "' 						///
				2 `" "Father Works" "From Home" "') 							///
		ylab(0(10)80) 															///
		ytitle("Housework Minutes Per Day") 									///
		title("{bf:Figure 1}: Fathers' Time Spent in Routine Housework" 		///
				"by Fathers' Use of Flexplace Benefits", span)

	// Save Figure 1
	graph export "$results\flexplace_Figure1.pdf", replace
	* Manual: Open pdf figure and save as tif. 
	*			Click "Settings" in save window to set resolution to 300 dpi


// Figure 2 --------------------------------------------------------------------
svy: reg hwdaily 	i.dayshome##i.spFT 	$IV2
est store int2		// Store the model estimates in memory

			// Calcuate the predictions for paper write-up
			margins dayshome, over(spFT)  post
			margins, at(dayshome=(0 1 2 3 4) spFT=(0 1)) post
				mlincom 2-1
				mlincom 4-3
				mlincom (4-3) - (2-1)
				mlincom 6-5
				mlincom (6-5) - (2-1)
				mlincom 8-7
				mlincom (8-7) - (2-1)
				mlincom 10-9
				mlincom (10-9)- (2-1)
				mlincom 10-8
				mlincom 10-4
				mlincom 8-4

	// Predicted estimtes when partner not-employed full-time
	est restore int2
	margins if spFT==0, at(dayshome=(0 1 2 3 4)) post
	est store int2a
	
	// Predicted estimtes when partner is employed full-time
	est restore int2
	margins if spFT==1, at(dayshome=(0 1 2 3 4)) post
	est store int2b

	// Create Figure 2
	coefplot (int2a) (int2b), 														///
		vertical recast(bar) barw(0.3) level(68) 									///
		ciopts(recast(rcap) color(gs10)) citop 										///
		legend(order(1 "Does Not Work Full Time" 3 "Works Full Time") 				///
		title("Partner Work Status", size(medsmall))) 								///
		xlab(1 "Never" 2 "< Monthly" 3 "Monthly" 4 "1-2 times/wk" 5 "3 days+/wk") 	///
		ylab(0(10)80) 																///
		ytitle("Housework Minutes Per Day") 										///
		title("{bf:Figure 2}: Fathers' Daily Minutes Spent in Routine Housework" 	///
		"by Fathers' Frequency of Using Flexplace Benefits", span) 

	// Save Figure 2
	graph export "$results\flexplace_Figure2.pdf", replace
		* Manual: Open pdf figure and save as tif. 
		*			Click "Settings" in save window to set resolution to 300 dpi

log close
