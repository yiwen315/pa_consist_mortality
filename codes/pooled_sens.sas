/* sensitivity analysis: further excluded participants who did not return the last 3 questionnaires */


filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/';
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos/';
libname nhsfmt '/proj/nhsass/nhsas00/formats';
libname hpfsfmt '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing nhstools hpstools);
options fmtsearch=(nhsfmt hpfsfmt) nocenter nofmterr;
options ls=125 ps=78;



libname ss "/udd/hpyzh/pa_consist/hpfs/sens";


data hpfs_new;
	set ss.hpfs_data_2lag_sens;


female=0;
pmh=2; /* never user */
cohort=1;

/*moderate drinking: men 5-29.9 */
 drink_mod=0; if 5=<alco<30 then drink_mod=1; 

/*heavy drinking: men 30+ */
 drink_hea=0; if alco>=30 then drink_hea=1;


keep id  t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20 cutoff 
         irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20

		dtdth newicda dead_:
		alldead talldead

		cvddead     tcvd
		respdead    tresp
		neurodead   tneuro
		renaldead   trenal
		injurydead  tinjury
		suicidedead tsuicide
		diabdead    tdiab


		cancerdead  tcancer
		gicadead    tgica
		upgitcadead tupgitca
		giocadead   tgioca
		crccadead   tcrc

		obescadead  tobesca
		smokecadead tsmokeca
		pcacadead   tpcaca

        lungcadead      tlungca
        headneckcadead  theadneckca
        bonecadead      tboneca
        connectcadead   tconnectca
        meldead         tmel
        bladdercadead   tbladderca
        kidneycadead    tkidneyca
        eyecadead       teyeca
        braincadead     tbrainca
        nervouscadead   tnervousca
        thyroidcadead   tthyroidca
        bloodcadead     tbloodca

        otherdead     tother

        ascvddead     tascvd
        ihddead       tihd

        noncvddead    tnoncvd


		cohort interval birthday race white  female

		age agemo ageg  
        dbfh mifh canfh 
        alco alcog cigg pkyr pkyrg bmi bmig bmibase ccalor cahei 
        pscexam
        qccalor qcahei
        pmh
        mvyn
        psahiss endosc
        beercum winecum liqcum alccum
        drink_mod drink_hea


        totalpav2lag totalpav4lag totalpav8lag totalpav12lag
        
        pctmeet2lag pctmeett2lag pctmeettt2lag

        treport

;
run;


libname zz "/udd/hpyzh/pa_consist/nhs/sens";


data nhs_new;
	set zz.nhs_data_2lag_sens;

female=1;
cohort=2;

/*moderate drinking: women 5-14.9 */
 drink_mod=0; if 5=<alco<15 then drink_mod=1; 

/*heavy drinking: women 15+ */
 drink_hea=0; if alco>=15 then drink_hea=1;

keep id t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20 cutoff 
	    irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20

		dtdth newicda dead_:
		alldead talldead

		cvddead     tcvd
		respdead    tresp
		neurodead   tneuro
		renaldead   trenal
		injurydead  tinjury
		suicidedead tsuicide
		diabdead    tdiab

		cancerdead  tcancer
		gicadead    tgica
		upgitcadead tupgitca
		giocadead   tgioca
		crccadead   tcrc

		obescadead  tobesca
		smokecadead tsmokeca

        breastcadead tbreastca
        cervicadead  tcervica
        endocadead   tendoca
        ovcadead     tovca

        lungcadead      tlungca
        headneckcadead  theadneckca
        bonecadead      tboneca
        connectcadead   tconnectca
        meldead         tmel
        bladdercadead   tbladderca
        kidneycadead    tkidneyca
        eyecadead       teyeca
        braincadead     tbrainca
        nervouscadead   tnervousca
        thyroidcadead   tthyroidca
        bloodcadead     tbloodca

        otherdead     tother

        ascvddead     tascvd
        ihddead       tihd

        noncvddead    tnoncvd



		cohort interval birthday race9204 white  female

		age agemo ageg  
        dbfh mifh canfh 
        alco alcog cigg pkyr pkyrg bmi bmig bmibase ses ccalor cahei 
        pscexam 
        pmh
        qccalor qcahei
        endosc mvyn
        beercum winecum liqcum alccum
        drink_mod drink_hea

         

        totalpav2lag totalpav4lag totalpav8lag totalpav12lag
        
        pctmeet2lag pctmeett2lag pctmeettt2lag

        treport

;
run;



libname kk "/udd/hpyzh/pa_consist/nhs2/sens";


data nhs2_new;
	set kk.nhs2_data_2lag_sens;

female=1;
cohort=3;

irt88=irt90-24;

/*moderate drinking: women 5-14.9 */
 drink_mod=0; if 5=<alco<15 then drink_mod=1; 

/*heavy drinking: women 15+ */
 drink_hea=0; if alco>=15 then drink_hea=1;

keep id       t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 cutoff 
        irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18  

		dtdth newicda dead_:
		alldead talldead

		cvddead     tcvd
		respdead    tresp
		neurodead   tneuro
		renaldead   trenal
		injurydead  tinjury
		suicidedead tsuicide
		diabdead    tdiab

		cancerdead  tcancer
		gicadead    tgica
		upgitcadead tupgitca
		giocadead   tgioca
		crccadead   tcrc

		obescadead  tobesca
		smokecadead tsmokeca

        breastcadead tbreastca
        cervicadead  tcervica
        endocadead   tendoca
        ovcadead     tovca

        lungcadead      tlungca
        headneckcadead  theadneckca
        bonecadead      tboneca
        connectcadead   tconnectca
        meldead         tmel
        bladdercadead   tbladderca
        kidneycadead    tkidneyca
        eyecadead       teyeca
        braincadead     tbrainca
        nervouscadead   tnervousca
        thyroidcadead   tthyroidca
        bloodcadead     tbloodca

        otherdead     tother

        ascvddead     tascvd
        ihddead       tihd


        noncvddead    tnoncvd



		cohort interval birthday race8905 white  female

		age agemo ageg  
        dbfh mifh canfh 
        alco alcog cigg pkyr pkyrg bmi bmig bmibase ses ccalor cahei 
        pscexam
        pmh
        qccalor qcahei
        endosc mvyn
        beercum winecum liqcum alccum
        drink_mod drink_hea


        totalpav2lag totalpav4lag totalpav8lag totalpav12lag
        
        pctmeet2lag pctmeett2lag pctmeettt2lag

        treport

;
run;


data nhs_new; set nhs_new; id=id+1000000;periodnew=interval; run; /*start from 1988, interval=3*/
data nhs2_new; set nhs2_new; id=id+2000000;periodnew=interval+2; run; /*start from 1990/1991, interval=1*/
data hpfs_new; set hpfs_new; id=id+3000000;periodnew=interval+1; run; /* start from 1988, interval=2*/




/*  include HPFS, NHS and NHSII */

data pooled;
	set nhs_new nhs2_new hpfs_new end=_end_;

%indic3(vbl=qccalor,     prefix=qccalor,    min=1, max=4, reflev=1, missing=., usemiss=0);
%indic3(vbl=qcahei,      prefix=qcahei,     min=1, max=4, reflev=1, missing=., usemiss=0);

%indic3(vbl=alcog,       prefix=alcog,      min=2, max=3, reflev=1, usemiss=0);
%indic3(vbl=cigg,        prefix=cigg,       min=2, max=4, reflev=1, usemiss=0);
%indic3(vbl=pkyrg,       prefix=pkyrg,      min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=bmig,        prefix=bmig,       min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=bmibase,     prefix=bmibase,    min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=pmh,         prefix=pmh,        min=2, max=4, reflev=1, usemiss=0);





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



%pre_pm(data=pooled, out=pooled_py, timevar=periodnew,
        irt= irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20, 
        cutoff=cutoff, dtdx=dtdth, dtdth=dtdth,
        case= alldead cvddead noncvddead , 
        var=joint );

%pm(data=pooled_py, case= alldead cvddead noncvddead , 
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


model1=&joint_ &cov1 


); run;




data &event._out;
set &event._out;

if  index(variable, 'joint')  ;

HR=put(HazardRatio, 8.2)|| ' (' || put(lcl, 4.2) || ', ' || put(ucl, 4.2) || ')';

run;


proc export data=&event._out
            outfile='/udd/hpyzh/pa_consist/pooled/sens/pooled_pct_sens.xlsx' dbms=xlsx replace;  sheet="&event.";

run;


%mend;



%consist_cox(alldead, talldead);
%consist_cox(cvddead, tcvd);
%consist_cox(noncvddead, tnoncvd);
































