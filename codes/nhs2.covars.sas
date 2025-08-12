/*********************************************************************************************************
Project: Association of consistent reaching PA target with mortality

Created: Apr 2025

Purpose: To read in variables

Study Design: Prospective cohort study

Cohort follow-up period: NHS2 1989-2021, with 2-year lag, actual follow-up 1991-2021

Exclusion criteria: baseline cancer or CVD, missing PA, missing death date

Endpoints: all cause and cause-specific mortality

Covariates: age, race, family history of CVD, family history of cancer, alcohol consumption, total energy intake, smoking status, AHEI, BMI, menopausal status and postmenopausal hormone use (women)

************************************************************************************************/

filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/';
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos/';
libname nhsfmt '/proj/nhsass/nhsas00/formats';
libname hpfsfmt '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing nhstools hpstools);
options fmtsearch=(nhsfmt hpfsfmt) nocenter nofmterr;
options ls=125 ps=78;


/******** READ IN PA *********/

%include '/udd/hpyzh/pa_consist/nhs2/nhs2_pa.sas';
proc sort nodupkey data=nhs2_pa_met; by id; run;


/* Read in SES */
%include '/udd/hpyzh/proj_data/nhs2/SES_nhs2.sas';
proc sort nodupkey data=nses8917;by id;run;



/* READ IN DIET AND NUTRIENT VARAIBLES */
%n91_nts(keep=alco91n calor91n);
%n95_nts(keep=alco95n calor95n);
%n99_nts(keep=alco99n calor99n);
%n03_nts(keep=alco03n calor03n);
%n07_nts(keep=alco07n calor07n);
%n11_nts(keep=alco11n calor11n);
%n15_nts(keep=alco15n calor15n);


%ahei2010_9115(keep=ahei2010_91 ahei2010_95 ahei2010_99 ahei2010_03 ahei2010_07 ahei2010_11 ahei2010_15);

data nhs2_ahei;
  set ahei2010_9115;

nAHEI91=ahei2010_91;
nAHEI95=ahei2010_95;
nAHEI99=ahei2010_99;
nAHEI03=ahei2010_03;
nAHEI07=ahei2010_07;
nAHEI11=ahei2010_11;
nAHEI15=ahei2010_15;
 
 keep id nAHEI91 nAHEI95 nAHEI99 nAHEI03 nAHEI07 nAHEI11 nAHEI15;

run;


/* read in alcohol type */
%include '/udd/hpyzh/pa_consist/nhs2/nhs2.alcohol.sas';
proc sort nodupkey data=nhs2_alcohol;by id;run;


/* read in endo */
%include '/udd/hpyzh/pa_consist/nhs2/nhs2_endo.sas';
proc sort nodupkey data=sigmoid;by id;run;





/***************************** READ IN DEATH AND DISEASE FILES ************************/

* Breast cancer - to code pre/post menopausal breast cancer *; 
data brca;
%include '/proj/n2dats/n2_dat_cdx/endpoints/breast/br8921.083022.cases.input';  /* Updated Jan 2024*/
if 11<=conf<=19  then brca_ca=1;
if brca_ca=1 then dt_brca=dxmonth;
if era_results=1 and brca_ca=1 then er_status=1;
if pra_results=1 and brca_ca=1 then pr_status=1;
dtdxca3 = dt_brca;

keep id brca_ca er_status pr_status dt_brca dtdxca3;
run;
proc sort nodupkey; by id; run; 

%der8919(keep=amnp birthday
              namnp89 namnp91 namnp93 namnp95 namnp97 namnp99 namnp01 namnp03 namnp05 namnp07 namnp09 namnp11 namnp13 namnp15 namnp17
              age89 age91 age93 age95 age97 age99 age01 age03 age05 age07 age09 age11 age13 age15 age17
              smkdr89 smkdr91 smkdr93 smkdr95 smkdr97 smkdr99 smkdr01 smkdr03 smkdr05 smkdr07 smkdr09 smkdr11 smkdr13 smkdr15 smkdr17);
array namnp{*} namnp89 namnp91 namnp93 namnp95 namnp97 namnp99 namnp01 namnp03 namnp05 namnp07 namnp09 namnp11 namnp13 namnp15 namnp17;
amnp = .;
do i=1 to dim(namnp);
if .<namnp{i}<95 & amnp=. then amnp=namnp{i};
end;
run;

data brca;
merge der8919 brca(in=a);
by id;
if a=1;

age_dx = ( dt_brca - birthday )/12;

array age{*} age89 age91 age93 age95 age97 age99 age01 age03 age05 age07 age09 age11 age13 age17;
array smkdr{*} smkdr89 smkdr91 smkdr93 smkdr95 smkdr97 smkdr99 smkdr01 smkdr03 smkdr05 smkdr07 smkdr09 smkdr11 smkdr13 smkdr15 smkdr17;

if age_dx>0 & amnp>0 & age_dx<amnp then prebrca_ca=1;
else if age_dx>0 & amnp>0 & age_dx>=amnp then postbrca_ca=1;

do i=2 to dim(age);
        if age{i-1}<=age_dx<age{i} & amnp =. then do;
        if age_dx<46 & 9<=smkdr{i-1}<=15 then prebrca_ca=1;
        else if age_dx<48 & 1<=smkdr{i-1}<=8 then prebrca_ca=1;
        else if age_dx>54 & 9<=smkdr{i-1}<=15 then postbrca_ca=1;
        else if age_dx>56 & 1<=smkdr{i-1}<=8 then postbrca_ca=1;
        end;
end;

if prebrca_ca=. & postbrca_ca=. & brca_ca=1 then prebrca_ca=1;
keep id brca_ca prebrca_ca postbrca_ca er_status pr_status dt_brca dtdxca3;
run;


/** DEATH FILES **/
%deadff(keep=deadmonth dtdth nhsicda dead_injury newicda, file=/proj/n2dats/n2_dat_cdx/deaths/deadff.current.nhs2);

   if deadmonth > 0 then dtdth=deadmonth;

*nhsicda = compress (nhsicda,'E');
if substr(nhsicda,1,1) = 'E' then dead_injury = 1;
if substr(nhsicda,1,1) not eq 'E' then newicda=input(substr(nhsicda,1,3),3.);

run;
proc sort; by id; 
run;


data deadff;
 merge deadff(in=a) brca der8919;
 by id;
 if a;

   if deadmonth > 0 then dead_all=1;

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
if 410<=newicda<=414 then dead_ihd=1;  /* ischaemic heart disease */
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

PW: Definitions varied between cohorts
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

* code premenopausal/postmenopausal BC death *;
aged = ( dtdth - birthday )/12;

array age{*} age89 age91 age93 age95 age97 age99 age01 age03 age05 age07 age09 age11 age13 age17;
array smkdr{*} smkdr89 smkdr91 smkdr93 smkdr95 smkdr97 smkdr99 smkdr01 smkdr03 smkdr05 smkdr07 smkdr09 smkdr11 smkdr13 smkdr15 smkdr17;

if dead_brca=1 & prebrca_ca=1 then dead_prebrca=1;
else if dead_brca=1 & postbrca_ca=1 then dead_postbrca=1; 
if dead_prebrca=. &  dead_postbrca=. & dead_brca=1 then do;
        if aged>0 & amnp>0 & aged<amnp then  dead_prebrca=1;
        else if aged>0 & amnp>0 & aged>=amnp then dead_postbrca=1;

        do i=2 to dim(age);
                if age{i-1}<=aged<age{i} & amnp =. then do;
                if aged<46 & 9<=smkdr{i-1}<=15 then dead_prebrca=1;
                else if aged<48 & 1<=smkdr{i-1}<=8 then dead_prebrca=1;
                else if aged>54 & 9<=smkdr{i-1}<=15 then dead_postbrca=1;
                else if aged>56 & 1<=smkdr{i-1}<=8 then dead_postbrca=1;
                end;
        end;        
end;     

* other death *;
*if dtdth>0 and sum(of dead_cvd dead_cancer dead_resp dead_renal dead_diab dead_neuro dead_injury dead_suicide)<=0 then dead_other=1;
if dtdth>0 and sum(of dead_cvd dead_cancer dead_resp dead_neuro)<=0 then dead_other=1;


if dead_all eq 1 and dead_injury ne 1 and dead_suicide ne 1 then dead_ntraumatic=1;
if dead_injury eq 1 or dead_suicide eq 1 then dead_traumatic = 1;

if sum(of dead_oralca dead_esophca dead_stomachca dead_smallintestca dead_colorectca dead_liverca 
          dead_gallbladderca dead_pancrca)>=1 then dead_gica=1;
if sum(of dead_oralca dead_esophca dead_stomachca dead_smallintestca dead_colorectca)>=1 then dead_gitca=1;
if sum(of dead_oralca dead_esophca dead_stomachca dead_smallintestca)>=1 then dead_upgitca=1;
if sum(of dead_liverca dead_gallbladderca dead_pancrca)>=1 then dead_gioca=1;

if sum(of dead_esophca dead_stomachca dead_colorectca dead_liverca dead_gallbladderca dead_pancrca dead_postbrca 
          dead_endoca dead_ovca dead_kidneyca dead_thyroidca dead_mmyeloma)>=1 then dead_obesca=1;

if sum(of dead_oralca dead_esophca dead_stomachca dead_colorectca dead_liverca dead_pancrca dead_otherrespca
          dead_lungca dead_cervicalca dead_ovca dead_bladderca dead_kidneyca dead_myeleuk)>=1 then dead_smokeca=1;


if dtdth>0 and dead_cvd ne 1 then dead_noncvd=1;  /* non-CVD death */


run;









/********************************* READ IN OTHER COVARIATES***************************/
%der8919(keep=birthday race8905 mrace8905 eth8905 bmi18 whrat93 whrat05 height89
        retmo89 retmo91 retmo93 retmo95 retmo97 retmo99 retmo01 retmo03 retmo05 retmo07 retmo09 retmo11 retmo13 retmo15 retmo17 retmo19
        bmi89 bmi91 bmi93 bmi95 bmi97 bmi99 bmi01 bmi03 bmi05 bmi07 bmi09 bmi11 bmi13 bmi15 bmi17 bmi19
          smkdr89 smkdr91 smkdr93 smkdr95 smkdr97 smkdr99 smkdr01 smkdr03 smkdr05 smkdr07 smkdr09 smkdr11 smkdr13 smkdr15 smkdr17 smkdr19
          msqui89 msqui91 msqui93 msqui95 msqui97 msqui99 msqui01 msqui03 msqui05 msqui07 msqui09 msqui11 msqui13 msqui15 msqui17 msqui19
          pkyr89 pkyr91 pkyr93 pkyr95 pkyr97 pkyr99 pkyr01 pkyr03 pkyr05 pkyr07 pkyr09 pkyr11 pkyr13 pkyr15 pkyr17 pkyr19
        can89 can91 can93 can95 can97 can99 can01 can03 can05 can07 can09 can11 can13 can15 can17 can19
        namnp89 namnp91 namnp93 namnp95 namnp97 namnp99 namnp01 namnp03 namnp05 namnp07 namnp09 namnp11 namnp13 namnp15 namnp17 namnp19
        mnpst89 mnpst91 mnpst93 mnpst95 mnpst97 mnpst99 mnpst01 mnpst03 mnpst05 mnpst07 mnpst09 mnpst11 mnpst13 mnpst15 mnpst17 mnpst19
        mnty89 mnty91 mnty93 mnty95 mnty97 mnty99 mnty01 mnty03 mnty05 mnty07 mnty09 mnty11 mnty13 mnty15 mnty17 mnty19
          nhor89 nhor91 nhor93 nhor95 nhor97 nhor99 nhor01 nhor03 nhor05 nhor07 nhor09 nhor11 nhor13 nhor15 nhor17 nhor19
     );
run;

run;
proc sort nodupkey;by id;run;


%nur89(keep=wt1889 wt89 hbp89 db89 chol89 mi89 str89 mdb89 fdb89 bdb89 sdb89 fmdiab89 ammi89 afmi89 fmcvd89
               mclc89 fclc89 bclc89 sclc89 fmclc89 ambrc89 asbrc89 mmel89 fmel89 bmel89 smel89 cafh89 physx89 psexam89 icda89 ucol89
               seuro89 scand89 ocauc89 afric89 hisp89  asian89 oanc89
               q32pt89);

if sum(mclc89,fclc89,bclc89,sclc89)>=1 then fmclc89=1;else fmclc89=0; * CRC fhx;
cafh89=0; if fmclc89=1 or ambrc89 in (1,2,3,4,5) or asbrc89 in (1,2,3,4,5) then cafh89=1; * cancer fhx;
if sum(mclc89,fclc89, bclc89, sclc89, mmel89,fmel89, bmel89, smel89)>=1 then cafh89=1;
if physx89=2 then psexam89=1;  * symptom ;
else if physx89=3 then psexam89=2; * screening ;
if icda89=:563 then ucol89=1; else ucol89=0;
if mdb89=1 or fdb89=1 or bdb89=1 or sdb89=1 then fmdiab89=1;
if ammi89 in (1,2,3,4,5) or afmi89 in (1,2,3,4,5) then fmcvd89=1;
run;

%nur91(keep=wt91 hbp91 db91 chol91 mi91 ang91 str91 ra91 oa91 artri91 ucol91);
if ucol91=1 then ucol91=1; else ucol91=0;
if ra91=1 or oa91=1 then artri91=1;else artri91=0;
run;

%nur93(keep=wt93 hbp93 db93 chol93 mi93 ang93 str93 ra93 oa93 artri93 ucol93 
               msov93 mcanc93 fcanc93 cafh93 fmi93 mmi93 fmcvd93);
     if ra93=1 or oa93=1 then artri93=1; else artri93=0;
     cafh93=0; if msov93=2 or mcanc93=1 or fcanc93=1 then cafh93=1; * cancer fhx;
     if fmi93=1 or mmi93=1 then fmcvd93=1;
run;

%nur95(keep=wt95 hbp95 db95 chol95 mi95 ang95 str95 cabg95 ucol95);
run;

%nur97(keep=wt97 hbp97 db97 chol97 mi97 ang97 str97 cabg97 ucol97 ra97 oa97 artri97 
               pclc97 sclc197 sclc297 fmclc97 mbrcn97 sbrc197 sbrc297 mov97 sov97 pmel97 smel97 cafh97
               pdb97 sbdb97 fmdiab97 mstr97 fstr97 sbstr97 mmi97 fmi97 fmcvd97);
if ra97=1 or oa97=1 then artri97=1; else artri97=0;
if sum(pclc97,sclc197,sclc297)>0 then fmclc97=1; else fmclc97=0;
if sum(mbrcn97, sbrc197, sbrc297, mov97, sov97, pclc97, sclc197, sclc297, pmel97, smel97)>0 then cafh97=1; else cafh97=0;
if pdb97=1 or sbdb97=1 then fmdiab97=1;
if mstr97=1 or fstr97=1 or sbstr97=1 or mmi97=1 or fmi97=1 then fmcvd97=1;
run;

%nur99(keep=wt99 hbp99 db99 chol99 mi99 ang99 str99 cabg99 ucol99 ra99 oa99 artri99);
if ra99=1 or oa99=1 then artri99=1; else artri99=0;
run;

%nur01(keep=wt01 hbp01 db01 chol01 mi01 ang01 str01 cabg01 ucol01 ra01 oa01 artri01 physc01 physy01 psexam01 q34pt01
               cafh01 pclc01 sclc101 sclc201 fmclc01 mov01 sov01 mbrcn01 sbrc101 sbrc201 mut01 smut01 ppan01 span01 pmel01 smel01
               mdb01 fdb01 sdb01 fmdiab01 mstr01 fstr01 sstr01 mmi01 fmi01 smi01 fmcvd01);
if ra01=1 or oa01=1 then artri01=1; else artri01=0;
psexam01=0;if physc01=1 then psexam01=2;else if physy01=1 then psexam01=1;
if sum(mov01,sov01,mbrcn01,sbrc101,sbrc201,pclc01,sclc101,sclc201,mut01,smut01,ppan01,span01,pmel01,smel01)>0 then cafh01=1; else cafh01=0;
if sum(pclc01,sclc101,sclc201)>0 then fmclc01=1; else fmclc01=0;
if mdb01=1 or fdb01=1 or sdb01=1 then fmdiab01=1;
if mstr01=1 or fstr01=1 or sstr01=1 or mmi01=1 or fmi01=1 or smi01=1 then fmcvd01=1;
run;

%nur03(keep=wt03 hbp03 db03 chol03 mi03 ang03 str03 cabg03 ucol03 ra03 oa03 artri03 physc03 physy03 psexam03);
if ra03=1 or oa03=1 then artri03=1; else artri03=0;
if physc03=1 then psexam03=2;else if physy03=1 then psexam03=1; else psexam03=0;
run;

%nur05(keep=wt05 hbp05 db05 chol05 mi05 ang05 str05 cabg05 tia05 ucol05 ra05 oa05 artri05 physc05 physy05 psexam05 
     pclc05 sclc105 sclc205 fmclc05 mov05 sov05 mbrcn05 sbrc105 sbrc205 mdcan05 fdcan05 pmel05 smel05 cafh05
     mdb05 fdb05 sdb05 fmdiab05 fdchd05 fdstr05 mdchd05 mdstr05 fmcvd05
     hisp05 white05 black05 nativ05 hawai05 oanc05 asian05);
if ra05=1 or oa05=1 then artri05=1; else artri05=0;
if physc05=1 then psexam05=2;else if physy05=1 then psexam05=1; else psexam05=0;
if sum(mov05,sov05,mbrcn05,sbrc105,sbrc205,pclc05,sclc105,sclc205,mdcan05,fdcan05,pmel05,smel05) then cafh05=1; else cafh05=0;
if sum(pclc05,sclc105,sclc205)>0 then fmclc05=1; else fmclc05=0;
if mdb05=1 or fdb05=1 or sdb05=1 then fmdiab05=1;
if fdchd05=1 or fdstr05=1 or mdchd05=1 or mdstr05=1 then fmcvd05=1;
run;

%nur07(keep=wt07 hbp07 db07 chol07 mi07 ang07 str07 cabg07 tia07 ucol07 ra07 oa07 artri07 physc07 physy07 psexam07 );
if ra07=1 or oa07=1 then artri07=1; else artri07=0;
if physc07=1 then psexam07=2;else if physy07=1 then psexam07=1;else psexam07=0;
run;

%nur09(keep=wt09 hbp09 db09 chol09 mi09 ang09 str09 cabg09 tia09 ucol09 ra09 oa09 artri09 physc09 physy09 psexam09 
     pclc09 sclc109 sclc209 fmclc09 mov09 sov09 mbrcn09 sbrcn09 mdcan09 fdcan09 cafh09
     pdb09 sdb09 fmdiab09 mdchd09 mdstr09 fdchd09 fdstr09 fmcvd09);
if ra09=1 or oa09=1 then artri09=1; else artri09=0;
if physc09=1 then psexam09=2;else if physy09=1 then psexam09=1; else psexam09=0;
if sum(pclc09,sclc109,sclc209)>0 then fmclc09=1; else fmclc09=0;
if sum(fmclc09,mov09,sov09,mbrcn09,sbrcn09,mdcan09,fdcan09)>0 then cafh09=1; else cafh09=0;
if pdb09=1 or sdb09=1 then fmdiab09=1;
if mdchd09=1 or mdstr09=1 or fdchd09=1 or fdstr09=1 then fmcvd09=1;
run;

%nur11(keep=wt11 hbp11 db11 chol11 mi11 ang11 str11 cabg11 tia11 ucol11 ra11 oa11 artri11 physc11 physy11 psexam11);
if ra11=1 or oa11=1 then artri11=1; else artri11=0;
if physc11=1 then psexam11=2;else if physy11=1 then psexam11=1; else psexam11=0;
run;

%nur13(keep=wt13 hbp13 db13 chol13 mi13 ang13 str13 cabg13 tia13 ucol13 ra13 oa13 artri13 physc13 physy13 psexam13 
               hxov13 hxbc13 mdcan13 fdcan13 cafh13
               fdchd13 fdstr13 mdchd13 mdstr13 fmcvd13 hxdb13 fmdiab13);
if ra13=1 or oa13=1 then artri13=1; else artri13=0;
if physc13=1 then psexam13=2;else if physy13=1 then psexam13=1; else psexam13=0;
if sum(hxov13,hxbc13,mdcan13,fdcan13)>0 then cafh13=1; else cafh13=0;
if fdchd13=1 or fdstr13=1 or mdchd13=1 or mdstr13=1 then fmcvd13=1;
if hxdb13=1 then fmdiab13=1;
run;

%nur15(keep=wt15 hbp15 db15 chol15 mi15 ang15 str15 cabg15 tia15 ucol15 ra15 oa15 artri15 physc15 physy15 psexam15);
if ra15=1 or oa15=1 then artri15=1; else artri15=0;
if physc15=1 then psexam15=2;else if physy15=1 then psexam15=1; else psexam15=0;
run;

%nur17(keep=wt17 hbp17 db17 chol17 mi17 ang17 str17 cabg17 tia17 ucol17 ra17 artri17 physc17 physy17 psexam17);
if ra17=1 then artri17=1; else artri17=0;
if physc17=1 then psexam17=2;else if physy17=1 then psexam17=1; else psexam17=0;
run;

%nur19(keep=wt19 hbp19 db19 chol19 mi19 ang19 str19 cabg19 tia19 ucol19  physc19 physy19 psexam19);
if physc19=1 then psexam19=2;else if physy19=1 then psexam19=1; else psexam19=0;
run;


* supplements *;
%supp8915(keep=mvitu89 mvitu91 mvitu93 mvitu95 mvitu97 mvitu99 mvitu01 mvitu03 mvitu05 mvitu07 mvitu09 mvitu11 mvitu13 mvitu15
               mvyn89 mvyn91 mvyn93 mvyn95 mvyn97 mvyn99 mvyn01 mvyn03 mvyn05 mvyn07 mvyn09 mvyn11 mvyn13 mvyn15);
    array mvitu{*} mvitu89 mvitu91 mvitu93 mvitu95 mvitu97 mvitu99 mvitu01 mvitu03 mvitu05 mvitu07 mvitu09 mvitu11 mvitu13 mvitu15;
    array mvyn{*} mvyn89 mvyn91 mvyn93 mvyn95 mvyn97 mvyn99 mvyn01 mvyn03 mvyn05 mvyn07 mvyn09 mvyn11 mvyn13 mvyn15;
    do i=dim(mvitu) to 2 by -1;if mvitu{i} in (.,9) and mvitu{i-1} in (1,0) then mvitu{i}=mvitu{i-1};end;
    do i=1 to dim(mvitu);if mvitu{i}=1 then mvyn{i}=1;else mvyn{i}=0;end;




/********************************* Merge datasets ***************************/
data nhs2_data;
     merge  nhs2_pa_met  deadff nses8917 nhs2_alcohol sigmoid
            der8919(in=mstr) nhs2_ahei
            nur89 nur91 nur93 nur95 nur97 nur99 nur01 nur03 nur05 nur07 nur09 nur11 nur13 nur15 nur17 nur19 supp8915
            n91_nts n95_nts n99_nts n03_nts n07_nts n11_nts n15_nts 

     ;
     by id;
     exrec=1;
     if first.id and mstr then exrec=0; 

run;

proc datasets nolist;
 delete nhs2_pa_met  deadff nses8917
        der8917 nhs2_ahei
        nur89 nur91 nur93 nur95 nur97 nur99 nur01 nur03 nur05 nur07 nur09 nur11 nur13 nur15 nur17
        n91_nts n95_nts n99_nts n03_nts n07_nts n11_nts n15_nts;
run;


data nhs2_data;
  set nhs2_data end=_end_;


* cohort indicator ;     
  cohort=3; 
  cutoff=(2021-1900)*12+6; * set cutoff to 2021.6 - 1458;


* Questionnaire return ;
array tvar {*} t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18;
array origirta{*} retmo91 retmo93 retmo95 retmo97 retmo99 retmo01 retmo03 retmo05 retmo07 retmo09 retmo11 retmo13 retmo15 retmo17 retmo19 cutoff;
array irt {*} irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 cutoff;
array period {15} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11 period12 period13 period14 period15;

* create lastq before correcting irt 
     lost to follow-up        --> lastq = last irt
     not lost to follow-up    --> lastq = . *;

     do i=1 to dim(origirta)-1;    
          if origirta{i} > 0 then lastq = origirta{i};
     end;
     if lastq = irt{dim(origirta)-1} then lastq=.;

     do i=1 to dim(irt)-1;   * 1074 = 1989 June   1098 = 1991 June; 
          if origirta{i}<(1074+24*i) | origirta{i}>=(1098+24*i) then origirta{i}=1074+24*i;
          irt{i}=origirta{i};
     end;


* Birthday ;

* race; 
   if race8905=1 then white=1; else white=0;


* Age ;
array agemoa {*} agemo91 agemo93 agemo95 agemo97 agemo99 agemo01 agemo03 agemo05 agemo07 agemo09 agemo11 agemo13 agemo15 agemo17 agemo19; 
array agea {*}   age91 age93 age95 age97 age99 age01 age03 age05 age07 age09 age11 age13 age15 age17 age19; 
array agega {*}  ageg91 ageg93 ageg95 ageg97 ageg99 ageg01 ageg03 ageg05 ageg07 ageg09 ageg11 ageg13 ageg15 ageg17 ageg19; 

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
array bmia{*}   bmi91 bmi93 bmi95 bmi97 bmi99 bmi01 bmi03 bmi05 bmi07 bmi09 bmi11 bmi13 bmi15 bmi17 bmi19;
array bmicuma{*} bmicum91 bmicum93 bmicum95 bmicum97 bmicum99 bmicum01 bmicum03 bmicum05 bmicum07 bmicum09 bmicum11 bmicum13 bmicum15 bmicum17 bmicum19;
array bmiga{*}   bmig91 bmig93 bmig95 bmig97 bmig99 bmig01 bmig03 bmig05 bmig07 bmig09 bmig11 bmig13 bmig15 bmig17 bmig19;

     do i=1 to dim(bmia);
        if bmia{i}<10 then bmia{i}=.;
    end;

     bmicum89=bmi89;
     bmicum91=mean(bmi89,bmi91);
     bmicum93=mean(bmi89,bmi91,bmi93);
     bmicum95=mean(bmi89,bmi91,bmi93,bmi95);
     bmicum97=mean(bmi89,bmi91,bmi93,bmi95,bmi97);
     bmicum99=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99);
     bmicum01=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01);
     bmicum03=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03);
     bmicum05=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03, bmi05);
     bmicum07=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03, bmi05, bmi07);
     bmicum09=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03, bmi05, bmi07, bmi09);
     bmicum11=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11);
     bmicum13=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11, bmi13);
     bmicum15=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11, bmi13, bmi15);
     bmicum17=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11, bmi13, bmi15, bmi17);
     bmicum19=mean(bmi89,bmi91,bmi93,bmi95,bmi97,bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11, bmi13, bmi15, bmi17, bmi19);

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


* smoking ;
array smkdra {*} smkdr91 smkdr93 smkdr95 smkdr97 smkdr99 smkdr01 smkdr03 smkdr05 smkdr07 smkdr09 smkdr11 smkdr13 smkdr15 smkdr17 smkdr19;
array msquia {*} msqui91 msqui93 msqui95 msqui97 msqui99 msqui01 msqui03 msqui05 msqui07 msqui09 msqui11 msqui13 msqui15 msqui17 msqui19;
array pkyra {*} pkyr91 pkyr93 pkyr95 pkyr97 pkyr99 pkyr01 pkyr03 pkyr05 pkyr07 pkyr09 pkyr11 pkyr13 pkyr15 pkyr17 pkyr19;
array smk3ga {*} smkstatus91 smkstatus93 smkstatus95 smkstatus97 smkstatus99 smkstatus01 smkstatus03 smkstatus05 smkstatus07 smkstatus09 smkstatus11 smkstatus13 smkstatus15 smkstatus17 smkstatus19; 
array cigga  {*} cigg91 cigg93 cigg95 cigg97 cigg99 cigg01 cigg03 cigg05 cigg07 cigg09 cigg11 cigg13 cigg15 cigg17 cigg19; 
array pkyrga {*} pkyrg91 pkyrg93 pkyrg95 pkyrg97 pkyrg99 pkyrg01 pkyrg03 pkyrg05 pkyrg07 pkyrg09 pkyrg11 pkyrg13 pkyrg15 pkyrg17 pkyrg19; 

     if smkdr91=0 & smkdr89^=0 then smkdr91=smkdr89;
     if smkdr91=15 & smkdr89 in (9,10,11,12,13,14) then smkdr91=smkdr89;
     if msqui91=999 & msqui89^=999 then msqui91=msqui89;
     if pkyr91=999 & pkyr89^=999 then pkyr91=pkyr89;
     do i=1 to dim(smkdra);
          if smkdra{i}=0 then smkdra{i}=.;
          if pkyra{i}=999 then pkyra{i}=.;
          if pkyra{i}=998 then pkyra{i}=0;
          if msquia{i}=999 then msquia{i}=.;
          if i>1 then do;
               if smkdra{i}=15 & smkdra{i-1} in (9,10,11,12,13,14) then smkdra{i}=smkdra{i-1};
               if smkdra{i}=. & smkdra{i-1}^=. then smkdra{i}=smkdra{i-1};
               if pkyra{i}=0 & pkyra{i-1}^=0 & smkdra{i}^=1 then pkyra{i}=pkyra{i-1};
               if pkyra{i}=. & pkyra{i-1}^=. then pkyra{i}=pkyra{i-1};
               if msquia{i}=. & msquia{i-1}^=. then msquia{i}=msquia{i-1};
          end;

          if smkdra{i} =1 then smk3ga{i}=1; *never;
     else if smkdra{i} in (2,3,4,5,6,7,8) then smk3ga{i}=2; *past;
     else if smkdra{i} in (9,10,11,12,13,14,15) then smk3ga{i}=3; *current;

          if smkdra{i}=1 /*| smkdra{i}=.*/ then cigga{i}=1; * never *;
          else if smkdra{i} in (2,3,4,5,6,7,8) & (120 le msquia{i}) then cigga{i}=2; * past >=10y *;
          else if smkdra{i} in (2,3,4,5,6,7,8) & (msquia{i} lt 120) then cigga{i}=3; * past <10y *;
          else if smkdra{i} in (9,10,11,12,13,14,15) then cigga{i}=4; * group all current together *;
          /*else if smkdra{i} in (9,10) then cigga{i}=4; * current 1-14/d*;
          else if smkdra{i} in (11) then cigga{i}=5; * current 15-24/d*;
          else if smkdra{i} in (12,13,14,15) then cigga{i}=6; * current 25- /d*;*/

          if pkyra{i}<=0 then pkyrga{i}=1;
          else if pkyra{i}<5 then pkyrga{i}=2;
          else if pkyra{i}<15 then pkyrga{i}=3;
          else if pkyra{i}<25 then pkyrga{i}=4;
          else if pkyra{i}>=25 then pkyrga{i}=5;
     end;


* menopause ;
array dmnpa{*} mnpst91 mnpst93 mnpst95 mnpst97 mnpst99 mnpst01 mnpst03 mnpst05 mnpst07 mnpst09 mnpst11 mnpst13 mnpst15 mnpst17 mnpst19; 
array nhora{*} nhor91 nhor93 nhor95 nhor97 nhor99 nhor01 nhor03 nhor05 nhor07 nhor09 nhor11 nhor13 nhor15 nhor17 nhor19; 
array menopa{*} menop91 menop93 menop95 menop97 menop99 menop01 menop03 menop05 menop07 menop09 menop11 menop13 menop15 menop17 menop19; 
array pmha{*} pmh91 pmh93 pmh95 pmh97 pmh99 pmh01 pmh03 pmh05 pmh07 pmh09 pmh11 pmh13 pmh15 pmh17 pmh19; 

     if mnpst89=2 then mnpst91=2;
     do i=1 to dim(dmnpa);
          if i>1 then do;if dmnpa{i-1}=2 then dmnpa{i}=2;end;
          if dmnpa{i} in (1,2) then menopa{i}=dmnpa{i};else menopa{i}=1;
          if dmnpa{i} in (.,3) then do;
               if agea{i}<46 and smk3ga{i}=3 then menopa{i}=1;
               else if agea{i}<48 and smk3ga{i} in (1,2) then menopa{i}=1;
               else if agea{i}>54 and smk3ga{i}=3 then menopa{i}=2;
               else if agea{i}>56 and smk3ga{i} in (1,2) then menopa{i}=2;
          end;
     end;

     if mnpst89 in (1,3) or nhor89=1 then pmh89=1;
     else if mnpst89=2 and nhor89=2 then pmh89=2;
     else if mnpst89=2 and nhor89=4 then pmh89=3;
     else if mnpst89=2 and nhor89=3 then pmh89=4;
     if pmh91 eq . and pmh89 ne . then pmh91=pmh89;
     
     do i=1 to dim(dmnpa);
          if menopa{i}=1 then pmha{i}=1; * pre or missing ;
          else if menopa{i}=2 and nhora{i}=2 then pmha{i}=2; * post never ;
          else if menopa{i}=2 and nhora{i}=4 then pmha{i}=3; * post former ;
          else if menopa{i}=2 and nhora{i}=3 then pmha{i}=4; * post current ;
          if i>1 then do;
               if pmha{i}=. and pmha{i-1} ne . then pmha{i}=pmha{i-1};
          end;
     end;



* alcohol consumption ;
array alcocuma{*} alcocum91 alcocum91 alcocum95 alcocum95 alcocum99 alcocum99 alcocum03 alcocum03 alcocum07 alcocum07 alcocum11 alcocum11 alcocum15 alcocum15 alcocum15 ;
array alcoga{*} alcog91 alcog91 alcog95 alcog95 alcog99 alcog99 alcog03 alcog03 alcog07 alcog07 alcog11 alcog11 alcog15 alcog15 alcog15;

     alcocum91=alco91n;
     alcocum95=mean(alco91n,alco95n);
     alcocum99=mean(alco91n,alco95n,alco99n);
     alcocum03=mean(alco91n,alco95n,alco99n,alco03n);
     alcocum07=mean(alco91n,alco95n,alco99n,alco03n,alco07n);
     alcocum11=mean(alco91n,alco95n,alco99n,alco03n,alco07n,alco11n);
     alcocum15=mean(alco91n,alco95n,alco99n,alco03n,alco07n,alco11n,alco15n);

     do i=1 to dim(alcoga);
          if i>1 then do;if alcocuma{i}=. then alcocuma{i}=alcocuma{i-1};end;
          if .<alcocuma{i}<5 then alcoga{i}=1;
          else if 5<=alcocuma{i}<15 then alcoga{i}=2;
          else if alcocuma{i}>=15 then alcoga{i}=3;
     end;


* beer;
beercum91=beer91;
beercum95=mean(beer91, beer95);
beercum99=mean(beer91, beer95, beer99);
beercum03=mean(beer91, beer95, beer99, beer03);
beercum07=mean(beer91, beer95, beer99, beer03, beer07);
beercum11=mean(beer91, beer95, beer99, beer03, beer07, beer11);
beercum15=mean(beer91, beer95, beer99, beer03, beer07, beer11, beer15);


* wine;
winecum91=wine91;
winecum95=mean(wine91, wine95);
winecum99=mean(wine91, wine95, wine99);
winecum03=mean(wine91, wine95, wine99, wine03);
winecum07=mean(wine91, wine95, wine99, wine03, wine07);
winecum11=mean(wine91, wine95, wine99, wine03, wine07, wine11);
winecum15=mean(wine91, wine95, wine99, wine03, wine07, wine11, wine15);

* liquor;
liqcum91=liq91;
liqcum95=mean(liq91, liq95);
liqcum99=mean(liq91, liq95, liq99);
liqcum03=mean(liq91, liq95, liq99, liq03);
liqcum07=mean(liq91, liq95, liq99, liq03, liq07);
liqcum11=mean(liq91, liq95, liq99, liq03, liq07, liq11);
liqcum15=mean(liq91, liq95, liq99, liq03, liq07, liq11, liq15);

* total alcohol;
alccum91=alc91;
alccum95=mean(alc91, alc95);
alccum99=mean(alc91, alc95, alc99);
alccum03=mean(alc91, alc95, alc99, alc03);
alccum07=mean(alc91, alc95, alc99, alc03, alc07);
alccum11=mean(alc91, alc95, alc99, alc03, alc07, alc11);
alccum15=mean(alc91, alc95, alc99, alc03, alc07, alc11, alc15);


array beercuma{*} beercum91 beercum91 beercum95 beercum95 beercum99 beercum99 beercum03 beercum03 beercum07 beercum07 beercum11 beercum11 beercum15 beercum15 beercum15;
array winecuma{*} winecum91 winecum91 winecum95 winecum95 winecum99 winecum99 winecum03 winecum03 winecum07 winecum07 winecum11 winecum11 winecum15 winecum15 winecum15;
array liqcuma{*} liqcum91 liqcum91 liqcum95 liqcum95 liqcum99 liqcum99 liqcum03 liqcum03 liqcum07 liqcum07 liqcum11 liqcum11 liqcum15 liqcum15 liqcum15;
array alccuma{*} alccum91 alccum91 alccum95 alccum95 alccum99 alccum99 alccum03 alccum03 alccum07 alccum07 alccum11 alccum11 alccum15 alccum15 alccum15;



* Cumulative average for AHEI, calories ; 
    array nut2{7, 2} 
       calor91n nAHEI91 
       calor95n nAHEI95 
       calor99n nAHEI99 
       calor03n nAHEI03 
       calor07n nAHEI07 
       calor11n nAHEI11 
       calor15n nAHEI15 
    ;


    array nutv2{7, 2} 

       ccalor91n  cAHEI91 
       ccalor95n  cAHEI95 
       ccalor99n  cAHEI99 
       ccalor03n  cAHEI03 
       ccalor07n  cAHEI07 
       ccalor11n  cAHEI11 
       ccalor15n  cAHEI15 
    ;

    do j=1 to 2;
        do i=2 to 7;
            if nut2{i,j}=. and nut2{i-1,j}^=. then nut2{i,j}=nut2{i-1,j};
        end;
    end;

    do j=1 to 2;
          nutv2{1,j}=nut2{1,j};
        do i=2 to 7; 
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


array ccalora{*}  ccalor91n ccalor91n ccalor95n ccalor95n ccalor99n ccalor99n ccalor03n ccalor03n ccalor07n ccalor07n ccalor11n ccalor11n ccalor15n ccalor15n ccalor15n;
array caheia {*} cAHEI91 cAHEI91 cAHEI95 cAHEI95 cAHEI99 cAHEI99 cAHEI03 cAHEI03 cAHEI07 cAHEI07 cAHEI11 cAHEI11 cAHEI15 cAHEI15 cAHEI15;



* Intermediate endpoints ;
array diaba {*} db91 db93 db95 db97 db99 db01 db03 db05 db07 db09 db11 db13 db15 db17 db19; 
array mia {*}  mi91 mi93 mi95 mi97 mi99 mi01 mi03 mi05 mi07 mi09 mi11 mi13 mi15 mi17 mi19;
array stra {*}      str91 str93 str95 str97 str99 str01 str03 str05 str07 str09 str11 str13 str15 str17 str19;
array cana {*}      can91 can93 can95 can97 can99 can01 can03 can05 can07 can09 can11 can13 can15 can17 can19;

array anga {*}      ang91 ang93 ang95 ang97 ang99 ang01 ang03 ang05 ang07 ang09 ang11 ang13 ang15 ang17 ang19;
array hichola{*} chol91 chol93 chol95 chol97 chol99 chol01 chol03 chol05 chol07 chol09 chol11 chol13 chol15 chol17 chol19;
array hbpa {*}      hbp91 hbp93 hbp95 hbp97 hbp99 hbp01 hbp03 hbp05 hbp07 hbp09 hbp11 hbp13 hbp15 hbp17 hbp19;
array cabga{*}      XXXX XXXX cabg95 cabg97 cabg99 cabg01 cabg03 cabg05 cabg07 cabg09 cabg11 cabg13 cabg15 cabg17 cabg19;
array tiaa {*}      str91 str93 str95 str97 str99 str01 str03 tia05 tia07 tia09 tia11 tia13 tia15 tia17 tia19;

array interma {*} interm91 interm93 interm95 interm97 interm99 interm01 interm03 interm05 interm07 interm09 interm11 interm13 interm15 interm17 interm19; 

     if db89=1 then db91=1;
     if mi89=1 then mi91=1;
     if str89=1 then str91=1;
     if can89=1 then can91=1;

     if chol89=1 then chol91=1;
     if hbp89=1 then hbp91=1;

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
          end;
          if anga{i}=1 | hichola{i}=1 | hbpa{i}=1 | cabga{i}=1 | tiaa{i}=1 then interma{i}=1;
          else interma{i}=0;
     end;


* SES ;
array sesa{*} nsescav91 nsescav93 nsescav95 nsescav97 nsescav99 nsescav01 nsescav03 nsescav05 nsescav07 nsescav09 nsescav11 nsescav13 nsescav13 nsescav13 nsescav13;


* physical examine for screening purpose ;
array pscexama {*} psexam89 psexam89 psexam89 psexam89 psexam89 psexam01 psexam03 psexam05 psexam07 psexam09 psexam11 psexam13 psexam15 psexam17 psexam19;

/* 0=no, 1=for symptoms, 2=for screening */
  do i=2 to dim(pscexama);
   if pscexama{i}=. then pscexama{i}=pscexama{i-1};
  end;


  do i=1 to dim(pscexama);
    if pscexama{i} in (.,0,1) then pscexama{i}=0; 
    else if pscexama{i}=2 then pscexama{i}=1;    /* code screening for symptom as 1 */
  end;




* family history of db;
dbfh=0;
if fmdiab89=1 or fmdiab97=1 or fmdiab01=1 or fmdiab05=1 or fmdiab09=1 or fmdiab13=1 then dbfh=1; else dbfh=0;


* family history of MI ; 
mifh=0;
if fmcvd89=1 or fmcvd93=1 or fmcvd97=1 or fmcvd01=1 or fmcvd05=1 or fmcvd09=1 or fmcvd13=1 then mifh=1;


* family history of cancer ; 
canfh=0;
if cafh89=1 or cafh93=1 or cafh97=1 or cafh01=1 or cafh05=1 or cafh09=1 or cafh13=1 then canfh=1;



* endo history ;

array endo {*} endo91 endo93 endo95 endo97 endo99 endo01 endo03 endo05 endo07 endo09 endo11 endo13 endo15 endo17 endo17;

do i=2 to dim(endo);
   if endo{i}=. then endo{i}=endo{i-1};
end;



* Multivitamin;
array mvyna{*} mvyn91 mvyn93 mvyn95 mvyn97 mvyn99 mvyn01 mvyn03 mvyn05 mvyn07 mvyn09 mvyn11 mvyn13 mvyn15 mvyn15 mvyn15;







* ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo; 
* Physical activity: cumulative average
* ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo; 

/* MET-hour/week */
totalpa89mv = mean(totalpa89m);
totalpa91mv = mean(totalpa89m, totalpa91m);
totalpa93mv = mean(totalpa89m, totalpa91m, totalpa91m);
totalpa95mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m);
totalpa97mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m);
totalpa99mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m);
totalpa01mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m);
totalpa03mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m, totalpa01m);
totalpa05mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m, totalpa01m, totalpa05m);
totalpa07mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m, totalpa01m, totalpa05m, totalpa05m);
totalpa09mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m, totalpa01m, totalpa05m, totalpa05m, totalpa09m);
totalpa11mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m, totalpa01m, totalpa05m, totalpa05m, totalpa09m, totalpa09m);
totalpa13mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m, totalpa01m, totalpa05m, totalpa05m, totalpa09m, totalpa09m, totalpa13m);
totalpa15mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m, totalpa01m, totalpa05m, totalpa05m, totalpa09m, totalpa09m, totalpa13m, totalpa13m);
totalpa17mv = mean(totalpa89m, totalpa91m, totalpa91m, totalpa91m, totalpa97m, totalpa97m, totalpa01m, totalpa01m, totalpa05m, totalpa05m, totalpa09m, totalpa09m, totalpa13m, totalpa13m, totalpa17m);


/* total PA, cumulative average, 2-year lag */
 array totalpav2laga {15} totalpa89mv totalpa91mv totalpa93mv totalpa95mv totalpa97mv totalpa99mv totalpa01mv totalpa03mv totalpa05mv totalpa07mv totalpa09mv totalpa11mv totalpa13mv totalpa15mv totalpa17mv ;
 
/* total PA, cumulative average, 4-year lag */
 array totalpav4laga {15} totalpa89mv totalpa89mv totalpa91mv totalpa93mv totalpa95mv totalpa97mv totalpa99mv totalpa01mv totalpa03mv totalpa05mv totalpa07mv totalpa09mv totalpa11mv totalpa13mv totalpa15mv  ;
 
/* total PA, cumulative average, 8-year lag */
 array totalpav8laga {15} totalpa89mv totalpa89mv totalpa89mv totalpa89mv totalpa91mv totalpa93mv totalpa95mv totalpa97mv totalpa99mv totalpa01mv totalpa03mv totalpa05mv totalpa07mv totalpa09mv totalpa11mv    ;
 
/* total PA, cumulative average, 12-year lag */
 array totalpav12laga {15} totalpa89mv totalpa89mv totalpa89mv totalpa89mv totalpa89mv totalpa89mv totalpa91mv totalpa93mv totalpa95mv totalpa97mv totalpa99mv totalpa01mv totalpa03mv totalpa05mv totalpa07mv      ;
 


/* percentage of times meeting guideline, 2-year lag */
 array pctmeet2laga {15}  pctmeet89 pctmeet91 pctmeet91 pctmeet91 pctmeet97 pctmeet97 pctmeet01 pctmeet01 pctmeet05 pctmeet05 pctmeet09 pctmeet09 pctmeet13 pctmeet13 pctmeet17;
 array pctmeett2laga {15}  pctmeett89 pctmeett91 pctmeett91 pctmeett91 pctmeett97 pctmeett97 pctmeett01 pctmeett01 pctmeett05 pctmeett05 pctmeett09 pctmeett09 pctmeett13 pctmeett13 pctmeett17;
 array pctmeettt2laga {15}  pctmeettt89 pctmeettt91 pctmeettt91 pctmeettt91 pctmeettt97 pctmeettt97 pctmeettt01 pctmeettt01 pctmeettt05 pctmeettt05 pctmeettt09 pctmeettt09 pctmeettt13 pctmeettt13 pctmeettt17;

/* percentage of times meeting guideline, 4-year lag */
 array pctmeet4laga {15}  pctmeet89 pctmeet89 pctmeet91 pctmeet91 pctmeet91 pctmeet97 pctmeet97 pctmeet01 pctmeet01 pctmeet05 pctmeet05 pctmeet09 pctmeet09 pctmeet13 pctmeet13 ;
 array pctmeett4laga {15}  pctmeett89 pctmeett89 pctmeett91 pctmeett91 pctmeett91 pctmeett97 pctmeett97 pctmeett01 pctmeett01 pctmeett05 pctmeett05 pctmeett09 pctmeett09 pctmeett13 pctmeett13 ;
 array pctmeettt4laga {15}  pctmeettt89 pctmeettt89 pctmeettt91 pctmeettt91 pctmeettt91 pctmeettt97 pctmeettt97 pctmeettt01 pctmeettt01 pctmeettt05 pctmeettt05 pctmeettt09 pctmeettt09 pctmeettt13 pctmeettt13 ;


/* percentage of times meeting guideline, 8-year lag */
 array pctmeet8laga {15}  pctmeet89 pctmeet89 pctmeet89 pctmeet89 pctmeet91 pctmeet91 pctmeet91 pctmeet97 pctmeet97 pctmeet01 pctmeet01 pctmeet05 pctmeet05 pctmeet09 pctmeet09   ;
 array pctmeett8laga {15}  pctmeett89 pctmeett89 pctmeett89 pctmeett89 pctmeett91 pctmeett91 pctmeett91 pctmeett97 pctmeett97 pctmeett01 pctmeett01 pctmeett05 pctmeett05 pctmeett09 pctmeett09   ;
 array pctmeettt8laga {15}  pctmeettt89 pctmeettt89 pctmeettt89 pctmeettt89 pctmeettt91 pctmeettt91 pctmeettt91 pctmeettt97 pctmeettt97 pctmeettt01 pctmeettt01 pctmeettt05 pctmeettt05 pctmeettt09 pctmeettt09   ;


/* percentage of times meeting guideline, 12-year lag */
 array pctmeet12laga {15}  pctmeet89 pctmeet89 pctmeet89 pctmeet89 pctmeet89 pctmeet89 pctmeet91 pctmeet91 pctmeet91 pctmeet97 pctmeet97 pctmeet01 pctmeet01 pctmeet05 pctmeet05     ;
 array pctmeett12laga {15}  pctmeett89 pctmeett89 pctmeett89 pctmeett89 pctmeett89 pctmeett89 pctmeett91 pctmeett91 pctmeett91 pctmeett97 pctmeett97 pctmeett01 pctmeett01 pctmeett05 pctmeett05     ;
 array pctmeettt12laga {15}  pctmeettt89 pctmeettt89 pctmeettt89 pctmeettt89 pctmeettt89 pctmeettt89 pctmeettt91 pctmeettt91 pctmeettt91 pctmeettt97 pctmeettt97 pctmeettt01 pctmeettt01 pctmeettt05 pctmeettt05     ;


 /* number of times reported PA questionnaire, 2-year lag */
 array treporta {15} treport89 treport91 treport91 treport91 treport97 treport97 treport01 treport01 treport05 treport05 treport09 treport09 treport13 treport13 treport17;





