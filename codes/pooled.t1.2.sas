
%include "/udd/hpyzh/pa_consist/pooled/pooled_data_setup.sas";

data pooled;
	set pooled;

if cohort=1 then female=0;
if cohort in (2,3) then female=1;

currentsmk=0; if cigg=4 then currentsmk=1; 

      if       totalpav2lag<7.5   then totalpacat2lag=1;
 else if  7.5<=totalpav2lag<15    then totalpacat2lag=2;
 else if   15<=totalpav2lag<22.5  then totalpacat2lag=3;
 else if   15<=totalpav2lag<30    then totalpacat2lag=4;
 else if   30<=totalpav2lag<45    then totalpacat2lag=5;
 else if   45<=totalpav2lag       then totalpacat2lag=6;

      if pctmeet2lag=0          then pctmeetcat=1;
 else if 0<pctmeet2lag<0.50     then pctmeetcat=2;
 else if 0.50=<pctmeet2lag<0.75 then pctmeetcat=3;
 else if 0.75=<pctmeet2lag<1    then pctmeetcat=4;
 else if 1=pctmeet2lag          then pctmeetcat=5; 

run;





%table1(
data = pooled,
exposure = totalpacat2lag, dec=1, agegroup = age, ageadj = F, 
varlist = totalpav2lag pctmeet2lag age bmi currentsmk pkyr cahei alco drink_mod drink_hea pscexam white female mifh canfh ccalor beercum winecum liqcum alccum mvyn endosc,
cat     =  white female mifh canfh currentsmk mvyn pscexam endosc drink_mod drink_hea,
file = pooled_bypa,
rtftitle = Characteristics by total PA throughout follow-up 
);




/* for consistency needs two decimal places */
/*
%table1(
data = pooled,
exposure = totalpacat2lag, dec=2, agegroup = age, ageadj = F, 
varlist = totalpav2lag pctmeet2lag ,
file = pooled_bypa2,
rtftitle = Characteristics by total PA throughout follow-up 
);
*/






