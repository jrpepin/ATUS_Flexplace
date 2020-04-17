*-------------------------------------------------------------------------------
* FLEXPLACE PROJECT - American Time Use Surveys
* flexplaceATUS.do
* Richard Petts and Joanna Pepin
*-------------------------------------------------------------------------------
* The goal of these files is to investigate the association between 
* partnered heterosexual fathers’ time working from home and time spent in 
* housework and childcare

********************************************************************************
* A. ENVIRONMENT
********************************************************************************

// Directory -------------------------------------------------------------------
* The current directory is assumed to be the base project directory.
* change to the directory before running flexplaceATUS.do
 cd "C:\Users\Joanna\Dropbox\Repositories\ATUS_Flexplace" 

// Create & run the setup script------------------------------------------------
* Create a personal setup file using the setup_flexplaceATUS_example.do script 
* as a template and save this file in the base project directory.

// Run this script to setup the project environment
	do "setup_flexplaceATUS_environment"
	
// Logs ------------------------------------------------------------------------
* The logs for these files are generated within each .do files.

********************************************************************************
* B. Create two data extracts using ATUS-X
********************************************************************************
* The data for this analysis were downloaded from [https://www.atusdata.org/]

* Instructions for downloading and decompressing the data ----------------------
  * Create the two data extracts described below.
  * https://usa.ipums.org/usa/extract_instructions.shtml
  * Do steps 1 and 2 (skip step 3)

// 1. DemoData -----------------------------------------------------------------
* SAMPLES:          2017-2018
* STRUCTURE:		Rectangular (person)
* SAMPLE MEMBERS:	Respondents
* VARIABLES:
	*	"year"			"caseid"		"famincome"		"hh_numkids"	"pernum"
	* 	"lineno"		"day"			"holiday"		"wt06"			"age"
	* 	"sex"			"race"			"hispan"		"marst"			"educ"
	*	"occ2"			"fullpart"		"spousepres"	"spsex"
	*	"spempnot"		"spusualhrs"	"kidund1"		"kid1to2"		"kid3to5"
	*	"wrkhomeable"	"wrkhomeev"		"wrkhomepd"		"wrkhomersn"	"wrkhomedays"
	*	"wrkhomeoften"	"lv_resp"		"lvwt"			"rlvwt_1" ....	"rlvwt_160"

// 2. ActData ------------------------------------------------------------------
* SAMPLES:          2003-2018
* STRUCTURE:		Hierarchical
* SAMPLE MEMBERS:	Respondents
* VARIABLES:
	*	"rectype" 		"year"      	"caseid"   	 	"pernum"    	"lineno"
    *	"wt06"      	"actline"   	"activity" 		"duration"
	*	"start"			"stop"

********************************************************************************
* C. Data Import and Measures Creation
********************************************************************************

// Create sample & IVs ---------------------------------------------------------
	do "01_flexplace_sample & IVs"

// Create activity measures ----------------------------------------------------
	do "02_flexplace_activities"
	
********************************************************************************
* D. Analyses
********************************************************************************

// Create tables and figures ---------------------------------------------------
	do "03_flexplace_analyses"
