capture log close
log using 	"E:\FileHistory\rjpetts@bsu.edu\Manual\ATUS\STATA logs\flex analyses 4.6.20.log", replace

use 	"E:\FileHistory\rjpetts@bsu.edu\Manual\ATUS\Coding\merged ATUS file FINAL.dta", clear



*restrict to respondents who completed leave module*
drop if lejf_1==.


****************************************
**flexibility**
***************************************


*flexible hours**
gen flextime=0 if lejf_1==2
replace flextime=1 if lejf_1a==3
replace flextime=2 if lejf_1a==2
replace flextime=3 if lejf_1a==1

gen flxnev=flextime==0
gen flxrar=flextime==1
gen flxocc=flextime==2
gen flxfrq=flextime==3


gen formflex=lejf_2==1

**restrict to respondents who have valid data on inital flexplace question**
gen flexhome=lujf_10==1
drop if lujf_10<1 

gen workhome=0 if flexhome==0|lejf_11==2
replace workhome=1 if lejf_11==1

gen workhomepaid=workhome==1&(lejf_12==1|lejf_12==3)

gen workhomefam=workhome==1&lejf_13==3

gen wkhomewhy=1 if workhome==1&lejf_13==3
replace wkhomewhy=2 if workhome==1&(lejf_13==1|lejf_13==2)
replace wkhomewhy=3 if workhome==1&lejf_13==4
replace wkhomewhy=4 if workhome==1&lejf_13==5
replace wkhomewhy=5 if workhome==1&(lejf_13==6|lejf_13==7)
replace wkhomewhy=6 if workhome==0

gen WHW1=wkhomewhy==1
gen WHW2=wkhomewhy==2
gen WHW3=wkhomewhy==3
gen WHW4=wkhomewhy==4
gen WHW5=wkhomewhy==5
gen WHW6=wkhomewhy==6

gen onlyhome=1 if lejf_14==1
replace onlyhome=0 if lejf_14==2|workhome==0

gen ONhomewhy=1 if onlyhome==1&lejf_13==3
replace ONhomewhy=2 if onlyhome==1&(lejf_13==1|lejf_13==2)
replace ONhomewhy=3 if onlyhome==1&lejf_13==4
replace ONhomewhy=4 if onlyhome==1&(lejf_13==5|lejf_13==6|lejf_13==7)
replace ONhomewhy=5 if onlyhome==0

gen OHW1=ONhomewhy==1
gen OHW2=ONhomewhy==2
gen OHW3=ONhomewhy==3
gen OHW4=ONhomewhy==4
gen OHW5=ONhomewhy==5


gen dayshome=0 if onlyhome==0
replace dayshome=1 if lejf_15==7
replace dayshome=2 if lejf_15==6
replace dayshome=3 if lejf_15==5
replace dayshome=4 if lejf_15==4
replace dayshome=5 if lejf_15==3
replace dayshome=6 if lejf_15==2
replace dayshome=7 if lejf_15==1

gen dayshome2=0 if dayshome==0
replace dayshome2=1 if lejf_15==7
replace dayshome2=2 if lejf_15==5|lejf_15==6
replace dayshome2=3 if lejf_15==3|lejf_15==4
replace dayshome2=4 if lejf_15==1|lejf_15==2

gen DH1=dayshome2==0
gen DH2=dayshome2==1
gen DH3=dayshome2==2
gen DH4=dayshome2==3
gen DH5=dayshome2==4


*took leave for care of family member, childcare, or birth of child*
gen famleave=lelvmain==2|lelvmain==3|lelvmain==7



****************************************
**demographic characteristics**
****************************************

*respondent gender*
gen sex=tesexy18
replace sex=tesexy17 if sex==.
gen male=sex==1


*respondent age*
gen age=teagey18
replace age=teagey17 if age==.



*number of children in HH & child in HH*
gen numkids=trchildnumy17
replace numkids=trchildnumy18 if numkids==.

gen child=numkids>0

gen childU2=kidU2y17==1|kidU2y18==1
gen child25=kid25y17==1|kid25y18==1


*respondent race*
gen race=1 if (ptdtracey18==1&pehspnony18==2)|(ptdtracey17==1&pehspnony17==2)
replace race=2 if (ptdtracey18==2&pehspnony18==2)|(ptdtracey17==2&pehspnony17==2)
replace race=3 if pehspnony17==1|pehspnony18==1
replace race=4 if (ptdtracey18==4&pehspnony18==2)|(ptdtracey17==4&pehspnony17==2)
replace race=5 if (ptdtracey18==3|ptdtracey18>=5&ptdtracey18<=16)|(ptdtracey17==3|ptdtracey17>=5&ptdtracey17<=16)
gen white=race==1
gen black=race==2
gen hispanic=race==3 
gen asian=race==4
gen othrace=race==5


*education*
gen educ=1 if (peeducay17>=31&peeducay17<=38)|(peeducay18>=31&peeducay18<=38)
replace educ=2 if peeducay17==39|peeducay18==39
replace educ=3 if (peeducay17>=40&peeducay17<=42)|(peeducay18>=40&peeducay18<=42)
replace educ=4 if peeducay17==43|peeducay18==43
replace educ=5 if (peeducay17>=44&peeducay17<=46)|(peeducay18>=44&peeducay18<=46)
gen belowhs=educ==1
gen hs=educ==2
gen smcoll=educ==3
gen bach=educ==4
gen addeg=educ==5

*marital status*
gen marital=1 if pemaritly17==1|pemaritly18==1
replace marital=2 if pemaritly17==2|pemaritly18==2
replace marital=3 if pemaritly17==3|pemaritly18==3
replace marital=4 if (pemaritly17==4|pemaritly17==5)|(pemaritly18==4|pemaritly18==5)
replace marital=5 if pemaritly17==6|pemaritly18==6


*spouse/partner present*
gen spousepres=1 if trsppresy17==1|trsppresy18==1
replace spousepres=2 if trsppresy17==2|trsppresy18==2
replace spousepres=3 if (trsppresy17==3&pemaritly17==6)|(trsppresy18==3&pemaritly18==6)
replace spousepres=4 if (trsppresy17==3&marital==4)|(trsppresy18==3&marital==4)
replace spousepres=5 if (trsppresy17==3&marital==3)|(trsppresy18==3&marital==3)

gen spousepres2=1 if trsppresy17==1|trsppresy18==1
replace spousepres2=2 if trsppresy17==2|trsppresy18==2
replace spousepres2=3 if trsppresy17==3|trsppresy18==3



gen married=spousepres==1
gen cohab=spousepres==2
gen single=spousepres==3
gen divorce=spousepres==4
gen widow=spousepres==5

*spouse employment*
gen spemp=0 if (tespempnoty17==2|trsppresy17==3)|(tespempnoty18==2|trsppresy18==3)
replace spemp=1 if (trspftpty17==2|trspftpty17==3)|(trspftpty18==2|trspftpty18==3)
replace spemp=2 if trspftpty17==1|trspftpty18==1

gen spNT=spemp==0
gen spPT=spemp==1
gen spFT=spemp==2

*occupation*
gen professional=trmjocgr17==1|trmjocgr18==1


*respondent employment*
gen fulltime=trdpftpty17==1|trdpftpty18==1

*family income*
gen income=hefamincy17
replace income=hefamincy18 if income==.


*diary day*
gen weekend=(tudiarydayy17==1|tudiarydayy17==7)|(tudiarydayy18==1|tudiarydayy18==7)
gen holiday=trholidayy17==1|trholidayy18==1


*same-sex couples*
gen samesex=samesex17
replace samesex=samesex18 if samesex==.


***********************************************************************************************************************
***CONSTRUCTION OF TIME MEASURES***
***********************************************************************************************************************
					/*each of these variables corresponds to an activity code. the variable contains duration in minutes 
					that the respondent spent in this activity over the course of the diary day*/

***********************************************************************************************************************
**CHILDCARE VARIABLES

***summary stats for childcare codes***
summ 				t030101y17 	t030102y17 	t030103y17 	t030104y17 	t030105y17	t030108y17 	t030109y17 	t030110y17 	///
					t030111y17 	t030112y17 	t030199y17	t030201y17 	t030202y17 	t030203y17 	t030204y17 	t030299y17 	///
					t030301y17 	t030302y17 	t030303y17 	t030399y17 	t030106y17

summ 				t030101y18 	t030102y18 	t030103y18 	t030104y18 	t030105y18	t030108y18 	t030109y18 	t030110y18 	///
					t030111y18 	t030112y18 	t030199y18	t030201y18 	t030202y18 	t030203y18 	t030204y18 	t030299y18 	///
					t030301y18 	t030302y18 	t030303y18 	t030399y18 	t030106y18

gen physical=t030101y17
replace physical=t030101y18 if physical==.

gen readplay=t030102y17+t030103y17+t030104y17+t030105y17
replace readplay=t030102y18+t030103y18+t030104y18+t030105y18 if readplay==.

gen listen=t030106y17
replace listen=t030106y18 if listen==.

gen organize=t030108y17
replace organize=t030108y18 if organize==.

gen supervise=t030109y17
replace supervise=t030109y18 if supervise==.

gen attend=t030110y17+t030111y17+t030112y17+t030199y17
replace attend=t030110y18+t030111y18+t030112y18+t030199y18 if attend==.

gen childedu=t030201y17+t030202y17+t030203y17+t030204y17+t030299y17
replace childedu=t030201y18+t030202y18+t030203y18+t030204y18+t030299y18 if childedu==.

gen childhealth=t030301y17+t030302y17+t030303y17+t030399y17
replace childhealth=t030301y18+t030302y18+t030303y18+t030399y18 if childhealth==.					

***generate childcare variable***

gen childcare=physical+readplay+listen+organize+supervise+attend+childedu+childhealth


*TOTAL CHILDCARE VARIABLE
***********************
summ 	childcare					
summ	physical readplay listen organize supervise attend childedu childhealth
				
***********************************************************************************************************************
**HOUSEWORK VARIABLES


***generate housework variable***
gen cleaning=t020101y17
replace cleaning=t020101y18 if cleaning==.

gen laundry=t020102y17
replace laundry=t020102y18 if laundry==.

gen sewing=t020103y17
replace sewing=t020103y18 if sewing==.

gen storing=t020104y17
replace storing=t020104y18 if storing==.

gen mischw=t020199y17
replace mischw=t020199y18 if mischw==.

gen housework=cleaning+laundry+sewing+storing+mischw
sum cleaning laundry sewing storing mischw housework


gen grocshop= t070101y17 + t180701y17
replace grocshop=t070101y18 + t180701y18 if grocshop==.



gen cooking=t020201y17
replace cooking=t020201y18 if cooking==.

gen foodpres=t020202y17
replace foodpres=t020202y18 if foodpres==.

gen dishes=t020203y17
replace dishes=t020203y18 if dishes==.

gen miscfood=t020299y17
replace miscfood=t020299y18 if miscfood==.

gen foodprep=cooking+foodpres+dishes+miscfood
sum cooking foodpres dishes miscfood foodprep


gen interior=t020301y17 +	t020302y17 +	t020303y17 +	t020399y17
replace interior=t020301y18 +	t020302y18 +	t020303y18 +	t020399y18 if interior==.

gen exterior=t020401y17+t020402y17+t020499y17
replace exterior=t020401y18+t020402y18+t020499y18 if exterior==.

gen lawn=t020501y17+t020502y17+t020599y17+t180904y17
replace lawn=t020501y18+t020502y18+t180904y18 if lawn==.

gen vehicle=t020701y17+t020799y17+t020801y17+t020899y17
replace vehicle=t020701y18+t020799y18+t020801y18+t020899y18 if vehicle==.

gen hhmanage=t020901y17+t020902y17+t020903y17+t020904y17+t020905y17+t020999y17
replace hhmanage=t020901y18+t020902y18+t020903y18+t020904y18+t020905y18+t020999y18 if hhmanage==.

gen petcare=t020601y17+ t020602y17+	t020699y17 + t180807y17 + t180903y17
replace petcare=t020601y18+ t020602y18+	t020699y18 + t180807y18 + t180903y18 if petcare==.

	
gen hhservice17=t080701y17 +	t080702y17 +	t090101y17 +	t090102y17 +	t090103y17 +	t090104y17 +	///
				t090199y17 +	t090201y17 +	t090202y17 +	t090299y17 +	t090301y17 +	t090399y17 +	t090401y17 +	///
				t090402y17 +	t090501y17 +	t090502y17 +	t090599y17 +	t099999y17 +	t160106y17
gen hhservice18=t080701y18 +	t080702y18 +	t080799y18 +	t090101y18 +	t090102y18 +	t090103y18 +	t090104y18 +	///
				t090199y18 +	t090201y18 +	t090202y18 +	t090299y18 +	t090301y18 +	t090399y18 +	t090401y18 +	///
				t090501y18 +	t090502y18 +	t090599y18 +	t099999y18 +	t160106y18
gen hhservice=hhservice17
replace hhservice=hhservice18 if hhservice==.

gen hhmisc=t029999y17
replace hhmisc=t029999y18 if hhmisc==.

gen travel=t180901y17+t180902y17+t180905y17+t180999y17+t180208y17
replace travel=t180901y18+t180902y18+t180905y18+t180208y18 if travel==.

gen 	hwtotal=	housework +	grocshop + foodprep  +	interior +	exterior +	lawn  +	petcare + vehicle +	hhmanage +	///
					hhmisc + hhservice + travel
summ 	hwtotal interior exterior lawn vehicle hhmanage petcare hhservice hhmisc travel

gen routine=housework+grocshop+foodprep
gen nonroutine=interior+exterior+lawn+vehicle+hhmanage+petcare+hhservice+hhmisc+travel

summ routine nonroutine



**********************************
***ANALYSES - RESTRICT TO PARTNERED FATHERS***
**********************************

keep if male==1
keep if spousepres2==1|spousepres2==2
drop if samesex==1
keep if child==1

svyset [pw=lufinlwgt], sdrweight(lufinlwgt001-lufinlwgt160) 


**Summary Statistics**
svy: mean hwtotal routine nonroutine childcare physical onlyhome  ///
OHW1-OHW5 DH1-DH5 age numkids childU2 child25 white ///
black hispanic asian othrace belowhs hs smcoll bach addeg married cohab ///
spFT professional fulltime income weekend holiday 
estat sd

**Main Effects**
svy: reg hwtotal onlyhome age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday
		
svy: reg hwtotal ib5.ONhomewhy age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg hwtotal i.dayshome2 age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg routine onlyhome age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday
		
svy: reg routine ib5.ONhomewhy age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg routine i.dayshome2 age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg nonroutine onlyhome age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday
		
svy: reg nonroutine ib5.ONhomewhy age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg nonroutine i.dayshome2 age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg childcare onlyhome age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday
		
svy: reg childcare ib5.ONhomewhy age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg childcare i.dayshome2 age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg physical onlyhome age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday
		
svy: reg physical ib5.ONhomewhy age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday

svy: reg physical i.dayshome2 age numkids childU2 child25 i.race ib2.educ i.spousepres spFT ///
		professional fulltime income weekend holiday
		
**interactions with spouse employment**

svy: reg hwtotal i.onlyhome##i.spFT age numkids childU2 child25 i.race ib2.educ ///
	i.spousepres professional fulltime income weekend holiday

svy: reg routine i.onlyhome##i.spFT age numkids childU2 child25 i.race ib2.educ ///
	i.spousepres professional fulltime income weekend holiday

	est store int1

margins, at(spFT=(0 1) onlyhome=(0 1)) post

mlincom 2-1
mlincom 4-3
mlincom 4-2
mlincom 3-1
mlincom (4-2) - (3-1)

est restore int1
margins if spFT==0, at(onlyhome=(0 1)) post
est store int1a
 
est restore int1
margins if spFT==1, at(onlyhome=(0 1)) post
est store int1b

coefplot (int1a) (int1b), ///
	vertical recast(bar) barw(0.3) level(68) ///
	ciopts(recast(rcap) color(gs10)) citop ///
	legend(order(1 "Does Not Work Full Time" 3 "Works Full Time") ///
	title("Partner Work Status", size(medsmall))) ///
	xlab(1 "Does Not Work from Home" 2 "Works From Home") ylab(20(5)70) ///
	ytitle("Routine Housework") ///
	title("{bf:Figure 1}: Minutes Spent in Routine Housework by Whether Father Works From Home", span)

		graph export "E:\FileHistory\rjpetts@bsu.edu\Manual\ATUS\Graphs/FlexFigure1.png", replace		
		
svy: reg nonroutine i.onlyhome##i.spFT age numkids childU2 child25 i.race ib2.educ ///
	i.spousepres professional fulltime income weekend holiday
	
svy: reg hwtotal ib5.ONhomewhy##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday

svy: reg routine ib5.ONhomewhy##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday

margins, at(ONhomewhy=(1(1)5) spFT=(0 1)) post

mlincom 4-3
mlincom 2-1
mlincom (4-3) - (2-1)
mlincom 6-5
mlincom (6-5) - (2-1)
mlincom 8-7
mlincom (8-7) - (2-1)
mlincom 10-9
mlincom (10-9) - (2-1)
		
svy: reg nonroutine ib5.ONhomewhy##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday
		
svy: reg hwtotal i.dayshome2##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday

svy: reg routine i.dayshome2##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday
est store int2

margins, at(dayshome2=(0 1 2 3 4) spFT=(0 1)) post

mlincom 2-1
mlincom 4-3
mlincom (4-3) - (2-1)
mlincom 6-5
mlincom (6-5) - (2-1)
mlincom 8-7
mlincom (8-7) - (2-1)
mlincom 10-9
mlincom (10-9) - (2-1)

est restore int2
margins if spFT==0, at(dayshome=(0 1 2 3 4)) post
est store int2a
 
est restore int2
margins if spFT==1, at(dayshome=(0 1 2 3 4)) post
est store int2b

coefplot (int2a) (int2b), ///
	vertical recast(bar) barw(0.3) level(68) ///
	ciopts(recast(rcap) color(gs10)) citop ///
	legend(order(1 "Does Not Work Full Time" 3 "Works Full Time") ///
	title("Partner Work Status", size(medsmall))) ///
	xlab(1 "Never" 2 "< Monthly" 3 "Monthly" 4 "1-2 times/wk" 5 "3 days+/wk") ylab(20(5)75) ///
	ytitle("Routine Housework") ///
	title("{bf:Figure 2}: Minutes Spent in Routine Housework by Days Father Works From Home", span)

			graph export "E:\FileHistory\rjpetts@bsu.edu\Manual\ATUS\Graphs/FlexFigure2.png", replace		
	
		
svy: reg nonroutine i.dayshome2##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday

		
svy: reg childcare i.onlyhome##i.spFT age numkids childU2 child25 i.race ib2.educ ///
	i.spousepres professional fulltime income weekend holiday

svy: reg physical i.onlyhome##i.spFT age numkids childU2 child25 i.race ib2.educ ///
	i.spousepres professional fulltime income weekend holiday
	
svy: reg childcare ib5.ONhomewhy##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday

svy: reg physical ib5.ONhomewhy##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday

svy: reg childcare i.dayshome2##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday

svy: reg physical i.dayshome2##i.spFT age numkids childU2 child25 i.race ib2.educ i.spousepres ///
		professional fulltime income weekend holiday

		
