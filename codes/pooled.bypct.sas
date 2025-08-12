/* association between total PA and mortality by consistency level */

%include "/udd/hpyzh/pa_consist/pooled/pooled_data_setup.sas";

data pooled;
	set pooled;

      if pctmeet2lag<0.50       then pctmeetcat=1;
 else if 0.50=<pctmeet2lag<1    then pctmeetcat=2;
 else if 1=pctmeet2lag          then pctmeetcat=3;

run;


data pctcat1;
	set pooled;
	where pctmeetcat=1;
run;

data pctcat2;
	set pooled;
	where pctmeetcat=2;
run;

data pctcat3;
	set pooled;
	where pctmeetcat=3;
run;




proc rank data=pctcat1 group=5 out=pctcat1;
var   totalpav2lag  ;
ranks totalpav2lagqq ;
run;

proc rank data=pctcat2 group=5 out=pctcat2;
var   totalpav2lag  ;
ranks totalpav2lagqq ;
run;

proc rank data=pctcat3 group=5 out=pctcat3;
var   totalpav2lag  ;
ranks totalpav2lagqq ;
run;




data pctcat1; set pctcat1; totalpav2lagqq=totalpav2lagqq+1; %indic3(vbl=totalpav2lagqq, prefix=totalpav2lagqq, min=1, max=5, reflev=1, missing=., usemiss=0);run;
data pctcat2; set pctcat2; totalpav2lagqq=totalpav2lagqq+1; %indic3(vbl=totalpav2lagqq, prefix=totalpav2lagqq, min=1, max=5, reflev=1, missing=., usemiss=0);run;
data pctcat3; set pctcat3; totalpav2lagqq=totalpav2lagqq+1; %indic3(vbl=totalpav2lagqq, prefix=totalpav2lagqq, min=1, max=5, reflev=1, missing=., usemiss=0);run;


proc freq data=pctcat1; table totalpav2lagqq; run;
proc freq data=pctcat2; table totalpav2lagqq; run;
proc freq data=pctcat3; table totalpav2lagqq; run;


proc means data=pctcat1 nmiss min max median mean; 
  class totalpav2lagqq;
  var totalpav2lag;
run;

proc means data=pctcat2 nmiss min max median mean; 
  class totalpav2lagqq;
  var totalpav2lag;
run;

proc means data=pctcat3 nmiss min max median mean; 
  class totalpav2lagqq;
  var totalpav2lag;
run;



%pre_pm(data=pctcat1, out=pctcat1_py, timevar=periodnew,
        irt= irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead cvddead noncvddead , 
        var=totalpav2lagqq );

%pm(data=pctcat1_py, case= alldead cvddead noncvddead , 
  exposure=totalpav2lagqq , ref=1);

%pre_pm(data=pctcat2, out=pctcat2_py, timevar=periodnew,
        irt= irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead cvddead noncvddead , 
        var=totalpav2lagqq );

%pm(data=pctcat2_py, case= alldead cvddead noncvddead , 
  exposure=totalpav2lagqq , ref=1);

%pre_pm(data=pctcat3, out=pctcat3_py, timevar=periodnew,
        irt= irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead cvddead noncvddead , 
        var=totalpav2lagqq );

%pm(data=pctcat3_py, case= alldead cvddead noncvddead , 
  exposure=totalpav2lagqq , ref=1);






%let cov1 = white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_;




%macro consist_cox (data, event, time);

%mphreg9(data=&data, outdat=&data._out,
         event=&event, 
         time=&time, 
         timevar=t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20,
         qret=irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
         cutoff=cutoff, 
         dtdx=dtdth, dtdth=dtdth, id=id, agevar=agemo, tvar=periodnew, labels=F, strata=agemo periodnew cohort,


model1=&totalpav2lagqq_ , 
model2=&totalpav2lagqq_ &cov1 ,
model3=&totalpav2lagqq_ &cov1 &bmig_,

model4=totalpav2lag , 
model5=totalpav2lag &cov1 ,
model6=totalpav2lag &cov1 &bmig_

); run;




data &data._out;
set &data._out;

if  index(variable, 'totalpav2lagqq') | index(variable, 'totalpav2lag') ;

HR=put(HazardRatio, 8.2)|| ' (' || put(lcl, 4.2) || ', ' || put(ucl, 4.2) || ')';

run;


proc export data=&data._out
            outfile='/udd/hpyzh/pa_consist/pooled/by_pct/pooled_bypct.xlsx' dbms=xlsx replace;  sheet="&data.";

run;


%mend;




%consist_cox(pctcat1, alldead, talldead);
%consist_cox(pctcat2, alldead, talldead);
%consist_cox(pctcat3, alldead, talldead);




