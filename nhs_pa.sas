/* Purpose: NHS, to read in total PA, moderate PA and vigorous PA, in MET hour/wk, and create consistency variables */

/*
filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos';
filename channing '/usr/local/channing/sasautos';
libname readfmt '/proj/nhsass/nhsas00/formats';
options mautosource sasautos=(channing nhstools);
options fmtsearch=(readfmt);
options ls=100 ps=68 nocenter;
*/

 %act8614(keep =
    act86m walk86m jog86m run86m bike86m swim86m ten86m cal86m squa86m flts86m    
    act88m walk88m jog88m run88m bike88m swim88m ten88m cal88m         flts88m

    act92m walk92m jog92m run92m bike92m swim92m ten92m cal92m         flts92m lowex92m othvg92m
    act94m walk94m jog94m run94m bike94m swim94m ten94m cal94m                 lowex94m othvg94m
    act96m walk96m jog96m run96m bike96m swim96m ten96m cal96m         flts96m lowex96m othvg96m
    act98m walk98m jog98m run98m bike98m swim98m ten98m cal98m         flts98m lowex98m othvg98m
    act00m walk00m jog00m run00m bike00m swim00m ten00m cal00m         flts00m lowex00m othvg00m awgt00m lwgt00m

    act04m walk04m jog04m run04m bike04m swim04m ten04m cal04m         flts04m lowex04m othvg04m awgt04m lwgt04m
    act08m walk08m jog08m run08m bike08m swim08m ten08m cal08m         flts08m lowex08m othvg08m awgt08m lwgt08m

    act12m walk12m rujog12m      bike12m swim12m ten12m cal12m         flts12m lowex12m othvg12m awgt12m lwgt12m
    act14m walk14m rujog14m      bike14m swim14m ten14m cal14m         flts14m lowex14m othvg14m awgt14m lwgt14m

);  
run;

/* 2010 only asked a few activity questions, like 2006, not a full grid*/

/*
calxx: Calithenics/aerobic exercise
fltsxx: Flights of stairs
lowexxx: Low intensity exercise
othvgxx: other vigorous activity
awgtxx: arm weight training
lwgtxx: leg weight training

2012, 2014: run and jogging combined.

*/


data PA_nhs; set act8614;

  array  act{*}

    act86m walk86m jog86m run86m bike86m swim86m ten86m cal86m squa86m flts86m    
    act88m walk88m jog88m run88m bike88m swim88m ten88m cal88m         flts88m

    act92m walk92m jog92m run92m bike92m swim92m ten92m cal92m         flts92m lowex92m othvg92m
    act94m walk94m jog94m run94m bike94m swim94m ten94m cal94m                 lowex94m othvg94m
    act96m walk96m jog96m run96m bike96m swim96m ten96m cal96m         flts96m lowex96m othvg96m
    act98m walk98m jog98m run98m bike98m swim98m ten98m cal98m         flts98m lowex98m othvg98m
    act00m walk00m jog00m run00m bike00m swim00m ten00m cal00m         flts00m lowex00m othvg00m awgt00m lwgt00m

    act04m walk04m jog04m run04m bike04m swim04m ten04m cal04m         flts04m lowex04m othvg04m awgt04m lwgt04m
    act08m walk08m jog08m run08m bike08m swim08m ten08m cal08m         flts08m lowex08m othvg08m awgt08m lwgt08m

    act12m walk12m rujog12m      bike12m swim12m ten12m cal12m         flts12m lowex12m othvg12m awgt12m lwgt12m
    act14m walk14m rujog14m      bike14m swim14m ten14m cal14m         flts14m lowex14m othvg14m awgt14m lwgt14m
;


  array  miss{*}

    act86m walk86m jog86m run86m bike86m swim86m ten86m cal86m squa86m flts86m    
    act88m walk88m jog88m run88m bike88m swim88m ten88m cal88m         flts88m

    act92m walk92m jog92m run92m bike92m swim92m ten92m cal92m         flts92m lowex92m othvg92m
    act94m walk94m jog94m run94m bike94m swim94m ten94m cal94m                 lowex94m othvg94m
    act96m walk96m jog96m run96m bike96m swim96m ten96m cal96m         flts96m lowex96m othvg96m
    act98m walk98m jog98m run98m bike98m swim98m ten98m cal98m         flts98m lowex98m othvg98m
    act00m walk00m jog00m run00m bike00m swim00m ten00m cal00m         flts00m lowex00m othvg00m awgt00m lwgt00m

    act04m walk04m jog04m run04m bike04m swim04m ten04m cal04m         flts04m lowex04m othvg04m awgt04m lwgt04m
    act08m walk08m jog08m run08m bike08m swim08m ten08m cal08m         flts08m lowex08m othvg08m awgt08m lwgt08m

    act12m walk12m rujog12m      bike12m swim12m ten12m cal12m         flts12m lowex12m othvg12m awgt12m lwgt12m
    act14m walk14m rujog14m      bike14m swim14m ten14m cal14m         flts14m lowex14m othvg14m awgt14m lwgt14m
;

    do j=1 to dim(act); 
    miss{j}=act{j};
    end;

    do j=1 to dim(act); 
    if act(j)<0 or act(j)>=998 then miss{j}=.; /*pass thru is 998 and missing 999*/
    end;


/* Total PA using regular questionnaire only */

  totalpa86m = sum(walk86m, jog86m, run86m, bike86m, swim86m, ten86m, cal86m, squa86m, flts86m);
  totalpa88m = sum(walk88m, jog88m, run88m, bike88m, swim88m, ten88m, cal88m,          flts88m);

  totalpa92m = sum(walk92m, jog92m, run92m, bike92m, swim92m, ten92m, cal92m,          flts92m, lowex92m, othvg92m);
  totalpa94m = sum(walk94m, jog94m, run94m, bike94m, swim94m, ten94m, cal94m,                   lowex94m, othvg94m);
  totalpa96m = sum(walk96m, jog96m, run96m, bike96m, swim96m, ten96m, cal96m,          flts96m, lowex96m, othvg96m);
  totalpa98m = sum(walk98m, jog98m, run98m, bike98m, swim98m, ten98m, cal98m,          flts98m, lowex98m, othvg98m);
  totalpa00m = sum(walk00m, jog00m, run00m, bike00m, swim00m, ten00m, cal00m,          flts00m, lowex00m, othvg00m, awgt00m, lwgt00m);

  totalpa04m = sum(walk04m, jog04m, run04m, bike04m, swim04m, ten04m, cal04m,          flts04m, lowex04m, othvg04m, awgt04m, lwgt04m);
  totalpa08m = sum(walk08m, jog08m, run08m, bike08m, swim08m, ten08m, cal08m,          flts08m, lowex08m, othvg08m, awgt08m, lwgt08m);

  totalpa12m = sum(walk12m, rujog12m,       bike12m, swim12m, ten12m, cal12m,          flts12m, lowex12m, othvg12m, awgt12m, lwgt12m);
  totalpa14m = sum(walk14m, rujog14m,       bike14m, swim14m, ten14m, cal14m,          flts14m, lowex14m, othvg14m, awgt14m, lwgt14m);


/*Moderate physical activity in METs-h/week
MET<6
walking, 
digging (MET=5.5),
moderate outdoor activity (MET=4.5),
heavy outdoor activity (MET=5.5),
weightligting (MET=5.5), 
low-intensity exerise,yoga,stretch (MET=3)
*/


  modpa86m = sum(walk86m); 
  modpa88m = sum(walk88m); 
 
  modpa92m = sum(walk92m, lowex92m);    
  modpa94m = sum(walk94m, lowex94m);  
  modpa96m = sum(walk96m, lowex96m);
  modpa98m = sum(walk98m, lowex98m); 
  modpa00m = sum(walk00m, lowex00m, awgt00m, lwgt00m); 

  modpa04m = sum(walk04m, lowex04m, awgt04m, lwgt04m); 
  modpa08m = sum(walk08m, lowex08m, awgt08m, lwgt08m);     

  modpa12m = sum(walk12m, lowex12m, awgt12m, lwgt12m); 
  modpa14m = sum(walk14m, lowex14m, awgt14m, lwgt14m);    



/*Vigorous physical activity in METs-h/week
MET>=6
jogging, 
running, 
biking, 
swimming
tennis, 
racquetball,
row/other aerobics
other vigorous activites,lawn mowing (MET=6)
*/

  vigpa86m = sum(flts86m, jog86m, run86m, bike86m, swim86m, ten86m, cal86m, squa86m);
  vigpa88m = sum(flts88m, jog88m, run88m, bike88m, swim88m, ten88m, cal88m);

  vigpa92m = sum(flts92m, jog92m, run92m, bike92m, swim92m, ten92m, cal92m, othvg92m);
  vigpa94m = sum(         jog94m, run94m, bike94m, swim94m, ten94m, cal94m, othvg94m);
  vigpa96m = sum(flts96m, jog96m, run96m, bike96m, swim96m, ten96m, cal96m, othvg96m);
  vigpa98m = sum(flts98m, jog98m, run98m, bike98m, swim98m, ten98m, cal98m, othvg98m);
  vigpa00m = sum(flts00m, jog00m, run00m, bike00m, swim00m, ten00m, cal00m, othvg00m);

  vigpa04m = sum(flts04m, jog04m, run04m, bike04m, swim04m, ten04m, cal04m, othvg04m);
  vigpa08m = sum(flts08m, jog08m, run08m, bike08m, swim08m, ten04m, cal08m, othvg08m);

  vigpa12m = sum(flts12m, rujog12m,       bike12m, swim12m, ten12m, cal12m, othvg12m);
  vigpa14m = sum(flts14m, rujog14m,       bike14m, swim14m, ten14m, cal14m, othvg14m);



/*Aerobics vs resistance training*/

  respa00m = sum(awgt00m, lwgt00m);

  respa04m = sum(awgt04m, lwgt04m);
  respa08m = sum(awgt08m, lwgt08m);

  respa12m = sum(awgt12m, lwgt12m);
  respa14m = sum(awgt14m, lwgt14m);



  aerpa86m = sum(jog86m, run86m, bike86m, swim86m, ten86m, cal86m, squa86m);
  aerpa88m = sum(jog88m, run88m, bike88m, swim88m, ten88m, cal88m);

  aerpa92m = sum(jog92m, run92m, bike92m, swim92m, ten92m, cal92m, othvg92m, lowex92m);
  aerpa94m = sum(jog94m, run94m, bike94m, swim94m, ten94m, cal94m, othvg94m, lowex94m);
  aerpa96m = sum(jog96m, run96m, bike96m, swim96m, ten96m, cal96m, othvg96m, lowex96m);
  aerpa98m = sum(jog98m, run98m, bike98m, swim98m, ten98m, cal98m, othvg98m, lowex98m);
  aerpa00m = sum(jog00m, run00m, bike00m, swim00m, ten00m, cal00m, othvg00m, lowex00m);

  aerpa04m = sum(jog04m, run04m, bike04m, swim04m, ten04m, cal04m, othvg04m, lowex04m);
  aerpa08m = sum(jog08m, run08m, bike08m, swim08m, ten08m, cal08m, othvg08m, lowex08m);

  aerpa12m = sum(rujog12m,       bike12m, swim12m, ten12m, cal12m, othvg12m, lowex12m);
  aerpa14m = sum(rujog14m,       bike14m, swim14m, ten14m, cal14m, othvg14m, lowex14m);


/* exclude those with unreasonable PA > 250 met-h/wk */
data PA_nhs; set PA_nhs;
if totalpa86m>250 then delete;
if totalpa88m>250 then delete;

if totalpa92m>250 then delete;
if totalpa94m>250 then delete;
if totalpa96m>250 then delete;
if totalpa98m>250 then delete;
if totalpa00m>250 then delete;

if totalpa04m>250 then delete;
if totalpa08m>250 then delete;

if totalpa12m>250 then delete;
if totalpa14m>250 then delete;

run;


/* Calculate percentage of follow-up years meeting the recommende level >=7.5 MET-hours/week, using raw physical activity variables */
data PA_nhs;
  set PA_nhs;

 array totalpa {*} totalpa86m totalpa88m totalpa92m totalpa94m totalpa96m totalpa98m totalpa00m totalpa04m totalpa08m totalpa12m totalpa14m;
 array reporty {*} report86 report88 report92 report94 report96 report98 report00 report04 report08 report12 report14;
 array targety {*} meet86 meet88 meet92 meet94 meet96 meet98 meet00 meet04 meet08 meet12 meet14;

 /* count how many times reported */
 do i=1 to dim(totalpa); 
    
    reporty{i}=.;
    if totalpa{i} ne . then reporty{i}=1; 

 end;

treport86 = sum(report86);
treport88 = sum(report86, report88);
treport92 = sum(report86, report88, report92);
treport94 = sum(report86, report88, report92, report94);
treport96 = sum(report86, report88, report92, report94, report96);
treport98 = sum(report86, report88, report92, report94, report96, report98);
treport00 = sum(report86, report88, report92, report94, report96, report98, report00);
treport04 = sum(report86, report88, report92, report94, report96, report98, report00, report04);
treport08 = sum(report86, report88, report92, report94, report96, report98, report00, report04, report08);
treport12 = sum(report86, report88, report92, report94, report96, report98, report00, report04, report08, report12);
treport14 = sum(report86, report88, report92, report94, report96, report98, report00, report04, report08, report12, report14);

/* count how many times meet guideline */
 do i=1 to dim(totalpa); 

    targety{i}=.;
    if totalpa{i}>=7.5 then targety{i}=1;
    if totalpa{i}<7.5 then targety{i}=0; 

 end;


ttarget86 = sum(meet86);
ttarget88 = sum(meet86, meet88);
ttarget92 = sum(meet86, meet88, meet92);
ttarget94 = sum(meet86, meet88, meet92, meet94);
ttarget96 = sum(meet86, meet88, meet92, meet94, meet96);
ttarget98 = sum(meet86, meet88, meet92, meet94, meet96, meet98);
ttarget00 = sum(meet86, meet88, meet92, meet94, meet96, meet98, meet00);
ttarget04 = sum(meet86, meet88, meet92, meet94, meet96, meet98, meet00, meet04);
ttarget08 = sum(meet86, meet88, meet92, meet94, meet96, meet98, meet00, meet04, meet08);
ttarget12 = sum(meet86, meet88, meet92, meet94, meet96, meet98, meet00, meet04, meet08, meet12);
ttarget14 = sum(meet86, meet88, meet92, meet94, meet96, meet98, meet00, meet04, meet08, meet12, meet14);


/* calculate percentage */
 array treport {*} treport86 treport88 treport92 treport94 treport96 treport98 treport00 treport04 treport08 treport12 treport14;
 array ttarget {*} ttarget86 ttarget88 ttarget92 ttarget94 ttarget96 ttarget98 ttarget00 ttarget04 ttarget08 ttarget12 ttarget14;
 array pctmeet {*} pctmeet86 pctmeet88 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet04 pctmeet08 pctmeet12 pctmeet14;

 do i=1 to dim(treport);

    pctmeet{i}=.; 
    if treport{i} ne . and ttarget{i} ne . then pctmeet{i} = ttarget{i} / treport{i}; 

 end;







/* alternative cut-off of meeting guideline: >=5 */
 array targetty {*} meett86 meett88 meett92 meett94 meett96 meett98 meett00 meett04 meett08 meett12 meett14;

 do i=1 to dim(totalpa); 

    targetty{i}=.;
    if totalpa{i}>=5 then targetty{i}=1;
    if totalpa{i}<5 then targetty{i}=0; 

 end;

ttargett86 = sum(meett86);
ttargett88 = sum(meett86, meett88);
ttargett92 = sum(meett86, meett88, meett92);
ttargett94 = sum(meett86, meett88, meett92, meett94);
ttargett96 = sum(meett86, meett88, meett92, meett94, meett96);
ttargett98 = sum(meett86, meett88, meett92, meett94, meett96, meett98);
ttargett00 = sum(meett86, meett88, meett92, meett94, meett96, meett98, meett00);
ttargett04 = sum(meett86, meett88, meett92, meett94, meett96, meett98, meett00, meett04);
ttargett08 = sum(meett86, meett88, meett92, meett94, meett96, meett98, meett00, meett04, meett08);
ttargett12 = sum(meett86, meett88, meett92, meett94, meett96, meett98, meett00, meett04, meett08, meett12);
ttargett14 = sum(meett86, meett88, meett92, meett94, meett96, meett98, meett00, meett04, meett08, meett12, meett14);

 array ttargett {*} ttargett86 ttargett88 ttargett92 ttargett94 ttargett96 ttargett98 ttargett00 ttargett04 ttargett08 ttargett12 ttargett14;
 array pctmeett {*} pctmeett86 pctmeett88 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett04 pctmeett08 pctmeett12 pctmeett14;

 do i=1 to dim(treport);

    pctmeett{i}=.; 
    if treport{i} ne . and ttargett{i} ne . then pctmeett{i} = ttargett{i} / treport{i}; 

 end;






/* alternative cut-off of meeting guideline: >=15 */
 array targettty {*} meettt86 meettt88 meettt92 meettt94 meettt96 meettt98 meettt00 meettt04 meettt08 meettt12 meettt14;

 do i=1 to dim(totalpa); 

    targettty{i}=.;
    if totalpa{i}>=15 then targettty{i}=1;
    if totalpa{i}<15 then targettty{i}=0; 

 end;

ttargettt86 = sum(meettt86);
ttargettt88 = sum(meettt86, meettt88);
ttargettt92 = sum(meettt86, meettt88, meettt92);
ttargettt94 = sum(meettt86, meettt88, meettt92, meettt94);
ttargettt96 = sum(meettt86, meettt88, meettt92, meettt94, meettt96);
ttargettt98 = sum(meettt86, meettt88, meettt92, meettt94, meettt96, meettt98);
ttargettt00 = sum(meettt86, meettt88, meettt92, meettt94, meettt96, meettt98, meettt00);
ttargettt04 = sum(meettt86, meettt88, meettt92, meettt94, meettt96, meettt98, meettt00, meettt04);
ttargettt08 = sum(meettt86, meettt88, meettt92, meettt94, meettt96, meettt98, meettt00, meettt04, meettt08);
ttargettt12 = sum(meettt86, meettt88, meettt92, meettt94, meettt96, meettt98, meettt00, meettt04, meettt08, meettt12);
ttargettt14 = sum(meettt86, meettt88, meettt92, meettt94, meettt96, meettt98, meettt00, meettt04, meettt08, meettt12, meettt14);

 array ttargettt {*} ttargettt86 ttargettt88 ttargettt92 ttargettt94 ttargettt96 ttargettt98 ttargettt00 ttargettt04 ttargettt08 ttargettt12 ttargettt14;
 array pctmeettt {*} pctmeettt86 pctmeettt88 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt04 pctmeettt08 pctmeettt12 pctmeettt14;

 do i=1 to dim(treport);

    pctmeettt{i}=.; 
    if treport{i} ne . and ttargettt{i} ne . then pctmeettt{i} = ttargettt{i} / treport{i}; 

 end;




run;





proc means data=PA_nhs n nmiss min median mean max;
var 
totalpa86m totalpa88m totalpa92m totalpa94m totalpa96m totalpa98m totalpa00m totalpa04m totalpa08m totalpa12m totalpa14m
modpa86m modpa88m modpa92m modpa94m modpa96m modpa98m modpa00m modpa04m modpa08m modpa12m modpa14m
vigpa86m vigpa88m vigpa92m vigpa94m vigpa96m vigpa98m vigpa00m vigpa04m vigpa08m vigpa12m vigpa14m

respa00m respa04m respa08m respa12m respa14m
aerpa86m aerpa88m aerpa92m aerpa94m aerpa96m aerpa98m aerpa00m aerpa04m aerpa08m aerpa12m aerpa14m;
run;


proc freq data=PA_nhs;
  tables treport86 treport88 treport92 treport94 treport96 treport98 treport00 treport04 treport08 treport12 treport14
         ttarget86 ttarget88 ttarget92 ttarget94 ttarget96 ttarget98 ttarget00 ttarget04 ttarget08 ttarget12 ttarget14/missing;
run;


proc means data=PA_nhs nmiss min max median mean;
  var pctmeet86 pctmeet88 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet04 pctmeet08 pctmeet12 pctmeet14
      pctmeett86 pctmeett88 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett04 pctmeett08 pctmeett12 pctmeett14
      pctmeettt86 pctmeettt88 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt04 pctmeettt08 pctmeettt12 pctmeettt14
  ; 
run;



data nhs_pa_met;
	set PA_nhs;
	keep id 
totalpa86m totalpa88m totalpa92m totalpa94m totalpa96m totalpa98m totalpa00m totalpa04m totalpa08m totalpa12m totalpa14m
modpa86m modpa88m modpa92m modpa94m modpa96m modpa98m modpa00m modpa04m modpa08m modpa12m modpa14m
vigpa86m vigpa88m vigpa92m vigpa94m vigpa96m vigpa98m vigpa00m vigpa04m vigpa08m vigpa12m vigpa14m

respa00m respa04m respa08m respa12m respa14m
aerpa86m aerpa88m aerpa92m aerpa94m aerpa96m aerpa98m aerpa00m aerpa04m aerpa08m aerpa12m aerpa14m

pctmeet86 pctmeet88 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet04 pctmeet08 pctmeet12 pctmeet14
pctmeett86 pctmeett88 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett04 pctmeett08 pctmeett12 pctmeett14
pctmeettt86 pctmeettt88 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt04 pctmeettt08 pctmeettt12 pctmeettt14

treport86 treport88 treport92 treport94 treport96 treport98 treport00 treport04 treport08 treport12 treport14

;
run;


proc datasets;
    delete act8614 PA_nhs;
run; 


