
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


proc freq data=pooled;
	tables totalpacat2lag * pctmeetcat/missing;
run;

/*
totalpacat2lag     pctmeetcat

Frequency|
Percent  |
Row Pct  |
Col Pct  |       1|       2|       3|       4|       5|  Total
---------+--------+--------+--------+--------+--------+
       1 | 460274 | 288436 |  99023 |   1253 |      0 | 848986
         |  14.05 |   8.80 |   3.02 |   0.04 |   0.00 |  25.91
         |  54.21 |  33.97 |  11.66 |   0.15 |   0.00 |
         | 100.00 |  63.94 |  14.78 |   0.29 |   0.00 |
---------+--------+--------+--------+--------+--------+
       2 |      0 | 138622 | 349440 |  97772 | 180943 | 766777
         |   0.00 |   4.23 |  10.67 |   2.98 |   5.52 |  23.40
         |   0.00 |  18.08 |  45.57 |  12.75 |  23.60 |
         |   0.00 |  30.73 |  52.15 |  22.93 |  14.27 |
---------+--------+--------+--------+--------+--------+
       3 |      0 |  17720 | 137241 | 141425 | 250449 | 546835
         |   0.00 |   0.54 |   4.19 |   4.32 |   7.64 |  16.69
         |   0.00 |   3.24 |  25.10 |  25.86 |  45.80 |
         |   0.00 |   3.93 |  20.48 |  33.16 |  19.75 |
---------+--------+--------+--------+--------+--------+
       4 |      0 |   4030 |  47964 |  85329 | 222377 | 359700
         |   0.00 |   0.12 |   1.46 |   2.60 |   6.79 |  10.98
         |   0.00 |   1.12 |  13.33 |  23.72 |  61.82 |
         |   0.00 |   0.89 |   7.16 |  20.01 |  17.53 |
---------+--------+--------+--------+--------+--------+
       5 |      0 |   1900 |  26876 |  70970 | 297654 | 397400
         |   0.00 |   0.06 |   0.82 |   2.17 |   9.09 |  12.13
         |   0.00 |   0.48 |   6.76 |  17.86 |  74.90 |
         |   0.00 |   0.42 |   4.01 |  16.64 |  23.47 |
---------+--------+--------+--------+--------+--------+
       6 |      0 |    414 |   9556 |  29680 | 316882 | 356532
         |   0.00 |   0.01 |   0.29 |   0.91 |   9.67 |  10.88
         |   0.00 |   0.12 |   2.68 |   8.32 |  88.88 |
         |   0.00 |   0.09 |   1.43 |   6.96 |  24.98 |
---------+--------+--------+--------+--------+--------+
Total      460274   451122   670100   426429  1268305  3276230
            14.05    13.77    20.45    13.02    38.71   100.00
*/


data data_pa1;
	set pooled;
    where totalpacat2lag in (1,2);

      if totalpacat2lag=1 and pctmeetcat=1 then joint=1;
 else if totalpacat2lag=1 and pctmeetcat=2 then joint=2;
 else if totalpacat2lag=1 and pctmeetcat=3 then joint=3;
 else if totalpacat2lag=1 and pctmeetcat=4 then joint=4;
 else if totalpacat2lag=2 and pctmeetcat=2 then joint=5;
 else if totalpacat2lag=2 and pctmeetcat=3 then joint=6;
 else if totalpacat2lag=2 and pctmeetcat=4 then joint=7;
 else if totalpacat2lag=2 and pctmeetcat=5 then joint=8;

run;


data data_pa2;
    set pooled;
    where totalpacat2lag in (3,4);

      if totalpacat2lag=3 and pctmeetcat=2 then joint=1;
 else if totalpacat2lag=3 and pctmeetcat=3 then joint=2;
 else if totalpacat2lag=3 and pctmeetcat=4 then joint=3;
 else if totalpacat2lag=3 and pctmeetcat=5 then joint=4;
 else if totalpacat2lag=4 and pctmeetcat=2 then joint=5;
 else if totalpacat2lag=4 and pctmeetcat=3 then joint=6;
 else if totalpacat2lag=4 and pctmeetcat=4 then joint=7;
 else if totalpacat2lag=4 and pctmeetcat=5 then joint=8;

run;

data data_pa3;
    set pooled;
    where totalpacat2lag in (5,6);

      if totalpacat2lag=5 and pctmeetcat=2 then joint=1;
 else if totalpacat2lag=5 and pctmeetcat=3 then joint=2;
 else if totalpacat2lag=5 and pctmeetcat=4 then joint=3;
 else if totalpacat2lag=5 and pctmeetcat=5 then joint=4;
 else if totalpacat2lag=6 and pctmeetcat=2 then joint=5;
 else if totalpacat2lag=6 and pctmeetcat=3 then joint=6;
 else if totalpacat2lag=6 and pctmeetcat=4 then joint=7;
 else if totalpacat2lag=6 and pctmeetcat=5 then joint=8;

run;


%table1(
data = data_pa1,
exposure = joint, dec=1, agegroup = age, ageadj = F, 
varlist = totalpav2lag pctmeet2lag age bmi currentsmk pkyr cahei alco drink_mod drink_hea pscexam white female mifh canfh ccalor beercum winecum liqcum alccum mvyn endosc,
cat     =  white female mifh canfh currentsmk mvyn pscexam endosc drink_mod drink_hea,
file = pooled_pa1,
rtftitle = Characteristics by joint groups of total PA and conssitency throughout follow-up among PA group1
);

%table1(
data = data_pa2,
exposure = joint, dec=1, agegroup = age, ageadj = F, 
varlist = totalpav2lag pctmeet2lag age bmi currentsmk pkyr cahei alco drink_mod drink_hea pscexam white female mifh canfh ccalor beercum winecum liqcum alccum mvyn endosc,
cat     =  white female mifh canfh currentsmk mvyn pscexam endosc drink_mod drink_hea,
file = pooled_pa2,
rtftitle = Characteristics by joint groups of total PA and conssitency throughout follow-up among PA group2
);

%table1(
data = data_pa3,
exposure = joint, dec=1, agegroup = age, ageadj = F, 
varlist = totalpav2lag pctmeet2lag age bmi currentsmk pkyr cahei alco drink_mod drink_hea pscexam white female mifh canfh ccalor beercum winecum liqcum alccum mvyn endosc,
cat     =  white female mifh canfh currentsmk mvyn pscexam endosc drink_mod drink_hea,
file = pooled_pa3,
rtftitle = Characteristics by joint groups of total PA and conssitency throughout follow-up among PA group3
);



/* for consistency needs two decimal places */
/*
%table1(
data = data_pa1,
exposure = joint, dec=2, agegroup = age, ageadj = F, 
varlist = totalpav2lag pctmeet2lag ,
file = pooled_pa1_2d,
rtftitle = Characteristics by joint groups of total PA and conssitency throughout follow-up among PA group1
);

%table1(
data = data_pa2,
exposure = joint, dec=2, agegroup = age, ageadj = F, 
varlist = totalpav2lag pctmeet2lag ,
file = pooled_pa2_2d,
rtftitle = Characteristics by joint groups of total PA and conssitency throughout follow-up among PA group2
);

%table1(
data = data_pa3,
exposure = joint, dec=2, agegroup = age, ageadj = F, 
varlist = totalpav2lag pctmeet2lag ,
file = pooled_pa3_2d,
rtftitle = Characteristics by joint groups of total PA and conssitency throughout follow-up among PA group3
);
*/


/* Baseline age */

data hpfs_base;
     set hpfs_new;
     where interval=2;
run;

data nhs_base;
     set nhs_new;
     where interval=3;
run;

data nhs2_base;
     set nhs2_new;
     where interval=1;
run;



data pooled_base;
     set hpfs_base nhs_base nhs2_base;
run;

proc means data=pooled_base n nmiss min median mean max;
    var age;
run;





