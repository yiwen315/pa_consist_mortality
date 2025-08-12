/* association between total PA and mortality by consistency level */

%include "/udd/hpyzh/pa_consist/pooled/pooled_data_setup.sas";

data pooled;
	set pooled;
run;



proc rank data=pooled group=5 out=pooled;
var   totalpav2lag  ;
ranks totalpav2lagqq ;
run;


data pooled; set pooled; totalpav2lagqq=totalpav2lagqq+1; %indic3(vbl=totalpav2lagqq, prefix=totalpav2lagqq, min=1, max=5, reflev=1, missing=., usemiss=0);run;

proc freq data=pooled; table totalpav2lagqq; run;


proc means data=pooled nmiss min max median mean; 
  class totalpav2lagqq;
  var totalpav2lag;
run;


%pre_pm(data=pooled, out=pooled_py, timevar=periodnew,
        irt= irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead cvddead noncvddead , 
        var=totalpav2lagqq );

%pm(data=pooled_py, case= alldead cvddead noncvddead , 
  exposure=totalpav2lagqq , ref=1);




%let cov1 = white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_;



%macro consist_cox (event, time);

%mphreg9(data=pooled, outdat=&event._out,
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




data &event._out;
set &event._out;

if  index(variable, 'totalpav2lagqq') | index(variable, 'totalpav2lag') ;

HR=put(HazardRatio, 8.2)|| ' (' || put(lcl, 4.2) || ', ' || put(ucl, 4.2) || ')';

run;


proc export data=&event._out
            outfile='/udd/hpyzh/pa_consist/pooled/by_pct/pooled_all.xlsx' dbms=xlsx replace;  sheet="&event.";

run;


%mend;


%consist_cox(alldead, talldead);
/*
%consist_cox(cvddead, tcvd);
%consist_cox(noncvddead, tnoncvd);*/

