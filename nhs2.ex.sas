
%include "/udd/hpyzh/pa_consist/nhs2/nhs2.covars.sas";




%beginex();

/*************************************************************/
/*                DO-LOOP OVER TIME PERIODS                  */ 

   do i=1 to DIM(irt)-1; 
   interval=i;
   do j=1 to DIM(tvar);
    tvar{j}=0;
    period{j}=0;
    end;
   
    tvar{i}=1; 
    period{i}=1;  


/* ALL MORTALITY */
alldead=0;
talldead=irt[i+1]-irt[i];
if (irt[i]<dtdth<=irt[i+1]) then do;
	alldead=1; 
	talldead=dtdth-irt[i];
	end;

/* cause-specific death */

%macro event(case, index, time);
&case.dead=0; 
&time=irt{i+1}-irt{i};
if alldead=1 and &index=1 then do;
	&case.dead=1;
	&time=dtdth-irt{i};
end;
%mend event;

%event(cvd,     dead_cvd,     tcvd);
%event(resp,    dead_resp,    tresp);
%event(neuro,   dead_neuro,   tneuro);
%event(renal,   dead_renal,   trenal);
%event(injury,  dead_injury,  tinjury);
%event(suicide, dead_suicide, tsuicide);
%event(diab,     dead_diab,     tdiab);

%event(cancer,  dead_cancer,  tcancer);

%event(gica,     dead_gica,        tgica);
%event(gitca,    dead_gitca,       tgitca);
%event(upgitca,  dead_upgitca,     tupgitca);
%event(gioca,    dead_gioca,       tgioca);
%event(crcca,    dead_colorectca,  tcrc);

%event(obesca,   dead_obesca,        tobesca);
%event(smokeca,  dead_smokeca,       tsmokeca);

%event(breastca,   dead_brca,        tbreastca);
%event(cervica,    dead_cervicalca,  tcervica);
%event(endoca,     dead_endoca,      tendoca);
%event(ovca,       dead_ovca,        tovca);


%event(lungca,      dead_lungca,      tlungca);
%event(headneckca,  dead_headneckca,  theadneckca);
%event(boneca,      dead_boneca,      tboneca);
%event(connectca,   dead_connectca,   tconnectca);
%event(mel,         dead_mel,         tmel);
%event(bladderca,   dead_bladderca,   tbladderca);
%event(kidneyca,    dead_kidneyca,    tkidneyca);
%event(eyeca,       dead_eyeca,       teyeca);
%event(brainca,     dead_brainca,     tbrainca);
%event(nervousca,   dead_nervousca,   tnervousca);
%event(thyroidca,   dead_thyroidca,   tthyroidca);
%event(bloodca,     dead_bloodca,     tbloodca);

%event(other,     dead_other,     tother);


%event(ascvd, dead_ascvd, tascvd);
%event(ihd, dead_ihd,     tihd);


%event(noncvd,     dead_noncvd,     tnoncvd);




* covariates ;
	age		= agea{i};
	agemo   = agemoa{i};
	ageg    = agega{i};

	alco	= alcocuma{i}; if alco=. then alco=1.91;
	alcog 	= alcoga{i}; if alcog = . then do;  alcog = 1; end;
	cigg 	= cigga{i};  if cigg = . then do;  cigg = 1; end;
	pkyrg	= pkyrga{i};
	pkyr    = pkyra{i};
	bmi		= bmicuma{i};
	bmig 	= bmiga{i}; if bmig = . then do; bmi = 24.78; bmig = 2; end;
    bmibase = bmiga{1}; if bmibase=. then bmibase=2;

    pscexam = pscexama{i}; if pscexam=. then pscexam=0; 

	ses 	= sesa{i}; if ses =. then do;  ses = .; end;

	ccalor  = ccalora{i}; if ccalor=. then ccalor=1776.83; 
	cahei   = caheia{i};  if cahei = . then do; cahei =53.58; end;

	pmh		= pmha{i}; if pmh = . then pmh=1; 

    beercum = beercuma{i};
    winecum = winecuma{i}; 
    liqcum = liqcuma{i};
    alccum = alccuma{i};

    endosc=endo{i}; if endosc=. then endosc=0;
    mvyn	= mvyna{i}; 


* physical activity *;

totalpav2lag = totalpav2laga{i};
totalpav4lag = totalpav4laga{i};
totalpav8lag = totalpav8laga{i};
totalpav12lag = totalpav12laga{i};


pctmeet2lag = pctmeet2laga{i};
pctmeett2lag = pctmeett2laga{i};
pctmeettt2lag = pctmeettt2laga{i};

pctmeet4lag = pctmeet4laga{i};
pctmeett4lag = pctmeett4laga{i};
pctmeettt4lag = pctmeettt4laga{i};

pctmeet8lag = pctmeet8laga{i};
pctmeett8lag = pctmeett8laga{i};
pctmeettt8lag = pctmeettt8laga{i};

pctmeet12lag = pctmeet12laga{i};
pctmeett12lag = pctmeett12laga{i};
pctmeettt12lag = pctmeettt12laga{i};

treport = treporta{i};


/* ----------- Exclusion ----------- */
	if i=1 then do;
		%exclude(id gt ., nodelete=T);
		%exclude(exrec eq 1); * duplicate records per ID and records not in mstr file ;
		%exclude(birthday eq . ); * missing date of birth;

		%exclude(0 lt dtdth le irt{1});
	
		%exclude(can91 eq 1);
		%exclude(str91 eq 1);
		%exclude(ang91 eq 1);
		%exclude(mi91 eq 1);
		*%exclude(cabg91 eq 1); /* cabg first measured in 1995*/

		%exclude(q32pt89 eq 1);  * passthrough 1989 PA section ;
		%exclude(totalpa89mv eq .);
		%exclude(pctmeet89 eq .);

		%exclude(id gt ., nodelete=T);
		%output();
	end;
	else if i>1 then do; 
		%exclude(irt{i-1} lt dtdth le irt{i}); 

	%output();
	end;
end; * end of time period loop;
%endex(); * end of exclusions;
keep id t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 cutoff 
        irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18  

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
        beercum winecum liqcum alccum
        endosc mvyn


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

        treport

;
run;


/* already 2-lag year data, start of follow-up in 1991 */

data nhs2_data_2lag; set nhs2_data; 

/* assign median for missing */

  if beercum=. then beercum=0;
  if winecum=. then winecum=0.53;
  if liqcum=. then liqcum=0;
  if alccum=. then alccum=1.33;


run;


proc means data=nhs2_data_2lag nolabels n nmiss min max mean median maxdec=2; var alco cigg bmi ccalor cahei beercum winecum liqcum alccum; run;


proc freq data=nhs2_data_2lag;
	tables 	alldead cvddead respdead neurodead renaldead injurydead suicidedead diabdead otherdead
	        cancerdead gicadead upgitcadead giocadead crccadead
	        obescadead smokecadead 
	        breastcadead cervicadead endocadead ovcadead
	        lungcadead headneckcadead bonecadead connectcadead meldead bladdercadead kidneycadead eyecadead braincadead nervouscadead thyroidcadead bloodcadead
	        ascvddead ihddead/missing;
run;



%macro meanbyperiod (var);
        proc means data=nhs2_data_2lag nolabels nmiss min max median mean stddev maxdec=2;
            class interval ;
            var &var.;
        run;
    %mend;
%macro freqbyperiod (var);
        proc freq data=nhs2_data_2lag;
            tables (&var.)*interval / missing norow nopercent;
        run;
    %mend;



%meanbyperiod (ccalor);  
%meanbyperiod (cahei); 

%freqbyperiod (mifh);
%freqbyperiod (canfh);

%freqbyperiod (cigg);
%freqbyperiod (pkyrg);

%freqbyperiod (alcog);

%freqbyperiod (pscexam);

%freqbyperiod (pmh);

%freqbyperiod (endosc);
%freqbyperiod (mvyn);

%meanbyperiod (totalpav2lag); 
%meanbyperiod (totalpav4lag); 
%meanbyperiod (totalpav8lag); 
%meanbyperiod (totalpav12lag); 


%meanbyperiod (pctmeet2lag); 
%meanbyperiod (pctmeett2lag); 
%meanbyperiod (pctmeettt2lag); 

%freqbyperiod (treport);



proc rank data=nhs2_data_2lag group=4 out=nhs2_data_2lag;
var   ccalor   cahei  ;
ranks qccalor  qcahei ;
run;


data nhs2_data_2lag;
	set nhs2_data_2lag;

qccalor=qccalor+1;
qcahei=qcahei+1;

%indic3(vbl=qccalor,     prefix=qccalor,    min=1, max=4, reflev=1, missing=., usemiss=0);
%indic3(vbl=qcahei,      prefix=qcahei,     min=1, max=4, reflev=1, missing=., usemiss=0);

%indic3(vbl=alcog,       prefix=alcog,      min=2, max=3, reflev=1, usemiss=0);
%indic3(vbl=cigg,        prefix=cigg,       min=2, max=4, reflev=1, usemiss=0);
%indic3(vbl=pkyrg,       prefix=pkyrg,      min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=bmig,        prefix=bmig,       min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=bmibase,     prefix=bmibase,    min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=pmh,         prefix=pmh,        min=2, max=4, reflev=1, usemiss=0);

run;

*** Output dataset;


libname ss "";
   data ss.nhs2_data_2lag; 
        set nhs2_data_2lag;
run;







