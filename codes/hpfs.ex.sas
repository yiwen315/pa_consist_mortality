

%include "/udd/hpyzh/pa_consist/hpfs/hpfs.covars.sas";



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
%event(pcaca,    dead_prostateca,    tpcaca);


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
	alcog 	= alcoga{i}; if alcog = . then do;  alcog = 2; end;
	cigg 	= cigga{i};  if cigg = . then do;  cigg = 1; end;
	pkyrg	= pkyrga{i};
	pkyr    = pkyra{i};
	bmi		= bmicuma{i};
	bmig 	= bmiga{i}; if bmig = . then do; bmi = 25.20; bmig = 2; end;
    bmibase = bmiga{1}; if bmibase=. then bmibase=2;

	ccalor  = ccalora{i}; 
	cahei   = caheia{i};  if cahei = . then do; cahei =.; end;

    pscexam = pscexama{i}; if pscexam=. then pscexam=0; 


    beercum = beercuma{i};
    winecum = winecuma{i}; 
    liqcum = liqcuma{i};
    alccum = alccuma{i};

    mvyn = mvyna{i};

    psahiss = psahis{i};
    endosc  =endo{i};  if endosc=. then endosc=0; 

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
		%exclude(dbmy09 le 0 or dbmy09 eq .); 

		%exclude(0 lt dtdth le irt{1});
        %exclude(dtdth eq 9999);    * missing death date ;

		%exclude(can86 eq 1);
		%exclude(str86 eq 1);
		%exclude(ang86 eq 1);
		%exclude(mi86 eq 1);
		%exclude(cabg86 eq 1);

		%exclude(q13pt86 eq 1);  * passthrough 86 PA section;
		%exclude(totalpa86mv eq .);
		%exclude(pctmeet86 eq .);

		%exclude(id gt ., nodelete=T);
		%output();
	end;

	else if i>1 then do; 

        %exclude(irt{i-1} le dtdth lt irt{i});  /* DEATHS */ 
		
	%output();
	end;
end; * end of time period loop;
%endex(); * end of exclusions;

keep id t86 t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20 cutoff 
        irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20

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
        beercum winecum liqcum alccum
        mvyn
        psahiss endosc



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

        treport



;
run;     




/* 2 lag data, start of follow-up in 1990 *****************************************************************************************************/
data hpfs_data_2lag; set hpfs_data; 
if interval<2 then delete; 
if .<dtdth le irt88 then delete;

if can88 eq 1  then delete;
if str88 eq 1  then delete;
if ang88 eq 1  then delete;
if mi88 eq 1   then delete;
if cabg88 eq 1  then delete;


/* small missing, assign median */
 if cahei = . then cahei=54.85;
 if alco = . then alco=6.50;
 if ccalor = . then ccalor=1922.00;


run;

proc means data=hpfs_data_2lag nmiss min max median mean; var alco cigg bmi ccalor cahei beercum winecum liqcum alccum; run;


proc freq data=hpfs_data_2lag;
	tables 	alldead cvddead respdead neurodead renaldead injurydead suicidedead diabdead otherdead
	        cancerdead gicadead upgitcadead giocadead crccadead
	        obescadead smokecadead pcacadead
	        lungcadead headneckcadead bonecadead connectcadead meldead bladdercadead kidneycadead eyecadead braincadead nervouscadead thyroidcadead bloodcadead
	        ascvddead ihddead/missing;
run;



%macro meanbyperiod (var);
        proc means data=hpfs_data_2lag nolabels nmiss min max median mean stddev maxdec=2;
            class interval ;
            var &var.;
        run;
    %mend;
%macro freqbyperiod (var);
        proc freq data=hpfs_data_2lag;
            tables (&var.)*interval / missing norow nopercent;
        run;
    %mend;




 proc means data=hpfs_data_2lag nolabels n nmiss min max mean median maxdec=2;
 where interval=2;
 var age bmi ;
 run;


%meanbyperiod (ccalor);  
%meanbyperiod (cahei); 

%freqbyperiod (mifh);
%freqbyperiod (canfh);

%freqbyperiod (cigg);
%freqbyperiod (pkyrg);

%freqbyperiod (alcog);

%freqbyperiod (pscexam);

%freqbyperiod (mvyn);
%freqbyperiod (psahiss);
%freqbyperiod (endosc);


%meanbyperiod (totalpav2lag); 
%meanbyperiod (totalpav4lag); 
%meanbyperiod (totalpav8lag); 
%meanbyperiod (totalpav12lag); 


%meanbyperiod (pctmeet2lag); 
%meanbyperiod (pctmeett2lag); 
%meanbyperiod (pctmeettt2lag); 

%freqbyperiod (treport);




proc rank data=hpfs_data_2lag group=4 out=hpfs_data_2lag;
var   ccalor   cahei  ;
ranks qccalor  qcahei ;
run;

data hpfs_data_2lag;
	set hpfs_data_2lag;

qccalor=qccalor+1;
qcahei=qcahei+1;

%indic3(vbl=qccalor,     prefix=qccalor,    min=1, max=4, reflev=1, missing=., usemiss=0);
%indic3(vbl=qcahei,      prefix=qcahei,     min=1, max=4, reflev=1, missing=., usemiss=0);

%indic3(vbl=alcog,       prefix=alcog,      min=2, max=3, reflev=1, usemiss=0);
%indic3(vbl=cigg,        prefix=cigg,       min=2, max=4, reflev=1, usemiss=0);
%indic3(vbl=pkyrg,       prefix=pkyrg,      min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=bmig,        prefix=bmig,       min=2, max=5, reflev=1, usemiss=0);
%indic3(vbl=bmibase,     prefix=bmibase,    min=2, max=5, reflev=1, usemiss=0);

run;

*** Output dataset;


libname ss "";
   data ss.hpfs_data_2lag; 
        set hpfs_data_2lag;
run;



