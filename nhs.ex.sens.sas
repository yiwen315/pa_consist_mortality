/* further excluded participants who did not return the last 3 questionnaires */


%include "/udd/hpyzh/pa_consist/nhs/nhs.covars.sas";



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

	alco	= alcocuma{i};
	alcog 	= alcoga{i}; if alcog = . then do;  alcog = 1; end;
	cigg 	= cigga{i};  if cigg = . then do;  cigg = 2; end;
	pkyrg	= pkyrga{i};
	pkyr    = pkyra{i};
	bmi		= bmicuma{i};
	bmig 	= bmiga{i}; if bmig = . then do; bmi =24.7; bmig = 2; end;
    bmibase = bmiga{1}; if bmibase=. then bmibase=2;

	ses 	= sesa{i}; if ses =. then do;  ses =. ; end;

	ccalor  = ccalora{i}; 
	cahei   = caheia{i};  if cahei = . then do; cahei =53.3; end;

    pscexam = pscexama{i}; if pscexam=. then pscexam=0;       

	pmh		= pmha{i}; if pmh = . then pmh=1; 

    beercum = beercuma{i};
    winecum = winecuma{i}; 
    liqcum = liqcuma{i};
    alccum = alccuma{i};

    endosc  =endo{i};  if endosc=. then endosc=0;
    mvyn    =mvita{i}; if mvyn in (.,9) then mvyn=0; /* assume non-user if missing */

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
        %exclude(yobf le 20 );

		%exclude(0 lt dtdth le irt{1});
        %exclude(dtdth eq 9999);     	 /* missing death date */
	
		%exclude(can84 eq 1);
		%exclude(str84 eq 1);
		%exclude(ang84 eq 1);
		%exclude(mi84 eq 1);
		%exclude(cabg84 eq 1);

		%exclude(q986pt eq 1);  * passthrough 1986 PA section ;
		%exclude(totalpa86mv eq .);
		%exclude(pctmeet86 eq .);

		%exclude(id gt ., nodelete=T);
		%output();
	end;

/***************  Each questionnaire cycle exclusions *****************/

/*
              i      1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19
 array treporta {18} treport86 treport86 treport86 treport88 treport88 treport92 treport94 treport96 treport98 treport00 treport00 treport04 treport04 treport08 treport08 treport12 treport14 treport14 treport14;
            n.Q      1         1         1         2         2         3         4         5         6         7         7         8         8         9         9         10        11        11        11
*/

    else if i=2 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
    	%output();
    end;

    else if i=3 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
    	%output();
    end;

    else if i=4 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
    	%output();
    end;


    else if i=5 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
    	%output();
    end;

    else if i=6 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        /* %exclude(treport92<1);  86, 88, 92 only 3 Q */ 
    	%output();
    end;

    else if i=7 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport94<2); /* reported 1 out of 4 questionnaire */ 
    	%output();
    end;

    else if i=8 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport96<3); /* reported 2 out of 5 questionnaire */ 
    	%output();
    end;

    else if i=9 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport98<4); /* reported 3 out of 6 questionnaire */ 
    	%output();
    end;

    else if i=10 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport00<5); /* reported 4 out of 7 questionnaire */ 
    	%output();
    end;

    else if i=11 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport00<5); /* reported 4 out of 7 questionnaire */ 
    	%output();
    end;

    else if i=12 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport04<6); /* reported 5 out of 8 questionnaire */ 
    	%output();
    end;

    else if i=13 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport04<6); /* reported 5 out of 8 questionnaire */ 
    	%output();
    end;

    else if i=14 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport08<7); /* reported 6 out of 9 questionnaire */ 
    	%output();
    end;

    else if i=15 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport08<7); /* reported 6 out of 9 questionnaire */ 
    	%output();
    end;

    else if i=16 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport12<8); /* reported 7 out of 10 questionnaire */ 
    	%output();
    end;

    else if i=17 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport14<9); /* reported 8 out of 11 questionnaire */ 
    	%output();
    end;

    else if i=18 then do;
    	%exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport14<9); /* reported 8 out of 11 questionnaire */ 
    	%output();
    end;

    else if i=19 then do;
        %exclude(irt{i-1} lt dtdth le irt{i}); 
        %exclude(treport14<9); /* reported 8 out of 11 questionnaire */ 
        %output();
    end;


end; * end of time period loop;
%endex(); * end of exclusions;
keep id t84 t86 t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20 cutoff 
		irt84 irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20

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
        beercum winecum liqcum alccum
        endosc mvyn

         
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

        treport

;
run;



/* 2 lag data, start of follow-up in 1988 *****************************************************************************************************/

data nhs_data_2lag; set nhs_data;
if interval<3 then delete;
if .<dtdth le irt88 then delete;

if can86 eq 1 or can88 eq 1   then delete;
if str86 eq 1 or str88 eq 1   then delete;
if ang86 eq 1 or ang88 eq 1   then delete;
if mi86 eq 1 or mi88 eq 1     then delete;
if cabg86 eq 1 or cabg88 eq 1 then delete;


/* small missing, assign median */
 if alco = . then alco=2.13;
 if ccalor = . then ccalor=1703.00;

 if beercum=. then beercum=0;
 if winecum=. then winecum=0.79;
 if liqcum=. then liqcum=0.20;
 if alccum=. then alccum=2.01;


run;

proc means data=nhs_data_2lag nmiss min max median mean; var alco cigg bmi ccalor cahei beercum winecum liqcum alccum; run;


proc freq data=nhs_data_2lag;
	tables 	alldead cvddead respdead neurodead renaldead injurydead suicidedead diabdead otherdead
	        cancerdead gicadead upgitcadead giocadead crccadead
	        obescadead smokecadead 
	        breastcadead cervicadead endocadead ovcadead
	        lungcadead headneckcadead bonecadead connectcadead meldead bladdercadead kidneycadead eyecadead braincadead nervouscadead thyroidcadead bloodcadead
	        ascvddead ihddead/missing;
run;
	       



%macro meanbyperiod (var);
        proc means data=nhs_data_2lag nolabels nmiss min max median mean stddev maxdec=2;
            class interval ;
            var &var.;
        run;
    %mend;
%macro freqbyperiod (var);
        proc freq data=nhs_data_2lag;
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
%freqbyperiod (endosc);

%freqbyperiod (mvyn);


%freqbyperiod (pmh);

%meanbyperiod (totalpav2lag); 
%meanbyperiod (totalpav4lag); 
%meanbyperiod (totalpav8lag); 
%meanbyperiod (totalpav12lag); 


%meanbyperiod (pctmeet2lag); 
%meanbyperiod (pctmeett2lag); 
%meanbyperiod (pctmeettt2lag); 

%freqbyperiod (treport);



proc rank data=nhs_data_2lag group=4 out=nhs_data_2lag;
var   ccalor   cahei  ;
ranks qccalor  qcahei ;
run;

data nhs_data_2lag;
	set nhs_data_2lag;

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
   data ss.nhs_data_2lag_sens; 
        set nhs_data_2lag;
run;



