/* subgroup by age */

%include "/udd/hpyzh/pa_consist/pooled/pooled_data_setup.sas";

data pooled;
  set pooled;

      if       totalpav2lag<7.5   then totalpacat2lag=1;
 else if  7.5<=totalpav2lag<15    then totalpacat2lag=2;
 else if   15<=totalpav2lag<22.5  then totalpacat2lag=3;
 else if 22.5<=totalpav2lag<30    then totalpacat2lag=4;
 else if   30<=totalpav2lag<45    then totalpacat2lag=5;
 else if   45<=totalpav2lag       then totalpacat2lag=6;
 
 

      if pctmeet2lag=0          then pctmeetcat=1;
 else if 0<pctmeet2lag<0.50     then pctmeetcat=2;
 else if 0.50=<pctmeet2lag<0.75 then pctmeetcat=3;
 else if 0.75=<pctmeet2lag<1    then pctmeetcat=4;
 else if 1=pctmeet2lag          then pctmeetcat=5;


      if totalpacat2lag=1 and pctmeetcat=1 then joint=1;
 else if totalpacat2lag=1 and pctmeetcat=2 then joint=2;
 else if totalpacat2lag=1 and pctmeetcat=3 then joint=3;
 else if totalpacat2lag=1 and pctmeetcat=4 then joint=4;

 else if totalpacat2lag=2 and pctmeetcat=2 then joint=5;
 else if totalpacat2lag=2 and pctmeetcat=3 then joint=6;
 else if totalpacat2lag=2 and pctmeetcat=4 then joint=7;
 else if totalpacat2lag=2 and pctmeetcat=5 then joint=8;

 else if totalpacat2lag=3 and pctmeetcat=2 then joint=9;
 else if totalpacat2lag=3 and pctmeetcat=3 then joint=10;
 else if totalpacat2lag=3 and pctmeetcat=4 then joint=11;
 else if totalpacat2lag=3 and pctmeetcat=5 then joint=12;

 else if totalpacat2lag=4 and pctmeetcat=2 then joint=13;
 else if totalpacat2lag=4 and pctmeetcat=3 then joint=14;
 else if totalpacat2lag=4 and pctmeetcat=4 then joint=15;
 else if totalpacat2lag=4 and pctmeetcat=5 then joint=16;

 else if totalpacat2lag=5 and pctmeetcat=2 then joint=17;
 else if totalpacat2lag=5 and pctmeetcat=3 then joint=18;
 else if totalpacat2lag=5 and pctmeetcat=4 then joint=19;
 else if totalpacat2lag=5 and pctmeetcat=5 then joint=20;

 else if totalpacat2lag=6 and pctmeetcat=2 then joint=21;
 else if totalpacat2lag=6 and pctmeetcat=3 then joint=22;
 else if totalpacat2lag=6 and pctmeetcat=4 then joint=23;
 else if totalpacat2lag=6 and pctmeetcat=5 then joint=24; 


%indic3(vbl=joint,    prefix=joint,   min=1, max=24, reflev=1, missing=., usemiss=0);


run;


proc means data=pooled nmiss min max median mean; 
   var age;
run;



data pooled;
     set pooled;
     if age<60 then oldage=0;
     else if age>=60 then oldage=1;
run;

data young;
     set pooled;
     where oldage=0;
run;

data old;
     set pooled;
     where oldage=1;
run;


proc freq data=young;
  tables totalpacat2lag * pctmeetcat /missing;
run;


proc freq data=old;
  tables totalpacat2lag * pctmeetcat /missing;
run;



%pre_pm(data=young, out=young_py, timevar=periodnew,
        irt= irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead cvddead noncvddead , 
        var=joint );

%pm(data=young_py, case= alldead cvddead noncvddead , 
  exposure=joint , ref=1);


%pre_pm(data=old, out=old_py, timevar=periodnew,
        irt= irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead cvddead noncvddead , 
        var=joint );

%pm(data=old_py, case= alldead cvddead noncvddead , 
  exposure=joint , ref=1);




%let cov1 = white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_;



%macro consist_cox (event, time);

%mphreg9(data=pooled, outdat=&event._out,
         event=&event, 
         time=&time, 
         timevar=t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18,
         qret=irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20,
         cutoff=cutoff, 
         dtdx=dtdth, dtdth=dtdth, id=id, agevar=agemo, tvar=periodnew, labels=F, strata=agemo periodnew cohort,
         byvar=oldage,


model1=&joint_ &cov1 


); run;




data &event._out;
set &event._out;

if  index(variable, 'joint')  ;

HR=put(HazardRatio, 8.2)|| ' (' || put(lcl, 4.2) || ', ' || put(ucl, 4.2) || ')';

run;


proc export data=&event._out
            outfile='/udd/hpyzh/pa_consist/pooled/subgroup/pooled_age.xlsx' dbms=xlsx replace;  sheet="&event.";

run;


%mend;



%consist_cox(alldead, talldead);






