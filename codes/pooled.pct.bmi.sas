
/* Joint association between total PA and consistency */
/* cate categories */
/* reference group: <7.5 */

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
  class totalpacat2lag;
  var totalpav2lag;
run;


proc means data=pooled nmiss min max median mean; 
  class pctmeetcat;
  var pctmeet2lag;
run;


proc means data=pooled nmiss min max median mean; 
  class joint;
  var totalpav2lag;
run;


proc freq data=pooled;
	tables 
    totalpacat2lag pctmeetcat
    totalpacat2lag * pctmeetcat /missing
	;
run;




%pre_pm(data=pooled, out=pooled_py, timevar=periodnew,
        irt= irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead , 
        var=joint );

%pm(data=pooled_py, case= alldead , 
  exposure=joint , ref=1);





%let cov1 = white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_;



%macro consist_cox (event, time);

%mphreg9(data=pooled, outdat=&event._out,
         event=&event, 
         time=&time, 
         timevar=t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20,
         qret=irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20,
         cutoff=cutoff, 
         dtdx=dtdth, dtdth=dtdth, id=id, agevar=agemo, tvar=periodnew, labels=F, strata=agemo periodnew cohort,


model1=&joint_ &cov1 &bmig_


); run;




data &event._out;
set &event._out;

if  index(variable, 'joint')  ;

HR=put(HazardRatio, 8.2)|| ' (' || put(lcl, 4.2) || ', ' || put(ucl, 4.2) || ')';

run;


proc export data=&event._out
            outfile='/udd/hpyzh/pa_consist/pooled/pct/pooled_pct_bmi.xlsx' dbms=xlsx replace;  sheet="&event.";

run;


%mend;



%consist_cox(alldead, talldead);
%consist_cox(cvddead, tcvd);
%consist_cox(noncvddead, tnoncvd);





