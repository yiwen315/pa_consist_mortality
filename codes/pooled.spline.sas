
/* spline for total PA */

/* sensor at 150 MET-h/week */

%include "/udd/hpyzh/pa_consist/pooled/pooled_data_setup.sas";

proc means data=pooled p1 p5 p10 p25 p50 p75 p90 p95 p99;
	var totalpav2lag;
run;


data pooled_s;
	set pooled;
	where totalpav2lag <= 150;

run;





%let cov1 = white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_;


%LGTPHCURV9
(data=pooled_s, 
 exposure=totalpav2lag, 
 case=alldead, 
 time=talldead, 
 
 model=cox,
 strata=agemo periodnew cohort, 
 adj= white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_, 

 refval=0,  
 lowcut=0, 
 hpct=100,  
 nk=3,      

 plot=4, 
 plotdata=ttpa.2lag.all.txt

);



%LGTPHCURV9
(data=pooled_s, 
 exposure=totalpav2lag, 
 case=cvddead, 
 time=tcvd, 
 
 model=cox,
 strata=agemo periodnew cohort, 
 adj= white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_, 

 refval=0,  
 lowcut=0, 
 hpct=100,  
 nk=3,      

 plot=4, 
 plotdata=ttpa.2lag.cvd.txt
 
);


%LGTPHCURV9
(data=pooled_s, 
 exposure=totalpav2lag, 
 case=noncvddead, 
 time=tnoncvd, 
 
 model=cox,
 strata=agemo periodnew cohort, 
 adj= white mifh canfh &alcog_ &qccalor_ &cigg_ &pkyrg_ &qcahei_ &pmh_, 

 refval=0,  
 lowcut=0, 
 hpct=100,  
 nk=3,      

 plot=4, 
 plotdata=ttpa.2lag.noncvd.txt
 
);






