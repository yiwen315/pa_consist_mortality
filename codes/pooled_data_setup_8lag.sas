
/* 8 year lag */

filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/';
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos/';
libname nhsfmt '/proj/nhsass/nhsas00/formats';
libname hpfsfmt '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing nhstools hpstools);
options fmtsearch=(nhsfmt hpfsfmt) nocenter nofmterr;
options ls=125 ps=78;



libname ss "/udd/hpyzh/pa_consist/hpfs";


data hpfs_new;
	set ss.hpfs_data_2lag;


female=0;
pmh=2; /* never user */
cohort=1;

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


		cohort interval birthday race white  

		age agemo ageg  
        dbfh mifh canfh 
        alco alcog cigg pkyr pkyrg bmi bmig bmibase ccalor cahei 
        pscexam
        qccalor qcahei
        pmh

		can88 str88 ang88 mi88 cabg88 
		can90 str90 ang90 mi90 cabg90
		can92 str92 ang92 mi92 cabg92
		can94 str94 ang94 mi94 cabg94
		can96 str96 ang96 mi96 cabg96
		can98 str98 ang98 mi98 cabg98
		can00 str00 ang00 mi00 cabg00
		can02 str02 ang02 mi02 cabg02


        totalpav2lag totalpav4lag totalpav8lag totalpav12lag
        
        pctmeet2lag pctmeett2lag pctmeettt2lag
        pctmeet4lag pctmeett4lag pctmeettt4lag
        pctmeet8lag pctmeett8lag pctmeettt8lag
        pctmeet12lag pctmeett12lag pctmeettt12lag

;
run;


libname zz "/udd/hpyzh/pa_consist/nhs";


data nhs_new;
	set zz.nhs_data_2lag;

female=1;
cohort=2;

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



		cohort interval birthday race9204 white  

		age agemo ageg  
        dbfh mifh canfh 
        alco alcog cigg pkyr pkyrg bmi bmig bmibase ses ccalor cahei 
        pscexam 
        pmh
        qccalor qcahei

        can86 str86 ang86 mi86 cabg86
        can88 str88 ang88 mi88 cabg88
        can90 str90 ang90 mi90 cabg90
        can92 str92 ang92 mi92 cabg92 
        can94 str94 ang94 mi94 cabg94
        can96 str96 ang96 mi96 cabg96
        can98 str98 ang98 mi98 cabg98
        can00 str00 ang00 mi00 cabg00
        can02 str02 ang02 mi02 cabg02 
        can04 str04 ang04 mi04 cabg04 
        can06 str06 ang06 mi06 cabg06 
        can08 str08 ang08 mi08 cabg08 
        can10 str10 ang10 mi10 cabg10 
        can12 str12 ang12 mi12 cabg12 


        totalpav2lag totalpav4lag totalpav8lag totalpav12lag
        
        pctmeet2lag pctmeett2lag pctmeettt2lag
        pctmeet4lag pctmeett4lag pctmeettt4lag
        pctmeet8lag pctmeett8lag pctmeettt8lag
        pctmeet12lag pctmeett12lag pctmeettt12lag

;
run;



libname kk "/udd/hpyzh/pa_consist/nhs2";


data nhs2_new;
	set kk.nhs2_data_2lag;

female=1;
cohort=3;


irt88=irt90-24;

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



		cohort interval birthday race8905 white  

		age agemo ageg  
        dbfh mifh canfh 
        alco alcog cigg pkyr pkyrg bmi bmig bmibase ses ccalor cahei 
        pscexam
        pmh
        qccalor qcahei


        can93 str93 ang93 mi93  
        can95 str95 ang95 mi95 cabg95
        can97 str97 ang97 mi97 cabg97
        can99 str99 ang99 mi99 cabg99
        can01 str01 ang01 mi01 cabg01
        can03 str03 ang03 mi03 cabg03
        can05 str05 ang05 mi05 cabg05
        can07 str07 ang07 mi07 cabg07
        can09 str09 ang09 mi09 cabg09
        can11 str11 ang11 mi11 cabg11
        can13 str13 ang13 mi13 cabg13


        totalpav2lag totalpav4lag totalpav8lag totalpav12lag
        
        pctmeet2lag pctmeett2lag pctmeettt2lag
        pctmeet4lag pctmeett4lag pctmeettt4lag
        pctmeet8lag pctmeett8lag pctmeettt8lag
        pctmeet12lag pctmeett12lag pctmeettt12lag


;
run;



/********* create 8year - lag data *********/
data hpfs_new_8lag; set hpfs_new; 
 if interval<5 then delete; 
 if .<dtdth le irt94 then delete;

if can90 eq 1 or can92 eq 1 or can94 eq 1 then delete;
if str90 eq 1 or str92 eq 1 or str94 eq 1 then delete;
if ang90 eq 1 or ang92 eq 1 or ang94 eq 1 then delete;
if mi90 eq 1 or mi92 eq 1 or mi94 eq 1 then delete;
if cabg90 eq 1 or cabg92 eq 1 or cabg94 eq 1  then delete;

run;


data nhs_new_8lag; set nhs_new; 
 if interval<6 then delete; 
 if .<dtdth le irt94 then delete;

if can90 eq 1 or can92 eq 1 or can94 eq 1 then delete;
if str90 eq 1 or str92 eq 1 or str94 eq 1 then delete;
if ang90 eq 1 or ang92 eq 1 or ang94 eq 1 then delete;
if mi90 eq 1 or mi92 eq 1 or mi94 eq 1 then delete;
if cabg90 eq 1 or cabg92 eq 1 or cabg94 eq 1 then delete;

run;


data nhs2_new_8lag; set nhs2_new; 
 if interval<4 then delete; 
 if .<dtdth le irt96 then delete;

if can93 eq 1 or can95 eq 1 or can97 eq 1 then delete;
if str93 eq 1 or str95 eq 1 or str97 eq 1 then delete;
if ang93 eq 1 or ang95 eq 1 or ang97 eq 1 then delete;
if mi93 eq 1 or mi95 eq 1 or mi97 eq 1 then delete;
           if cabg95 eq 1 or cabg97 eq 1 then delete;

run;





data nhs_new_8lag; set nhs_new_8lag; id=id+1000000;periodnew=interval; run; 
data nhs2_new_8lag; set nhs2_new_8lag; id=id+2000000;periodnew=interval+2; run; 
data hpfs_new_8lag; set hpfs_new_8lag; id=id+3000000;periodnew=interval+1; run; 




/*  include HPFS, NHS and NHSII */

data pooled_8lag;
	set nhs_new_8lag nhs2_new_8lag hpfs_new_8lag end=_end_;

%indic3(vbl=qccalor,     prefix=qccalor,    min=1, max=4, reflev=1, missing=., usemiss=0);
%indic3(vbl=qcahei,      prefix=qcahei,     min=1, max=4, reflev=1, missing=., usemiss=0);

%indic3(vbl=alcog,       prefix=alcog,      min=2, max=3, reflev=1, usemiss=0);
%indic3(vbl=cigg,        prefix=cigg,       min=2, max=4, reflev=1, usemiss=0);
%indic3(vbl=pkyrg,       prefix=pkyrg,      min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=bmig,        prefix=bmig,       min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=bmibase,     prefix=bmibase,    min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=pmh,         prefix=pmh,        min=2, max=4, reflev=1, usemiss=0);



run;




































