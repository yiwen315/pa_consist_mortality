/*********************************************************************************************************
Project: Association of consistent reaching PA target with mortality

Created: Apr 2025

Purpose: To read in variables

Study Design: Prospective cohort study

Cohort follow-up period: HPFS 1986-2020, with 2-year lag, actual follow-up 1988-2020

Exclusion criteria: baseline cancer or CVD, missing PA, missing death date

Endpoints: all cause and cause-specific mortality

Covariates: age, race, family history of CVD, family history of cancer, alcohol consumption, total energy intake, smoking status, AHEI, BMI, menopausal status and postmenopausal hormone use (women)

************************************************************************************************/

filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos';
filename ehmac '/udd/stleh/ehmac';
libname formats '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing hpstools ehmac); *path to macro;

options fmtsearch=(formats);
options nocenter ls=100 ps=68 replace;




/******** READ IN PA *********/

%include '/udd/hpyzh/pa_consist/hpfs/hpfs_pa.sas';
proc sort nodupkey data=hpfs_pa_met; by id; run;




/* Read in SES */
%include '/udd/hpyzh/proj_data/hpfs/SES_hpfs.sas';
proc sort nodupkey data=nses8818;by id;run;

/* READ IN DIET AND NUTRIENT VARAIBLES */

%h86_nts(keep = alco86n calor86n); run;
%h90_nts(keep = alco90n calor90n); run;
%h94_nts(keep = alco94n calor94n); run;
%h98_nts(keep = alco98n calor98n); run;
%h02_nts(keep = alco02n calor02n); run;
%h06_nts(keep = alco06n calor06n); run;
%h10_nts(keep = alco10n calor10n); run;
%h14_nts(keep = alco14n calor14n); run;
%h18_nts(keep = alco18n calor18n); run;

/* read in alcohol type */
%include '/udd/hpyzh/pa_consist/hpfs/hpfs.alcohol.sas';
proc sort nodupkey data=hpfs_alcohol;by id;run;



libname AHEIdat '/proj/hpalcs/hpalc0b/DIETSCORES/HPFS/';
data ahei86; set AHEIdat.hnahei86l; keep id nAHEI86a; proc sort; by id; run;
data ahei90; set AHEIdat.hnahei90l; keep id nAHEI90a; proc sort; by id; run;
data ahei94; set AHEIdat.hnahei94l; keep id nAHEI94a; proc sort; by id; run;
data ahei98; set AHEIdat.hnahei98l; keep id nAHEI98a; proc sort; by id; run;
data ahei02; set AHEIdat.hnahei02l; keep id nAHEI02a; proc sort; by id; run;
data ahei06; set AHEIdat.hnahei06l; keep id nAHEI06a; proc sort; by id; run;


libname AHEIdatn '/proj/hpbios/hpbio00/hpfs.dietqual/';
data ahei10; set AHEIdatn.ahei10; keep id nAHEI10a; proc sort; by id; run;


/* MV use */
%include '/udd/hpyzh/pa_consist/hpfs/hpfs.mv.sas';
proc sort nodupkey data=hpfs_mv;by id;run;

/* endoscopy */
%include '/udd/hpyzh/pa_consist/hpfs/hpfs_endo.sas';
proc sort nodupkey data=sigmoid;by id;run;



/***************************** READ IN DEATH AND DISEASE FILES ************************/

/* Death Files */
%hp_dead();

data hp_dead;
    set hp_dead;

if 0<=yydth<50 then yydth=yydth+100;

if yydth>0 then do;
  if mmdth<1 or mmdth>12 then mmdth=6;
  dtdth=yydth*12+mmdth;
  dead_all=1;
end;
else dtdth=9999;  /* missing date of death */

  if substr(icda,1,1) = 'E' then dead_injury = 1;
  if substr(icda,1,1) not eq 'E' then newicda=input(substr(icda,1,3),3.);

* Diabetes *;
  if newicda=250 then dead_diab=1;


* CVD: acute rheumatic fever
       chronic rheumatic heart disease
       hypertensive disease
       ischaemic heart disease
       other heart disease
       cerebrovascular diease/stroke
       diseases of arteries, arterioles and capillaries
       diseases of veins and lymphatics
       sudden death ;
  if (390<=newicda<=459 or newicda=795) then dead_cvd=1;
  if 390<=newicda<=459 then dead_cvdnosd=1;
  if 390<=newicda<=392 then dead_acurheu=1;
  if 393<=newicda<=398 then dead_chrrheu=1;
  if 400<=newicda<=404 then dead_hyper=1;
  if 410<=newicda<=414 then dead_ihd=1; /* ischaemic heart disease */
  if 420<=newicda<=429 then dead_oheart=1;
  if 430<=newicda<=438 then dead_stroke=1;
  if 440<=newicda<=448 then dead_artery=1;
  if 450<=newicda<=458 then dead_vein=1;
  if newicda=795 then dead_sudd=1;


* ASCVD: 
(410-414) Ischaemic heart disease
410 Acute myocardial infarction
411 Other acute and subacute forms of ischaemic heart disease
412 Chronic ischaemic heart disease
413 Angina pectoris
414 Asymptomatic ischaemic heart disease

432 Occlusion of precerebral arteries
433 Cerebral thrombosis
434 Cerebral embolism
435 Transient cerebral ischaemia

437 Generalised ischaemic cerebrovascular disease

440 Arteriosclerosis
441 Aortic aneurysm (non-syphilitic)
442 Other aneurysm
443 Other peripheral vascular disease
444 Arterial embolism and thrombosis
;

  if newicda in (410,411,412,413,414, 432,433,434,435, 437, 440,441,442,443,444) then dead_ascvd=1;



* respiratory *;
  if 460<=newicda<=519 then dead_resp=1;
  if 490<=newicda<=496 then dead_copd=1;

* Other diseases of central nervous system
        Multiple sclerosis
        Other demyelinating diseases of central nervous system
        Paralysis agitans
        Cerebral spastic infantile paralysis
        Other cerebral paralysis
        Epilepsy
        Migraine
        Other diseases of brain
        Motor neurone disease
        Other diseases of spinal cord

Definitions varied between cohorts
      ICD-8  > 290, 340, 342, 348
             > 340-349
             > 340, 342, 348
;
if newicda in (290,340,342,348) then dead_neuro=1;

* 580 - 584 ephritis and nephrosis
        580 Acute nephritis
        581 Nephrotic syndrome
        582 Chronic nephritis
        583 Nephritis, unqualified
        584 Renal sclerosis, unqualified
  590 - 599 Other diseases of urinary system
        590 Infections of kidney
        591 Hydronephrosis
        592 Calculus of kidney and ureter
        593 Other diseases of kidney and ureter
        594 Calculus of other parts of urinary system
        595 Cystitis
        596 Other diseases of bladder
        597 Urethritis (non-venereal)
        598 Stricture of urethra
        599 Other diseases of urinary tract
;
  if 580<=newicda<=599 then dead_renal=1;

* accidents and injury *;
  if 800<=newicda<=949 or 960<=newicda<=999 then dead_injury=1;

* suicide *;
  if 950<=newicda<=959 then dead_suicide=1;

* cancer *;
  if 140<=newicda<=209 then dead_cancer=1;
      if 140<=newicda<=149 then dead_oralca=1;
      if newicda=150 then dead_esophca=1;
      if newicda=151 then dead_stomachca=1;
      if newicda=152 then dead_smallintestca=1;
      if newicda in (153, 154) then dead_colorectca=1;
      if newicda=155 then dead_liverca=1;
      if newicda=156 then dead_gallbladderca=1;
      if newicda=157 then dead_pancrca=1;
      if newicda=158 then dead_peritonealca=1;

      if newicda=162 then dead_lungca=1;
      if newicda in (160,161,163) then dead_otherrespca=1;
      if (140<=newicda<=149 or 160<=newicda<=161) then dead_headneckca=1;

      if newicda=170 then dead_boneca=1;
      if newicda=171 then dead_connectca=1;
      if newicda=172 then dead_mel=1;
      if 172<=newicda<=173 then dead_skinca=1; 
      if newicda=174 then dead_brca=1;

      if newicda=180 then dead_cervicalca=1;
      if newicda=182 then dead_endoca=1;
      if newicda=183 then dead_ovca=1;
      if newicda=185 then dead_prostateca=1;
      if newicda=188 then dead_bladderca=1;
      if newicda=189 then dead_kidneyca=1;

      if newicda=190 then dead_eyeca=1;
      if newicda=191 then dead_brainca=1; 
      if newicda=192 then dead_nervousca=1;
      if newicda=193 then dead_thyroidca=1;

      if 200<=newicda<=209 then dead_bloodca=1;
      if newicda=200 then dead_lymphosarcoma=1;
      if newicda=201 then dead_hodg=1;
      if newicda=202 then dead_nonhodg=1;
      if newicda=203 then dead_mmyeloma=1;
      if newicda=204 then dead_lymleuk=1;
      if newicda=205 then dead_myeleuk=1;
      if 201<=newicda<=207 then dead_lymphaem=1;
        
* other death *;
  *if dtdth>0 and sum(of dead_diab dead_cvd dead_cancer dead_resp dead_renal dead_neuro dead_injury dead_suicide)<=0 then dead_other=1;
  if dtdth>0 and sum(of dead_cvd dead_cancer dead_resp dead_neuro)<=0 then dead_other=1;


  if dead_all eq 1 and dead_injury ne 1 and dead_suicide ne 1 then dead_ntraumatic=1;
  if dead_injury eq 1 or dead_suicide eq 1 then dead_traumatic=1;

  if sum(of dead_oralca dead_esophca dead_stomachca dead_smallintestca dead_colorectca dead_liverca 
            dead_gallbladderca dead_pancrca)>=1 then dead_gica=1;
  if sum(of dead_oralca dead_esophca dead_stomachca dead_smallintestca dead_colorectca)>=1 then dead_gitca=1;
  if sum(of dead_oralca dead_esophca dead_stomachca dead_smallintestca)>=1 then dead_upgitca=1;
  if sum(of dead_liverca dead_gallbladderca dead_pancrca)>=1 then dead_gioca=1;

if sum(of dead_esophca dead_stomachca dead_colorectca dead_liverca dead_gallbladderca dead_pancrca dead_brca 
          dead_endoca dead_ovca dead_kidneyca dead_thyroidca dead_mmyeloma)>=1 then dead_obesca=1;

if sum(of dead_oralca dead_esophca dead_stomachca dead_colorectca dead_liverca dead_pancrca dead_otherrespca
          dead_lungca dead_cervicalca dead_ovca dead_bladderca dead_kidneyca dead_myeleuk)>=1 then dead_smokeca=1;


if dtdth>0 and dead_cvd ne 1 then dead_noncvd=1;  /* non-CVD death */



run;








/********************************* READ IN OTHER COVARIATES***************************/
/* physical examine for screening purpose */
%include '/udd/hpyzh/pa_consist/hpfs/hpfs.exam.sas';
proc sort nodupkey data=hpfs_psexam; by id; run;



%hp86(keep=hbp86 db86  chol86 mi86 cabg86 ang86 str86  pe86 orhy86 
     mel86 pros86 lymp86 ocan86 colc86  can86
     q14pt86 seuro86 scand86 ocauc86 afric86 asian86 oanc86 race white wtch86
     q13pt86 /*passthrough PA section */); 

if mel86=1 or pros86=1 or lymp86=1 or ocan86=1 or colc86=1 then can86=1; else can86=0;

/* q14pt86 = Major ancestrt 1= passthru */
if afric86=1 then race=4;
else if asian86=1 then race=3;
else if oanc86=1 then race=2;
else race=1;

if race=1 then white=1;
else white=0;

run;

%hp88(keep=hbp88 db88 chol88 mi88 cabg88 ang88 str88  pe88 orhy88 
       colc88 mel88 pros88 lymp88 ocan88 can88); 
if sum(colc88,mel88,pros88,lymp88,ocan88)>0 then can88=1; else can88=0;
run;

%hp90(keep=hbp90 db90 chol90 mi90 cabg90 ang90 str90 pe90 orhy90 
    colc90 mel90 pros90 lymp90 ocan90 can90 
    tia90 cart90); 
if sum(colc90,mel90,pros90,lymp90,ocan90)>=1 then can90=1; else can90=0;
run;


%hp92 (keep=  hbp92 db92 chol92 mi92 ang92 cabg92 str92 pe92 orhy92 tia92 cart92
    mdb92 fdb92 sdb92 dbfh92
    colc92 pros92 mel92 lymp92 ocan92 can92 pulse92);
  if colc92=1 or  pros92=1 or mel92=1 or lymp92=1 or ocan92=1 then can92=1;   else can92=0;
    if fdb92=1 or mdb92=1 or sdb92=1 then dbfh92=1; else dbfh92=0;
run;

%hp94 (keep=  hbp94 db94 chol94 mi94 ang94 cabg94 str94 pe94 orhy94 tia94 cart94
    colc94 mel94 pros94 lymp94 ocan94 can94
    psa94 psad94 psael94);
  if colc94=1 or mel94=1 or pros94=1 or lymp94=1 or ocan94=1 then can94=1; else can94=0;
run;

%hp96 (keep=  hbp96 db96 chol96 mi96 ang96 cabg96 str96 pe96 orhy96 tia96 cart96
    colc96 mel96 pros96 lymp96 ocan96 can96
    psa96 psael96);
    if colc96=1 or mel96=1 or pros96=1 or lymp96=1 or ocan96=1 then can96=1; else can96=0;
run;

%hp98 (keep=  hbp98 db98 chol98 mi98 ang98 cabg98 str98 pe98 orhy98 tia98 cart98
    colc98 mel98 pros98 lymp98 ocan98 can98
    psa98 psael98);
    if colc98=1 or mel98=1 or pros98=1 or lymp98=1 or ocan98=1 then can98=1; else can98=0;
run;
   
%hp00 (keep=  hbp00 db00 chol00 mi00 ang00 pe00 orhy00 cabg00 strk00 str00 slp00 sleep00 tia00 cart00
    colc00 mel00 pros00 lymp00 ocan00 can00
    psa00 psael00 );
  if colc00=1 or mel00=1 or pros00=1 or lymp00=1 or ocan00=1 then can00=1; else can00=0;
    str00=strk00; /* Made new variable str00 to be consistent with previous years */
if slp00 in ('1','2','3','4','5','6','7') then sleep00=slp00*1; 
run;  

%hp02 (keep = hbp02 db02 chol02 cabg02 mi02 ang02 pe02 orhy02 strk02 str02 tia02 cart02
              colc02 pros02 mel02 lymp02 ocan02 can02
              psano02 psasy02 psasc02 psapt02 psael02); 
  if colc02=1 or pros02=1 or mel02=1 or lymp02=1 or ocan02=1 then can02=1; else can02=0;
      str02=strk02;
run;

%hp04(keep= hbp04 db04 chol04 mi04 ang04 cabg04 strk04 str04 tia04 cart04
    colc04 mel04 pros04 lymp04 ocan04 can04
    psano04 psasy04 psasc04 psapt04 psael04);
  if colc04=1 or mel04=1 or pros04=1 or lymp04=1 or ocan04=1 then can04=1; else can04=0;
      str04=strk04;
run; 

%hp06 (keep = hbp06 db06 chol06 mi06 ang06 cabg06 strk06 str06 tia06 cart06
    colc06 mel06 pros06 lymp06 ocan06 can06
    psano06 psasy06 psasc06 psapt06 psael06); 
    if colc06=1 or mel06=1 or pros06=1 or lymp06=1 or ocan06=1 then can06=1; else can06=0;
    str06=strk06;
run;

%hp08 (keep = hbp08 db08 chol08 mi08 ang08 cabg08 strk08 str08 sleep08 slp08 tia08 cart08
    colc08 mel08 pros08 lymp08 ocan08 can08
    psano08 psasy08 psasc08 psapt08 psael08 psalv08); 
    if colc08=1 or mel08=1 or pros08=1 or lymp08=1 or ocan08=1 then can08=1; else can08=0;
    str08=strk08;
if sleep08 in ('1','2','3','4','5','6','7') then slp08=sleep08*1;
run;

%hp10 (keep = hbp10 db10 chol10 mi10 ang10 cabg10 tia10 cart10
    colc10 mel10 pros10 lymp10 ocan10 can10 str10 strk10
    psano10 psasy10 psasc10 psapt10 psael10 psalv10 ); 
    if colc10=1 or mel10=1 or pros10=1 or lymp10=1 or ocan10=1 then can10=1; else can10=0;
    str10=strk10;
run;

%hp12 (keep = hbp12 db12 chol12 mi12 ang12 cabg12 tia12 cart12
     colc12 mel12 pros12 lymp12 ocan12 can12 str12 strk12
     psano12 psasy12 psasc12 psapt12 psael12 psalv12);
     if colc12=1 or mel12=1 or pros12=1 or lymp12=1 or ocan12=1 then can12=1; else can12=0;
     str12=strk12;    
run;

%hp14 (keep = hbp14 db14 chol14 mi14 ang14 cabg14 tia14 cart14
     colc14 mel14 pros14 lymp14 ocan14 can14 str14 strk14
     psano14 psasy14 psasc14 psapt14 psalv14 );
     if colc14=1 or mel14=1 or pros14=1 or lymp14=1 or ocan14=1 then can14=1; else can14=0;
     str14=strk14;    

%hp16 (keep = hbp16 db16 chol16 mi16 ang16 cabg16 tia16 cart16
     colc16 mel16 pros16 lymp16 ocan16 can16 str16 stk16
     psano16 psasy16 psasc16 psapt16 psalv16);
     if colc16=1 or mel16=1 or pros16=1 or lymp16=1 or ocan16=1 then can16=1; else can16=0;
     str16=stk16;  

%hp18 (keep = hbp18 db18 chol18 mi18 ang18 cabg18 tia18 cart18
     colc18 mel18 pros18 lymp18 ocan18 can18 str18 strk18
     psano18 psasy18 psasc18 psapt18 psalv18);
     if colc18=1 or mel18=1 or pros18=1 or lymp18=1 or ocan18=1 then can18=1; else can18=0;
     str18=strk18;  

%hp20 (keep = hbp20 db20 chol20 mi20 ang20 cabg20 tia20 cart20
     colc20 mel20 pros20 lymp20 ocan20 can20 str20 strk20
     psano20 psasy20 psasc20 psapt20 psalv20);
     if colc20=1 or mel20=1 or pros20=1 or lymp20=1 or ocan20=1 then can20=1; else can20=0;
     str20=strk20; 

run;


run;




%hp_der(keep= profssn age86 dbmy09 height     
  rtmnyr86 rtmnyr88 rtmnyr90 rtmnyr92 rtmnyr94 rtmnyr96 rtmnyr98 rtmnyr00 rtmnyr02 rtmnyr04 rtmnyr06
  smoke86 smoke88 smoke90 smoke92 smoke94 smoke96 smoke98 smoke00 smoke02 smoke04 smoke06 stpyr86
  cgnm86 cgnm88 cgnm90 cgnm92 cgnm94 cgnm96 cgnm98 cgnm00 cgnm02 cgnm04 cgnm06
  pckyr86 pckyr88 pckyr90 pckyr92 pckyr94 pckyr96 pckyr98 pckyr00 pckyr02 pckyr04 pckyr06
  wt86 wt88 wt90 wt92 wt94 wt96 wt98 wt00 wt02 wt04 wt06 
  bmi86 bmi88 bmi90 bmi92 bmi94 bmi96 bmi98 bmi00 bmi02 bmi04 bmi06 bmi2186
  fmi86 afmi86 mmi86 ammi86 mifh
  fdb3087 mdb3087 bdb3087 sdb3087 dbfh87 fdb90 mdb90 sdb90
  fclc86 mclc86 hxclc90 fpro90 fmel90 mmel90 sclc90 spro90 smel90 canfh
    );

/**family history of MI**/
if fmi86=1 or  mmi86=1 then mifh=1;
else mifh=0;

/** family history of db **/
dbfh87=0;    * onset after age 30 presumed to be NIDDM;                  
if fdb3087=1 or mdb3087=1 or sdb3087=1 or bdb3087=1 or fdb90=1 or mdb90=1 or sdb90=1 then dbfh87=1;      

/** family history of cancer **/
if fclc86=1 or mclc86=1 or hxclc90=1 or fpro90=1 or fmel90=1 or mmel90=1 or sclc90=1 or spro90=1 or smel90=1 then canfh=1;
else canfh=0;

run;
     
%hp_der_2(keep = 
waist08 waist08r hip08 whrat08 
rtmnyr08 smoke08 cgnm08 wt08 bmi08 pckyr08
rtmnyr10 smoke10 cgnm10 wt10 bmi10 pckyr10
rtmnyr12 smoke12 cgnm12 wt12 bmi12 pckyr12
rtmnyr14 smoke14 cgnm14 wt14 bmi14 pckyr14
rtmnyr16 smoke16 cgnm16 wt16 bmi16 pckyr16
rtmnyr18 smoke18 cgnm18 wt18 bmi18 pckyr18
rtmnyr20 smoke20 cgnm20 wt20 bmi20 pckyr20
); 
run;




/********************************* Merge datasets ***************************/

data hpfs_data;
 merge  hpfs_pa_met  hp_dead  
  hp_der (in=mstr) hp_der_2  hpfs_psexam hpfs_alcohol hpfs_mv sigmoid
  h86_nts h90_nts h94_nts h98_nts h02_nts h06_nts h10_nts h14_nts h18_nts
  hp86 hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hp18 hp20
  ahei86 ahei90 ahei94 ahei98 ahei02 ahei06 ahei10 
       end=_end_;
   by id;
   exrec=1; if first.id and mstr then exrec=0; 
run;

proc datasets nolist;
 delete hpfs_pa_met  hp_dead diabetes
  hp_der hp_der_2  hpfs_psexam
  h86_nts h90_nts h94_nts h98_nts h02_nts h06_nts h10_nts h14_nts
  hp86 hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hp18 hp20
  ahei86 ahei90 ahei94 ahei98 ahei02 ahei06 ahei10;
run;



data hpfs_data;
  set hpfs_data end=_end_;

* cohort indicator ;  
  cohort=1; 
  *cutoff=(2020-1900)*12+1; * set cutoff to 2020.1 <- 1441;
  cutoff=(2022-1900)*12+12; * set cutoff to 2022.12 <- 1476;


* Questionnaire return ;
array tvar {*} t86 t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20; /* Indicator variables for time period - initialize to 0 */
array origirta{*} rtmnyr86 rtmnyr88 rtmnyr90 rtmnyr92 rtmnyr94 rtmnyr96 rtmnyr98 rtmnyr00 rtmnyr02 rtmnyr04 rtmnyr06 rtmnyr08 rtmnyr10 rtmnyr12 rtmnyr14 rtmnyr16 rtmnyr18 rtmnyr20 cutoff;
array irt {*} irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20 cutoff;
array period {18}  period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11 period12 period13 period14 period15 period16 period17 period18;


* create lastq before correcting irt 
  lost to follow-up     --> lastq = last irt
  not lost to follow-up --> lastq = . *;

  do i=1 to dim(origirta)-1;  
    if origirta{i} > 0 then lastq = origirta{i};
  end;
  if lastq = origirta{dim(origirta)-1} then lastq=.;

  do i=1 to dim(irt)-1;  * 1009 = 1984 Jan    1033 = 1986 Jan *;
    if origirta{i}<(1009+24*i) | origirta{i}>=(1033+24*i) then origirta{i}=1009+24*i;
    irt{i}=origirta{i};
  end;


* Birthday ;
  if dbmy09>0 then birthday=dbmy09;


* Age ;
array agemoa {*} agemo86 agemo88 agemo90 agemo92 agemo94 agemo96 agemo98 agemo00 agemo02 agemo04 agemo06 agemo08 agemo10 agemo12 agemo14 agemo16 agemo18 agemo20; 
array agea {*}   age86 age88 age90 age92 age94 age96 age98 age00 age02 age04 age06 age08 age10 age12 age14 age16 age18 age20; 
array agega {*}  ageg86 ageg88 ageg90 ageg92 ageg94 ageg96 ageg98 ageg00 ageg02 ageg04 ageg06 ageg08 ageg10 ageg12 ageg14 ageg16 ageg18 ageg20; 

  do i=1 to dim(agemoa);
    if birthday ne . then agemoa{i} = irt{i} - birthday;
        agea{i} = floor(( irt{i} - birthday )/12);
    if 0<agea{i}<50 then agega{i}=1;
    else if 50<=agea{i}<55 then agega{i}=2;
    else if 55<=agea{i}<60 then agega{i}=3;
    else if 60<=agea{i}<65 then agega{i}=4;
    else if 65<=agea{i}<70 then agega{i}=5;
    else if 70<=agea{i}<75 then agega{i}=6;
    else if agea{i}>=75 then agega{i}=7;
  end;



* BMI ;
array bmia{*}    bmi86 bmi88 bmi90 bmi92 bmi94 bmi96 bmi98 bmi00 bmi02 bmi04 bmi06 bmi08 bmi10 bmi12 bmi14 bmi16 bmi18 bmi20;
array bmicuma{*} bmicum86 bmicum88 bmicum90 bmicum92 bmicum94 bmicum96 bmicum98 bmicum00 bmicum02 bmicum04 bmicum06 bmicum08 bmicum10 bmicum12 bmicum14 bmicum16 bmicum18 bmicum20;
array bmiga{*}   bmig86 bmig88 bmig90 bmig92 bmig94 bmig96 bmig98 bmig00 bmig02 bmig04 bmig06 bmig08 bmig10 bmig12 bmig14 bmig16 bmig18 bmig20;

    do i=1 to dim(bmia);
        if bmia{i}<10 then bmia{i}=.;
    end;

  bmicum86=bmi86;
  bmicum88=mean(bmi86, bmi88);
  bmicum90=mean(bmi86, bmi88, bmi90);
  bmicum92=mean(bmi86, bmi88, bmi90, bmi92);
  bmicum94=mean(bmi86, bmi88, bmi90, bmi92, bmi94);
  bmicum96=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96);
  bmicum98=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98);
  bmicum00=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00);
  bmicum02=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02);
  bmicum04=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04);
  bmicum06=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06);
  bmicum08=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08);
  bmicum10=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10);
  bmicum12=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12);
  bmicum14=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14);
  bmicum16=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14, bmi16);
  bmicum18=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14, bmi16, bmi18);
  bmicum20=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14, bmi16, bmi18, bmi20);

  do i=1 to dim(bmia);
    if i>1 then do;
      if bmia{i}=. then bmia{i}=bmia{i-1};
      if bmicuma{i}=. and bmicuma{i-1} ne . then bmicuma{i}=bmicuma{i-1};
    end;
    if 0<bmicuma{i}<24 then bmiga{i}=1;
    else if 24<=bmicuma{i}<26 then bmiga{i}=2;
    else if 26<=bmicuma{i}<27.5 then bmiga{i}=3;
    else if 27.5<=bmicuma{i}<30 then bmiga{i}=4;
    else if bmicuma{i}>=30 then bmiga{i}=5;
  end;
  



* smoking 

ciggxx: 
   never, 
   past smoker >=10 years since quit smoking, 
   past smoker <10 years since quit smoking,  
   current 

ciggxx: pack-year (continuous)
pkyrgxx:  pack-years of smoking (0, 1-4, 5-14, >=15 pack-years)
;
array smk3ga {*} smoke86 smoke88 smoke90 smoke92 smoke94 smoke96 smoke98 smoke00 smoke02 smoke04 smoke06 smoke08 smoke10 smoke12 smoke14 smoke16 smoke18 smoke20;
array cigda {*} cgnm86 cgnm88 cgnm90 cgnm92 cgnm94 cgnm96 cgnm98 cgnm00 cgnm02 cgnm04 cgnm06 cgnm08 cgnm10 cgnm12 cgnm14 cgnm16 cgnm18 cgnm20;
array msquia {*} msqui86 msqui88 msqui90 msqui92 msqui94 msqui96 msqui98 msqui00 msqui02 msqui04 msqui06 msqui08 msqui10 msqui12 msqui14 msqui16 msqui18 msqui20; 
array pkyra {*} pckyr86 pckyr88 pckyr90 pckyr92 pckyr94 pckyr96 pckyr98 pckyr00 pckyr02 pckyr04 pckyr06 pckyr08 pckyr10 pckyr12 pckyr14 pckyr16 pckyr18 pckyr20;
array cigga {*} cigg86 cigg88 cigg90 cigg92 cigg94 cigg96 cigg98 cigg00 cigg02 cigg04 cigg06 cigg08 cigg10 cigg12 cigg14 cigg16 cigg18 cigg20;
array pkyrga {*} pkyrg86 pkyrg88 pkyrg90 pkyrg92 pkyrg94 pkyrg96 pkyrg98 pkyrg00 pkyrg02 pkyrg04 pkyrg06 pkyrg08 pkyrg10 pkyrg12 pkyrg14 pkyrg16 pkyrg18 pkyrg20;


  if stpyr86=1 then msqui86=6;
  else if stpyr86=2 then msqui86=18;
  else if stpyr86=3 then msqui86=48;
  else if stpyr86=4 then msqui86=90; 
  else if stpyr86=5 then msqui86=120;

  do i=1 to dim(smk3ga);
    if smk3ga{i} in (.,3,5) then smk3ga{i}=.;
      else if smk3ga{i}=4 then smk3ga{i}=3; *current;
    if smk3ga{i}=. and cigda{i} in (1,2,3,4,5,6) then smk3ga{i}=3;
    if smk3ga{i}=3 then msquia{i}=0;
    if cigda{i} in (.,0,7) then cigda{i}=.;
    if pkyra{i}=999 then pkyra{i}=.;
    if i>1 then do;
      if smk3ga{i}=. & smk3ga{i-1}^=. then smk3ga{i}=smk3ga{i-1};
      if smk3ga{i}=3 & cigda{i}=. & cigda{i-1}^=. then cigda{i}=cigda{i-1};
      if smk3ga{i}=2 then msquia{i}=sum(msquia{i-1},irt{i}-irt{i-1});
      if pkyra{i}=. & pkyra{i-1}^=. then pkyra{i}=pkyra{i-1};
    end;

    if smk3ga{i}=1 /*| smk3ga{i}=.*/ then cigga{i}=1; * never *;
    else if smk3ga{i}=2 & (120 le msquia{i}) then cigga{i}=2; * past >=10y *;
    else if smk3ga{i}=2 & (msquia{i} lt 120) then cigga{i}=3; * past <10y *;
    else if smk3ga{i}=3 then cigga{i}=4; * current *;
    /*else if smk3ga{i}=3 & cigda{i}<=2 then cigga{i}=4; * current 1-14/d*;
    else if smk3ga{i}=3 & cigda{i}=3 then cigga{i}=5; * current 15-24/d*;
    else if smk3ga{i}=3 & 4<=cigda{i}<=6 then cigga{i}=6; * current 25- /d*;*/

    if pkyra{i}<=0 then pkyrga{i}=1;
    else if pkyra{i}<5 then pkyrga{i}=2;
    else if pkyra{i}<15 then pkyrga{i}=3;
    else if pkyra{i}<25 then pkyrga{i}=4;
    else if pkyra{i}>=25 then pkyrga{i}=5;
  end;



* alcohol consumption ;
array alcocuma{*} alcocum86 alcocum86 alcocum90 alcocum90 alcocum94 alcocum94 alcocum98 alcocum98 alcocum02 alcocum02 alcocum06 alcocum06 alcocum10 alcocum10 alcocum14 alcocum14 alcocum18 alcocum18;
array alcoga{*}   alcog86 alcog86 alcog90 alcog90 alcog94 alcog94 alcog98 alcog98 alcog02 alcog02 alcog06 alcog06 alcog10 alcog10 alcog14 alcog14 alcog18 alcog18;

  alcocum86=alco86n;
  alcocum90=mean(alco86n,alco90n);
  alcocum94=mean(alco86n,alco90n,alco94n);
  alcocum98=mean(alco86n,alco90n,alco94n,alco98n);
  alcocum02=mean(alco86n,alco90n,alco94n,alco98n,alco02n);
  alcocum06=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n);
  alcocum10=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n,alco10n);
  alcocum14=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n,alco10n,alco14n);
  alcocum18=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n,alco10n,alco14n, alco18n);

  do i=1 to dim(alcoga);
    if i>1 then do;if alcocuma{i}=. & alcocuma{i-1}^=. then alcocuma{i}=alcocuma{i-1};end;
    if .<alcocuma{i}<5 then alcoga{i}=1;
    else if 5<=alcocuma{i}<15 then alcoga{i}=2;
    else if alcocuma{i}>=15 then alcoga{i}=3;
  end;


* beer;
  beercum86=beer86;
  beercum90=mean(beer86, beer90);
  beercum94=mean(beer86, beer90, beer94);
  beercum98=mean(beer86, beer90, beer94, beer98);
  beercum02=mean(beer86, beer90, beer94, beer98, beer02);
  beercum06=mean(beer86, beer90, beer94, beer98, beer02, beer06);
  beercum10=mean(beer86, beer90, beer94, beer98, beer02, beer06, beer10);
  beercum14=mean(beer86, beer90, beer94, beer98, beer02, beer06, beer10, beer14);
  beercum18=mean(beer86, beer90, beer94, beer98, beer02, beer06, beer10, beer14, beer18);

* wine;
  winecum86=wine86;
  winecum90=mean(wine86, wine90);
  winecum94=mean(wine86, wine90, wine94);
  winecum98=mean(wine86, wine90, wine94, wine98);
  winecum02=mean(wine86, wine90, wine94, wine98, wine02);
  winecum06=mean(wine86, wine90, wine94, wine98, wine02, wine06);
  winecum10=mean(wine86, wine90, wine94, wine98, wine02, wine06, wine10);
  winecum14=mean(wine86, wine90, wine94, wine98, wine02, wine06, wine10, wine14);
  winecum18=mean(wine86, wine90, wine94, wine98, wine02, wine06, wine10, wine14, wine18);

* liquor ;
  liqcum86=liq86;
  liqcum90=mean(liq86, liq90);
  liqcum94=mean(liq86, liq90, liq94);
  liqcum98=mean(liq86, liq90, liq94, liq98);
  liqcum02=mean(liq86, liq90, liq94, liq98, liq02);
  liqcum06=mean(liq86, liq90, liq94, liq98, liq02, liq06);
  liqcum10=mean(liq86, liq90, liq94, liq98, liq02, liq06, liq10);
  liqcum14=mean(liq86, liq90, liq94, liq98, liq02, liq06, liq10, liq14);
  liqcum18=mean(liq86, liq90, liq94, liq98, liq02, liq06, liq10, liq14, liq18);

* total alcohol;
  alccum86=alc86;
  alccum90=mean(alc86, alc90);
  alccum94=mean(alc86, alc90, alc94);
  alccum98=mean(alc86, alc90, alc94, alc98);
  alccum02=mean(alc86, alc90, alc94, alc98, alc02);
  alccum06=mean(alc86, alc90, alc94, alc98, alc02, alc06);
  alccum10=mean(alc86, alc90, alc94, alc98, alc02, alc06, alc10);
  alccum14=mean(alc86, alc90, alc94, alc98, alc02, alc06, alc10, alc14);
  alccum18=mean(alc86, alc90, alc94, alc98, alc02, alc06, alc10, alc14, alc18);

array beercuma {*} beercum86 beercum86 beercum90 beercum90 beercum94 beercum94 beercum98 beercum98 beercum02 beercum02 beercum06 beercum06 beercum10 beercum10 beercum14 beercum14 beercum18 beercum18;
array winecuma {*} winecum86 winecum86 winecum90 winecum90 winecum94 winecum94 winecum98 winecum98 winecum02 winecum02 winecum06 winecum06 winecum10 winecum10 winecum14 winecum14 winecum18 winecum18;
array liqcuma  {*} liqcum86 liqcum86 liqcum90 liqcum90 liqcum94 liqcum94 liqcum98 liqcum98 liqcum02 liqcum02 liqcum06 liqcum06 liqcum10 liqcum10 liqcum14 liqcum14 liqcum18 liqcum18;
array alccuma  {*} alccum86 alccum86 alccum90 alccum90 alccum94 alccum94 alccum98 alccum98 alccum02 alccum02 alccum06 alccum06 alccum10 alccum10 alccum14 alccum14 alccum18 alccum18;



* Cumulative average for AHEI, calories ; 
    array nut2{9, 2} 
       calor86n  nAHEI86a   
       calor90n  nAHEI90a   
       calor94n  nAHEI94a   
       calor98n  nAHEI98a 
       calor02n  nAHEI02a 
       calor06n  nAHEI06a 
       calor10n  nAHEI10a 
       calor14n  nAHEI10a 
       calor18n  nAHEI10a

    ;

    array nutv2{9, 2} 
       ccalor86n  cAHEI86 
       ccalor90n  cAHEI90 
       ccalor94n  cAHEI94
       ccalor98n  cAHEI98 
       ccalor02n  cAHEI02 
       ccalor06n  cAHEI06 
       ccalor10n  cAHEI10 
       ccalor14n  cAHEI10 
       ccalor18n  cAHEI10
    ;

    do j=1 to 2;
        do i=2 to 9;
            if nut2{i,j}=. and nut2{i-1,j}^=. then nut2{i,j}=nut2{i-1,j};
        end;
    end;

    do j=1 to 2;
        nutv2{1,j}=nut2{1,j};
        do i=2 to 9; 
            sumvar=0;
            n=0;
            do k=1 to i; 
                if (nut2{k,j} ne .) then do;
                    n=n+1; sumvar=sumvar+nut2{k,j};
                end;
            end;
            if n=0 then nutv2{i,j}=nut2{1,j};
            else nutv2{i,j}=sumvar/n;
        end;
    end; 

array ccalora {*} ccalor86n ccalor86n ccalor90n ccalor90n ccalor94n ccalor94n ccalor98n ccalor98n ccalor02n ccalor02n ccalor06n ccalor06n ccalor10n ccalor10n ccalor14n ccalor14n ccalor18n ccalor18n;
array caheia  {*} cAHEI86 cAHEI86 cAHEI90 cAHEI90 cAHEI94 cAHEI94 cAHEI98 cAHEI98 cAHEI02 cAHEI02 cAHEI06 cAHEI06 cAHEI10 cAHEI10 cAHEI10 cAHEI10 cAHEI10 cAHEI10; 


* Intermediate endpoints ;
array diaba {*} db86 db88 db90 db92 db94 db96 db98 db00 db02 db04 db06 db08 db10 db12 db14 db16 db18 db20; 
array mia {*}   mi86 mi88 mi90 mi92 mi94 mi96 mi98 mi00 mi02 mi04 mi06 mi08 mi10 mi12 mi14 mi16 mi18 mi20; 
array stra {*}  str86 str88 str90 str92 str94 str96 str98 str00 str02 str04 str06 str08 str10 str12 str14 str16 str18 str20; 
array cana{*}   can86 can88 can90 can92 can94 can96 can98 can00 can02 can04 can06 can08 can10 can12 can14 can16 can18 can20;

array anga {*}  ang86 ang88 ang90 ang92 ang94 ang96 ang98 ang00 ang02 ang04 ang06 ang08 ang10 ang12 ang14 ang16 ang18 ang20; 
array hichola{*} chol86 chol88 chol90 chol92 chol94 chol96 chol98 chol00 chol02 chol04 chol06 chol08 chol10 chol12 chol14 chol16 chol18 chol20; 
array hbpa {*}  hbp86 hbp88 hbp90 hbp92 hbp94 hbp96 hbp98 hbp00 hbp02 hbp04 hbp06 hbp08 hbp10 hbp12 hbp14 hbp16 hbp18 hbp20; 
array cabga {*} cabg86 cabg88 cabg90 cabg92 cabg94 cabg96 cabg98 cabg00 cabg02 cabg04 cabg06 cabg08 cabg10 cabg12 cabg14 cabg16 cabg18 cabg20;
array tiaa {*}  XXXX XXXX tia90 tia92 tia94 tia96 tia98 tia00 tia02 tia04 tia06 tia08 tia10 tia12 tia14 tia16 tia18 tia20; /*Transient ischemic attacks*/
array carta {*}  XXXX XXXX cart90 cart92 cart94 cart96 cart98 cart00 cart02 cart04 cart06 cart08 cart10 cart12 cart14 cart16 cart18 cart20; /*Carotid Artery Surgery*/

array interma{*} interm86 interm88 interm90 interm92 interm94 interm96 interm98 interm00 interm02 interm04 interm06 interm08 interm10 interm12 interm14 interm16 interm18 interm20;

  do i=1 to dim(diaba);
    if i>1 then do;
      if diaba{i-1}=1 then diaba{i}=1;
      if mia{i-1}=1 then mia{i}=1;
      if stra{i-1}=1 then stra{i}=1;
      if cana{i-1}=1 then cana{i}=1;

      if anga{i-1}=1 then anga{i}=1;
      if hichola{i-1}=1 then hichola{i}=1;
      if hbpa{i-1}=1 then hbpa{i}=1;
      if cabga{i-1}=1 then cabga{i}=1;
      if tiaa{i-1}=1 then tiaa{i}=1;
      if carta{i-1}=1 then carta{i}=1;
    end;

    if anga{i}=1 | hichola{i}=1 | hbpa{i}=1 | cabga{i}=1  then interma{i}=1;
    else interma{i}=0;
  end;



* physical examine for screening purpose ;
array pscexama {*} psexam88 psexam88 psexam90 psexam92 psexam94 psexam96 psexam98 psexam00 psexam02 psexam04 psexam06 psexam08 psexam10 psexam12 psexam14 psexam16 psexam18 psexam20;

  do i=2 to dim(pscexama);
   if pscexama{i}=. then pscexama{i}=pscexama{i-1};
  end;



* family history of db ; 
if dbfh92=1 or dbfh87=1 then dbfh=1; else dbfh=0;

* baseline diabetes ;
if db86=1 or db88=1 or db90=1 then dbbase=1; else dbbase=0;
label dbbase =' baseline diabetes';

* baseline cancer ;
if can86=1 or can88=1 or can90=1 then canbase=1; else canbase=0;
label canbase='baseline cancer'; 

* baseline hypertension ;
if hbp86 = 1 or hbp88=1 or hbp90=1 then hbpbase=1; else hbpbase=0;
label hbpbase='baseline hypertension';

* baseline high blood cholsterol ;
if chol86 =1 or chol88=1 or chol90=1 then cholbase=1; else cholbase=0;
label cholbase='baseline high blood cholsterol';




* multivitamin ;

array mvyna{*} mvyn86 mvyn88 mvyn90 mvyn92 mvyn94 mvyn96 mvyn98 mvyn00 mvyn02 mvyn04 mvyn06 mvyn08 mvyn10 mvyn12 mvyn14 mvyn14 mvyn18 mvyn18;
    do i=1 to dim(mvyna);
        if i>1 then do;
            if mvyna{i}=. & mvyna{i-1}^=. then mvyna{i}=mvyna{i-1};
        end;
        if mvyna{i}=. then mvyna{i}=0;
    end;



* Endoscopy;

array endo {*} endo86 endo88 endo90 endo92 endo94 endo96 endo98 endo00 endo02 endo04 endo06 endo08 endo10 endo12 endo14 endo16 endo18 endo20;

do i=2 to dim(endo);
   if endo{i}=. then endo{i}=endo{i-1};
end;







* PSA screening;

*Create consistent PSA screening variable -value of 1 if report psa test for screening or symptoms;
  npsa86 = 0; 
  npsa88 = 0;
  npsa90 = 0; 
  npsa92 = 0;
  npsa94 = 0;
    * Create PSA variables for years prior to 1994 when asked on Q;
    if psa94 = 3 then do; *reported having PSA test on 1994 Q;
      *then asked year of most recent PSA test;
        if psad94 = 1           then npsa88 = 1; *test before 1988;
        else if psad94 = 2      then npsa90 = 1; *test 88-89;
        else if psad94 in (3,4) then npsa92 = 1; *test 90-91 or 92;
        else if psad94 in (5,6) then npsa94 = 1; *test in 1993 or 1994; 
    end;

  npsa96 = 0; if psa96 in (2,3)             then npsa96 = 1;
  npsa98 = 0; if psa98 in (2,3)             then npsa98 = 1;
  npsa00 = 0; if psa00 in (2,3)             then npsa00 = 1;
  npsa02 = 0; if psasy02 = 1 or psasc02 = 1 then npsa02 = 1;
  npsa04 = 0; if psasy04 = 1 or psasc04 = 1 then npsa04 = 1;
  npsa06 = 0; if psasy06 = 1 or psasc06 = 1 then npsa06 = 1;
  npsa08 = 0; if psasy08 = 1 or psasc08 = 1 then npsa08 = 1;
  npsa10 = 0; if psasy10 = 1 or psasc10 = 1 then npsa10 = 1;
  npsa12 = 0; if psasy12 = 1 or psasc12 = 1 then npsa12 = 1;
  npsa14 = 0; if psasy14 = 1 or psasc14 = 1 then npsa14 = 1;
  npsa16 = 0; if psasy16 = 1 or psasc16 = 1 then npsa16 = 1;
  npsa18 = 0; if psasy18 = 1 or psasc18 = 1 then npsa18 = 1;
  npsa20 = 0; if psasy20 = 1 or psasc20 = 1 then npsa20 = 1;

label npsa94 = 'PSA screening in 1994, y/n'
      npsa00 = 'PSA screening in 2000, y/n'
      npsa04 = 'PSA screening in 2004, y/n';

/*history of PSA test whole period*/ 
array psaperiod  {*} npsa86   npsa88  npsa90   npsa92  npsa94  npsa96  npsa98   npsa00   npsa02   npsa04  npsa06   npsa08   npsa10   npsa12   npsa14  npsa16  npsa18  npsa20;
array psahis     {*} npsah86 npsah88 npsah90  npsah92 npsah94 npsah96 npsah98  npsah00  npsah02  npsah04 npsah06  npsah08  npsah10  npsah12  npsah14 npsah16 npsah18 npsah20;

do i=1 to dim(psaperiod);
  psahis{i}=psaperiod{i};
end;

do i = 2 to dim(psahis);
    if psahis{i - 1} = 1 then psahis{i} = 1;
      else if psahis{i} in (0, .) then psahis{i} = 0;
  end;






* ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo; 
* Physical activity: cumulative average
* ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo; 

/* MET-hour/week */
totalpa86mv = mean(totalpa86m);
totalpa88mv = mean(totalpa86m, totalpa88m);
totalpa90mv = mean(totalpa86m, totalpa88m, totalpa90m);
totalpa92mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m);
totalpa94mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m);
totalpa96mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m);
totalpa98mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m);
totalpa00mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m);
totalpa02mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa02m);
totalpa04mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa02m, totalpa04m);
totalpa06mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa02m, totalpa04m, totalpa06m);
totalpa08mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa02m, totalpa04m, totalpa06m, totalpa08m);
totalpa10mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa02m, totalpa04m, totalpa06m, totalpa08m, totalpa10m);
totalpa12mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa02m, totalpa04m, totalpa06m, totalpa08m, totalpa10m, totalpa12m);
totalpa14mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa02m, totalpa04m, totalpa06m, totalpa08m, totalpa10m, totalpa12m, totalpa14m);
totalpa16mv = mean(totalpa86m, totalpa88m, totalpa90m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa02m, totalpa04m, totalpa06m, totalpa08m, totalpa10m, totalpa12m, totalpa14m, totalpa16m);


/* total PA, cumulative average, 2-year lag */
               /* QQ      86          88          90          92          94          96          98          00          02          04          06          08          10          12          14          16          18          20 */
 array totalpav2laga {18} totalpa86mv totalpa86mv totalpa88mv totalpa90mv totalpa92mv totalpa94mv totalpa96mv totalpa98mv totalpa00mv totalpa02mv totalpa04mv totalpa06mv totalpa08mv totalpa10mv totalpa12mv totalpa14mv totalpa16mv totalpa16mv;
   
/* total PA, cumulative average, 4-year lag */
 array totalpav4laga {18} totalpa86mv totalpa86mv totalpa86mv totalpa88mv totalpa90mv totalpa92mv totalpa94mv totalpa96mv totalpa98mv totalpa00mv totalpa02mv totalpa04mv totalpa06mv totalpa08mv totalpa10mv totalpa12mv totalpa14mv totalpa16mv;

/* total PA, cumulative average, 8-year lag */
 array totalpav8laga {18} totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa88mv totalpa90mv totalpa92mv totalpa94mv totalpa96mv totalpa98mv totalpa00mv totalpa02mv totalpa04mv totalpa06mv totalpa08mv totalpa10mv totalpa12mv;

/* total PA, cumulative average, 12-year lag */
 array totalpav12laga {18} totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa88mv totalpa90mv totalpa92mv totalpa94mv totalpa96mv totalpa98mv totalpa00mv totalpa02mv totalpa04mv totalpa06mv totalpa08mv;
   


/* percentage of times meeting guideline, 2-year lag */
 array pctmeet2laga {18} pctmeet86 pctmeet86 pctmeet88 pctmeet90 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet02 pctmeet04 pctmeet06 pctmeet08 pctmeet10 pctmeet12 pctmeet14 pctmeet16 pctmeet16; 
 array pctmeett2laga {18} pctmeett86 pctmeett86 pctmeett88 pctmeett90 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett02 pctmeett04 pctmeett06 pctmeett08 pctmeett10 pctmeett12 pctmeett14 pctmeett16 pctmeett16; 
 array pctmeettt2laga {18} pctmeettt86 pctmeettt86 pctmeettt88 pctmeettt90 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt02 pctmeettt04 pctmeettt06 pctmeettt08 pctmeettt10 pctmeettt12 pctmeettt14 pctmeettt16 pctmeettt16; 

/* percentage of times meeting guideline, 4-year lag */
 array pctmeet4laga {18} pctmeet86 pctmeet86 pctmeet86 pctmeet88 pctmeet90 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet02 pctmeet04 pctmeet06 pctmeet08 pctmeet10 pctmeet12 pctmeet14  pctmeet16 ; 
 array pctmeett4laga {18} pctmeett86 pctmeett86 pctmeett86 pctmeett88 pctmeett90 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett02 pctmeett04 pctmeett06 pctmeett08 pctmeett10 pctmeett12 pctmeett14 pctmeett16; 
 array pctmeettt4laga {18} pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt88 pctmeettt90 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt02 pctmeettt04 pctmeettt06 pctmeettt08 pctmeettt10 pctmeettt12 pctmeettt14 pctmeettt16; 

/* percentage of times meeting guideline, 8-year lag */
 array pctmeet8laga {18} pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet88 pctmeet90 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet02 pctmeet04 pctmeet06 pctmeet08 pctmeet10 pctmeet12; 
 array pctmeett8laga {18} pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett88 pctmeett90 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett02 pctmeett04 pctmeett06 pctmeett08 pctmeett10 pctmeett12; 
 array pctmeettt8laga {18} pctmeettt86 pctmeettt86v pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt88 pctmeettt90 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt02 pctmeettt04 pctmeettt06 pctmeettt08 pctmeettt10 pctmeettt12; 

/* percentage of times meeting guideline, 12-year lag */
 array pctmeet12laga {18} pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet88 pctmeet90 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet02 pctmeet04 pctmeet06 pctmeet08; 
 array pctmeett12laga {18} pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett88 pctmeett90 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett02 pctmeett04 pctmeett06 pctmeett08; 
 array pctmeettt12laga {18} pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86v pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt88 pctmeettt90 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt02 pctmeettt04 pctmeettt06 pctmeettt08; 


 /* number of times reported PA questionnaire, 2-year lag */
 array treporta {18} treport86 treport86 treport88 treport90 treport92 treport94 treport96 treport98 treport00 treport02 treport04 treport06 treport08 treport10 treport12 treport14 treport16 treport16;



