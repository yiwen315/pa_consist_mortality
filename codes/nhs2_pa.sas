/* Purpose: NHS2, to read in total PA, moderate PA and vigorous PA, in MET hour/wk, and create consistency variables */


/*
filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos';
filename channing '/usr/local/channing/sasautos';
libname readfmt '/proj/nhsass/nhsas00/formats';
options mautosource sasautos=(channing nhstools);
options fmtsearch=(readfmt);
options ls=100 ps=68 nocenter; 
*/


%act8917(keep = 
	act89m walk89m jog89m run89m bike89m swim89m ten89m cal89m othvg89m flts89m
	act91m walk91m jog91m run91m bike91m swim91m ten91m cal91m othvg91m flts91m
    act97m walk97m jog97m run97m bike97m swim97m ten97m cal97m othvg97m flts97m
    act01m walk01m jog01m run01m bike01m swim01m ten01m cal01m othvg01m flts01m lowex01m awgt01m lwgt01m 
    act05m walk05m jog05m run05m bike05m swim05m ten05m cal05m othvg05m flts05m lowex05m awgt05m lwgt05m
    act09m walk09m jog09m run09m bike09m swim09m ten09m cal09m othvg09m flts09m lowex09m awgt09m lwgt09m 
    act13m walk13m rujog13m      bike13m swim13m ten13m cal13m othvg13m flts13m lowex13m awgt13m lwgt13m 
    act17m walk17m rujog17m      bike17m swim17m ten17m cal17m othvg17m         lowex17m awgt17m lwgt17m

	);


/*
calxx: Calithenics/aerobic exercise
othvgxx: other vigorous activity
lowexxx: Low intensity exercise, yoga..

*/


data PA_nhs2; set act8917;

  array  act{*}
	act89m walk89m jog89m run89m bike89m swim89m ten89m cal89m othvg89m flts89m
	act91m walk91m jog91m run91m bike91m swim91m ten91m cal91m othvg91m flts91m
    act97m walk97m jog97m run97m bike97m swim97m ten97m cal97m othvg97m flts97m
    act01m walk01m jog01m run01m bike01m swim01m ten01m cal01m othvg01m flts01m lowex01m awgt01m lwgt01m 
    act05m walk05m jog05m run05m bike05m swim05m ten05m cal05m othvg05m flts05m lowex05m awgt05m lwgt05m
    act09m walk09m jog09m run09m bike09m swim09m ten09m cal09m othvg09m flts09m lowex09m awgt09m lwgt09m 
    act13m walk13m rujog13m      bike13m swim13m ten13m cal13m othvg13m flts13m lowex13m awgt13m lwgt13m 
    act17m walk17m rujog17m      bike17m swim17m ten17m cal17m othvg17m         lowex17m awgt17m lwgt17m
  ;


  array  miss{*}
	act89m walk89m jog89m run89m bike89m swim89m ten89m cal89m othvg89m flts89m
	act91m walk91m jog91m run91m bike91m swim91m ten91m cal91m othvg91m flts91m
    act97m walk97m jog97m run97m bike97m swim97m ten97m cal97m othvg97m flts97m
    act01m walk01m jog01m run01m bike01m swim01m ten01m cal01m othvg01m flts01m lowex01m awgt01m lwgt01m 
    act05m walk05m jog05m run05m bike05m swim05m ten05m cal05m othvg05m flts05m lowex05m awgt05m lwgt05m
    act09m walk09m jog09m run09m bike09m swim09m ten09m cal09m othvg09m flts09m lowex09m awgt09m lwgt09m 
    act13m walk13m rujog13m      bike13m swim13m ten13m cal13m othvg13m flts13m lowex13m awgt13m lwgt13m 
    act17m walk17m rujog17m      bike17m swim17m ten17m cal17m othvg17m         lowex17m awgt17m lwgt17m
  ;



    do j=1 to dim(act); 
    miss{j}=act{j};
    end;

    do j=1 to dim(act); 
    if act(j)<0 or act(j)>=998 then miss{j}=.; /*pass thru is 998 and missing 999*/
    end;



/* Total PA using regular questionnaire only */

 totalpa89m = sum(walk89m, jog89m, run89m, bike89m, swim89m, ten89m, cal89m, othvg89m, flts89m);
 totalpa91m = sum(walk91m, jog91m, run91m, bike91m, swim91m, ten91m, cal91m, othvg91m, flts91m);
 totalpa97m = sum(walk97m, jog97m, run97m, bike97m, swim97m, ten97m, cal97m, othvg97m, flts97m);
 totalpa01m = sum(walk01m, jog01m, run01m, bike01m, swim01m, ten01m, cal01m, othvg01m, flts01m, lowex01m, awgt01m, lwgt01m);
 totalpa05m = sum(walk05m, jog05m, run05m, bike05m, swim05m, ten05m, cal05m, othvg05m, flts05m, lowex05m, awgt05m, lwgt05m);
 totalpa09m = sum(walk09m, jog09m, run09m, bike09m, swim09m, ten09m, cal09m, othvg09m, flts09m, lowex09m, awgt09m, lwgt09m);
 totalpa13m = sum(walk13m, rujog13m,       bike13m, swim13m, ten13m, cal13m, othvg13m, flts13m, lowex13m, awgt13m, lwgt13m);
 totalpa17m = sum(walk17m, rujog17m,       bike17m, swim17m, ten17m, cal17m, othvg17m,          lowex17m, awgt17m, lwgt17m);
 

/*Moderate physical activity in METs-h/week
MET<6
walking, 
digging (MET=5.5),
moderate outdoor activity (MET=4.5),
heavy outdoor activity (MET=5.5),
weightligting (MET=5.5), 
low-intensity exerise,yoga,stretch (MET=3)
*/

modpa89m = sum(walk89m);
modpa91m = sum(walk91m);
modpa97m = sum(walk97m);
modpa01m = sum(walk01m, lowex01m, awgt01m, lwgt01m);
modpa05m = sum(walk05m, lowex05m, awgt05m, lwgt05m);
modpa09m = sum(walk09m, lowex09m, awgt09m, lwgt09m);
modpa13m = sum(walk13m, lowex13m, awgt13m, lwgt13m);
modpa17m = sum(walk17m, lowex17m, awgt17m, lwgt17m);


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


vigpa89m = sum(jog89m, run89m, bike89m, swim89m, ten89m, cal89m, othvg89m, flts89m);
vigpa91m = sum(jog91m, run91m, bike91m, swim91m, ten91m, cal91m, othvg91m, flts91m);
vigpa97m = sum(jog97m, run97m, bike97m, swim97m, ten97m, cal97m, othvg97m, flts97m);
vigpa01m = sum(jog01m, run01m, bike01m, swim01m, ten01m, cal01m, othvg01m, flts01m);
vigpa05m = sum(jog05m, run05m, bike05m, swim05m, ten05m, cal05m, othvg05m, flts05m);
vigpa09m = sum(jog09m, run09m, bike09m, swim09m, ten09m, cal09m, othvg09m, flts09m);
vigpa13m = sum(rujog13m,       bike13m, swim13m, ten13m, cal13m, othvg13m, flts13m);
vigpa17m = sum(rujog17m,       bike17m, swim17m, ten17m, cal17m, othvg17m         );


run;


/* exclude those with unreasonable PA > 250 met-h/wk */
data PA_nhs2; set PA_nhs2;
if totalpa89m>250 then delete;
if totalpa91m>250 then delete;
if totalpa97m>250 then delete;
if totalpa01m>250 then delete;
if totalpa05m>250 then delete;
if totalpa09m>250 then delete;
if totalpa13m>250 then delete;
if totalpa17m>250 then delete;

run;


/* Calculate percentage of follow-up years meeting the recommende level >=7.5 MET-hours/week, using raw physical activity variables */
data PA_nhs2;
  set PA_nhs2;

 array totalpa {*} totalpa89m totalpa91m totalpa97m totalpa01m totalpa05m totalpa09m totalpa13m totalpa17m;
 array reporty {*} report89 report91 report97 report01 report05 report09 report13 report17;
 array targety {*} meet89 meet91 meet97 meet01 meet05 meet09 meet13 meet17;

 /* count how many times reported */
 do i=1 to dim(totalpa); 
    
    reporty{i}=.;
    if totalpa{i} ne . then reporty{i}=1; 

 end;


treport89 = report89;
treport91 = sum(report89, report91);
treport97 = sum(report89, report91, report97);
treport01 = sum(report89, report91, report97, report01);
treport05 = sum(report89, report91, report97, report01, report05);
treport09 = sum(report89, report91, report97, report01, report05, report09);
treport13 = sum(report89, report91, report97, report01, report05, report09, report13);
treport17 = sum(report89, report91, report97, report01, report05, report09, report13, report17);




/* count how many times meet guideline */
 do i=1 to dim(totalpa); 

    targety{i}=.;
    if totalpa{i}>=7.5 then targety{i}=1;
    if totalpa{i}<7.5 then targety{i}=0; 

 end;


ttarget89 = meet89;
ttarget91 = sum(meet89, meet91);
ttarget97 = sum(meet89, meet91, meet97);
ttarget01 = sum(meet89, meet91, meet97, meet01);
ttarget05 = sum(meet89, meet91, meet97, meet01, meet05);
ttarget09 = sum(meet89, meet91, meet97, meet01, meet05, meet09);
ttarget13 = sum(meet89, meet91, meet97, meet01, meet05, meet09, meet13);
ttarget17 = sum(meet89, meet91, meet97, meet01, meet05, meet09, meet13, meet17);


/* calculate percentage */
 array treport {*} treport89 treport91 treport97 treport01 treport05 treport09 treport13 treport17;
 array ttarget {*} ttarget89 ttarget91 ttarget97 ttarget01 ttarget05 ttarget09 ttarget13 ttarget17;
 array pctmeet {*} pctmeet89 pctmeet91 pctmeet97 pctmeet01 pctmeet05 pctmeet09 pctmeet13 pctmeet17;

 do i=1 to dim(treport);

    pctmeet{i}=.; 
    if treport{i} ne . and ttarget{i} ne . then pctmeet{i} = ttarget{i} / treport{i}; 

 end;







/* alternative cut-off of meeting guideline: >=5 */
  array targetty {*} meett89 meett91 meett97 meett01 meett05 meett09 meett13 meett17;

 do i=1 to dim(totalpa); 

    targetty{i}=.;
    if totalpa{i}>=5 then targetty{i}=1;
    if totalpa{i}<5 then targetty{i}=0; 

 end;

ttargett89 = meett89;
ttargett91 = sum(meett89, meett91);
ttargett97 = sum(meett89, meett91, meett97);
ttargett01 = sum(meett89, meett91, meett97, meett01);
ttargett05 = sum(meett89, meett91, meett97, meett01, meett05);
ttargett09 = sum(meett89, meett91, meett97, meett01, meett05, meett09);
ttargett13 = sum(meett89, meett91, meett97, meett01, meett05, meett09, meett13);
ttargett17 = sum(meett89, meett91, meett97, meett01, meett05, meett09, meett13, meett17);

 array ttargett {*} ttargett89 ttargett91 ttargett97 ttargett01 ttargett05 ttargett09 ttargett13 ttargett17;
 array pctmeett {*} pctmeett89 pctmeett91 pctmeett97 pctmeett01 pctmeett05 pctmeett09 pctmeett13 pctmeett17;

 do i=1 to dim(treport);

    pctmeett{i}=.; 
    if treport{i} ne . and ttargett{i} ne . then pctmeett{i} = ttargett{i} / treport{i}; 

 end;








/* alternative cut-off of meeting guideline: >=15 */
  array targettty {*} meettt89 meettt91 meettt97 meettt01 meettt05 meettt09 meettt13 meettt17;

 do i=1 to dim(totalpa); 

    targettty{i}=.;
    if totalpa{i}>=15 then targettty{i}=1;
    if totalpa{i}<15 then targettty{i}=0; 

 end;

ttargettt89 = meettt89;
ttargettt91 = sum(meettt89, meettt91);
ttargettt97 = sum(meettt89, meettt91, meettt97);
ttargettt01 = sum(meettt89, meettt91, meettt97, meettt01);
ttargettt05 = sum(meettt89, meettt91, meettt97, meettt01, meettt05);
ttargettt09 = sum(meettt89, meettt91, meettt97, meettt01, meettt05, meettt09);
ttargettt13 = sum(meettt89, meettt91, meettt97, meettt01, meettt05, meettt09, meettt13);
ttargettt17 = sum(meettt89, meettt91, meettt97, meettt01, meettt05, meettt09, meettt13, meettt17);

 array ttargettt {*} ttargettt89 ttargettt91 ttargettt97 ttargettt01 ttargettt05 ttargettt09 ttargettt13 ttargettt17;
 array pctmeettt {*} pctmeettt89 pctmeettt91 pctmeettt97 pctmeettt01 pctmeettt05 pctmeettt09 pctmeettt13 pctmeettt17;

 do i=1 to dim(treport);

    pctmeettt{i}=.; 
    if treport{i} ne . and ttargettt{i} ne . then pctmeettt{i} = ttargettt{i} / treport{i}; 

 end;




run;








proc means data=PA_nhs2 n nmiss min median mean max;
var 
totalpa89m totalpa91m totalpa97m totalpa01m totalpa05m totalpa09m totalpa13m totalpa17m
modpa89m modpa91m modpa97m modpa01m modpa05m modpa09m modpa13m modpa17m
vigpa89m vigpa91m vigpa97m vigpa01m vigpa05m vigpa09m vigpa13m vigpa17m
;
run;


proc freq data=PA_nhs2;
  tables treport89 treport91 treport97 treport01 treport05 treport09 treport13 treport17
         ttarget89 ttarget91 ttarget97 ttarget01 ttarget05 ttarget09 ttarget13 ttarget17/missing;
run;

proc means data=PA_nhs2 nmiss min max median mean;
  var pctmeet89 pctmeet91 pctmeet97 pctmeet01 pctmeet05 pctmeet09 pctmeet13 pctmeet17
      pctmeett89 pctmeett91 pctmeett97 pctmeett01 pctmeett05 pctmeett09 pctmeett13 pctmeett17
      pctmeettt89 pctmeettt91 pctmeettt97 pctmeettt01 pctmeettt05 pctmeettt09 pctmeettt13 pctmeettt17;
run;





data nhs2_pa_met;
	set PA_nhs2;
	keep id 
totalpa89m totalpa91m totalpa97m totalpa01m totalpa05m totalpa09m totalpa13m totalpa17m
modpa89m modpa91m modpa97m modpa01m modpa05m modpa09m modpa13m modpa17m
vigpa89m vigpa91m vigpa97m vigpa01m vigpa05m vigpa09m vigpa13m vigpa17m

pctmeet89 pctmeet91 pctmeet97 pctmeet01 pctmeet05 pctmeet09 pctmeet13 pctmeet17
pctmeett89 pctmeett91 pctmeett97 pctmeett01 pctmeett05 pctmeett09 pctmeett13 pctmeett17
pctmeettt89 pctmeettt91 pctmeettt97 pctmeettt01 pctmeettt05 pctmeettt09 pctmeettt13 pctmeettt17

treport89 treport91 treport97 treport01 treport05 treport09 treport13 treport17

;
run;


proc datasets;
    delete act8917 PA_nhs2;
run; 
