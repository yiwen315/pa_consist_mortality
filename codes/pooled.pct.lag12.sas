
/* Joint association between total PA and consistency */
/* lag 12 years */

%include "/udd/hpyzh/pa_consist/pooled/lag/pooled_data_setup_12lag.sas";

data pooled_12lag;
	set pooled_12lag;


      if       totalpav12lag<7.5   then totalpacat12lag=1;
 else if  7.5<=totalpav12lag<15    then totalpacat12lag=2;
 else if   15<=totalpav12lag<22.5  then totalpacat12lag=3;
 else if 22.5<=totalpav12lag<30    then totalpacat12lag=4;
 else if   30<=totalpav12lag<45    then totalpacat12lag=5;
 else if   45<=totalpav12lag       then totalpacat12lag=6; 
 

      if pctmeet12lag=0          then pctmeetcat=1;
 else if 0<pctmeet12lag<0.50     then pctmeetcat=2;
 else if 0.50=<pctmeet12lag<0.75 then pctmeetcat=3;
 else if 0.75=<pctmeet12lag<1    then pctmeetcat=4;
 else if 1=pctmeet12lag          then pctmeetcat=5;


      if totalpacat12lag=1 and pctmeetcat=1 then joint=1;
 else if totalpacat12lag=1 and pctmeetcat=2 then joint=2;
 else if totalpacat12lag=1 and pctmeetcat=3 then joint=3;
 else if totalpacat12lag=1 and pctmeetcat=4 then joint=4;

 else if totalpacat12lag=2 and pctmeetcat=2 then joint=5;
 else if totalpacat12lag=2 and pctmeetcat=3 then joint=6;
 else if totalpacat12lag=2 and pctmeetcat=4 then joint=7;
 else if totalpacat12lag=2 and pctmeetcat=5 then joint=8;

 else if totalpacat12lag=3 and pctmeetcat=2 then joint=9;
 else if totalpacat12lag=3 and pctmeetcat=3 then joint=10;
 else if totalpacat12lag=3 and pctmeetcat=4 then joint=11;
 else if totalpacat12lag=3 and pctmeetcat=5 then joint=12;

 else if totalpacat12lag=4 and pctmeetcat=2 then joint=13;
 else if totalpacat12lag=4 and pctmeetcat=3 then joint=14;
 else if totalpacat12lag=4 and pctmeetcat=4 then joint=15;
 else if totalpacat12lag=4 and pctmeetcat=5 then joint=16;

 else if totalpacat12lag=5 and pctmeetcat=2 then joint=17;
 else if totalpacat12lag=5 and pctmeetcat=3 then joint=18;
 else if totalpacat12lag=5 and pctmeetcat=4 then joint=19;
 else if totalpacat12lag=5 and pctmeetcat=5 then joint=20;

 else if totalpacat12lag=6 and pctmeetcat=2 then joint=21;
 else if totalpacat12lag=6 and pctmeetcat=3 then joint=22;
 else if totalpacat12lag=6 and pctmeetcat=4 then joint=23;
 else if totalpacat12lag=6 and pctmeetcat=5 then joint=24; 


%indic3(vbl=joint,    prefix=joint,   min=1, max=24, reflev=1, missing=., usemiss=0);



run;


proc means data=pooled_12lag nmiss min max median mean; 
  class totalpacat12lag;
  var totalpav12lag;
run;


proc means data=pooled_12lag nmiss min max median mean; 
  class pctmeetcat;
  var pctmeet12lag;
run;


proc means data=pooled_12lag nmiss min max median mean; 
  class joint;
  var totalpav12lag;
run;


proc freq data=pooled_12lag;
	tables 
    totalpacat12lag pctmeetcat
    totalpacat12lag * pctmeetcat /missing
	;
run;




%pre_pm(data=pooled_12lag, out=pooled_py, timevar=periodnew,
        irt=   irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead , 
        var=joint );

%pm(data=pooled_py, case= alldead , 
  exposure=joint , ref=1);





%let cov1 = white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_;



%macro consist_cox (event, time);

%mphreg9(data=pooled_12lag, outdat=&event._out,
         event=&event, 
         time=&time, 
         timevar=  t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20,
         qret=  irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20,
         cutoff=cutoff, 
         dtdx=dtdth, dtdth=dtdth, id=id, agevar=agemo, tvar=periodnew, labels=F, strata=agemo periodnew cohort,


model1=&joint_ &cov1 


); run;




data &event._out;
set &event._out;

if  index(variable, 'joint')  ;

HR=put(HazardRatio, 8.2)|| ' (' || put(lcl, 4.2) || ', ' || put(ucl, 4.2) || ')';

run;


proc export data=&event._out
            outfile='/udd/hpyzh/pa_consist/pooled/lag/lag12/pooled_pct_12lag.xlsx' dbms=xlsx replace;  sheet="&event.";

run;


%mend;



%consist_cox(alldead, talldead);



