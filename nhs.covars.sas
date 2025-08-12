/*********************************************************************************************************
Project: Association of consistent reaching PA target with mortality

Created: Apr 2025

Purpose: To read in variables

Study Design: Prospective cohort study

Cohort follow-up period: NHS 1986-2020, with 2-year lag, actual follow-up 1988-2020

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

%include '/udd/hpyzh/pa_consist/nhs/nhs_pa.sas';
proc sort nodupkey data=nhs_pa_met; by id; run;


/* Read in SES */
%include '/udd/hpyzh/proj_data/nhs/SES_nhs.sas';
proc sort nodupkey data=nses7616;by id;run;


/* READ IN DIET AND NUTRIENT VARAIBLES */
%n80_nts(keep=id alco80n calor80n);
%n84_nts(keep=id alco84n calor84n);
%n86_nts(keep=id alco86n calor86n);
%n90_nts(keep=id alco90n calor90n);
%n94_nts(keep=id alco94n calor94n);
%n98_nts(keep=id alco98n calor98n);
%n02_nts(keep=id alco02n calor02n);
%n06_nts(keep=id alco06n calor06n);
%n10_nts(keep=id alco10n calor10n);



%ahei2010_8410(keep=ahei2010_84 ahei2010_86 ahei2010_90 ahei2010_94 ahei2010_98 ahei2010_02 ahei2010_06 ahei2010_10);

data nhs_ahei;
     set ahei2010_8410;
nAHEI84=ahei2010_84;
nAHEI86=ahei2010_86;
nAHEI90=ahei2010_90;
nAHEI94=ahei2010_94;
nAHEI98=ahei2010_98;
nAHEI02=ahei2010_02;  
nAHEI06=ahei2010_06;
nAHEI10=ahei2010_10;
 keep id nAHEI84 nAHEI86 nAHEI90 nAHEI94 nAHEI98 nAHEI02 nAHEI06 nAHEI10;
run;


/* read in alcohol type */
%include '/udd/hpyzh/pa_consist/nhs/nhs.alcohol.sas';
proc sort nodupkey data=nhs_alcohol;by id;run;


/* endoscopy */
%include '/udd/hpyzh/pa_consist/nhs/nhs_endo.sas';
proc sort nodupkey data=nhs_sigmoid;by id;run;



/***************************** READ IN DEATH AND DISEASE FILES ************************/

/* Breast cancer - to code pre/post menopausal breast cancer */
data brca;
%include '/proj/nhdats/nh_dat_cdx/endpoints/breast/br7620.040921.cases.input';
if 11<=conf<=19  then brca_ca=1;
if brca_ca=1 then dt_brca=dxmonth;
if brca_ca=1 and era_results=1 then er_status=1;
if brca_ca=1 and pra_results=1 then pr_status=1; 
dtdxca3=dt_brca;

keep id brca_ca er_status pr_status dt_brca dtdxca3;
run;
proc sort nodupkey; by id; run;


%der7620(keep=amnp mobf yobf
              namnp76 namnp78 namnp80 namnp82 namnp84 namnp86 namnp88 namnp90 namnp92 namnp94 namnp96 namnp98 namnp00 namnp02 namnp04
              age76 age78 age80 age82 age84 age86 age88 age90 age92 age94 age96 age98 age00 age02 age04 age06 age08 age10 age12 age14 age16
              smkdr76 smkdr78 smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14 smkdr16);
array namnp{*} namnp76 namnp78 namnp80 namnp82 namnp84 namnp86 namnp88 namnp90 namnp92 namnp94 namnp96 namnp98 namnp00 namnp02 namnp04;
amnp = .;
do i=1 to dim(namnp);
if .<namnp{i}<95 & amnp=. then amnp=namnp{i};
end;
run;

data brca;
merge der7620 brca(in=a);
by id;
if a=1;

if mobf<=0 or mobf>12 then mobf=6;if yobf>20 then birthday=yobf*12+mobf; else birthday=.;
age_dx = ( dt_brca - birthday )/12;

array age{*} age76 age78 age80 age82 age84 age86 age88 age90 age92 age94 age96 age98 age00 age02 age04 age06 age08 age10 age12 age14 age16;
array smkdr{*} smkdr76 smkdr78 smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14 smkdr16;

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
%deadff(keep=deadmonth dtdth nhsicda dead_injury newicda, file=/proj/nhdats/nh_dat_cdx/deaths/deadff.current.nhs1);

   if deadmonth > 0 then dtdth=deadmonth;

*nhsicda = compress (nhsicda,'E');
if substr(nhsicda,1,1) = 'E' then dead_injury = 1;
if substr(nhsicda,1,1) not eq 'E' then newicda=input(substr(nhsicda,1,3),3.);

run;
proc sort; by id; 
run;


data deadff;
     merge deadff(in=a) brca der7620;
     by id;
     if a;


if deadmonth>0 then dead_all=1;


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


* code premenopausal/postmenopausal BC death *;
if mobf<=0 or mobf>12 then mobf=6;if yobf>20 then birthday=yobf*12+mobf; else birthday=.;
aged = ( dtdth - birthday )/12;

array age{*} age76 age78 age80 age82 age84 age86 age88 age90 age92 age94 age96 age98 age00 age02 age04 age06 age08 age10 age12 age14 age16;
array smkdr{*} smkdr76 smkdr78 smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14 smkdr16;

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
if dead_injury eq 1 or dead_suicide eq 1 then dead_traumatic=1;

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
%der7620(keep=mobf yobf race9204 mrace9204 eth9204 bmiage18
          irt76 irt78 irt80 irt82 irt84 irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt20
          bmi76 bmi78 bmi80 bmi82 bmi84 bmi86 bmi88 bmi90 bmi92 bmi94 bmi96 bmi98 bmi00 bmi02 bmi04 bmi06 bmi08 bmi10 bmi12 bmi14 bmi16 bmi20
          smkdr76 smkdr78 smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14 smkdr16 smkdr20
          msqui76 msqui78 msqui80 msqui82 msqui84 msqui86 msqui88 msqui90 msqui92 msqui94 msqui96 msqui98 msqui00 msqui02 msqui04 msqui06 msqui08 msqui10 msqui12 msqui14 msqui16 msqui20
          pkyr76 pkyr78 pkyr80 pkyr82 pkyr84 pkyr86 pkyr88 pkyr90 pkyr92 pkyr94 pkyr96 pkyr98 pkyr00 pkyr02 pkyr04 pkyr06 pkyr08 pkyr10 pkyr12 pkyr14 pkyr16 pkyr20
          can76 can78 can80 can82 can84 can86 can88 can90 can92 can94 can96 can98 can00 can02 can04 can06 can08 can10 can12 can14 can16 can20
          namnp76 namnp78 namnp80 namnp82 namnp84 namnp86 namnp88 namnp90 namnp92 namnp94 namnp96 namnp98 namnp00 namnp02 namnp04
          dmnp76 dmnp78 dmnp80 dmnp82 dmnp84 dmnp86 dmnp88 dmnp90 dmnp92 dmnp94 dmnp96 dmnp98 dmnp00 dmnp02 dmnp04
          nhor76 nhor78 nhor80 nhor82 nhor84 nhor86 nhor88 nhor90 nhor92 nhor94 nhor96 nhor98 nhor00 nhor02 nhor04 nhor06 nhor08 nhor10 nhor12 nhor14 nhor16 nhor20
          hrt76 hrt78 hrt80 hrt82 hrt84 hrt86 hrt88 hrt90 hrt92 hrt94 hrt96 hrt98 hrt00 hrt02 hrt04 hrt06 hrt08 hrt10 hrt12 hrt14 hrt16 hrt20
     );
run;
proc sort nodupkey;by id;run;


%n767880(keep=wt18 ht76 wt76 wt78 wt80 
                 hbp76 hbp78 hbp80 db76 db78 db80 chol76 chol78 chol80 mi76 mi78 mi80 ang76 ang78 ang80 
                 mbrcn76 nsbrc76 cafh76 doctor psexam80
                 mmi76 fmi76 fmcvd76); 
     array temp hbp76 hbp78 hbp80 db76 db78 db80 chol76 chol78 chol80 mi76 mi78 mi80 ang76 ang78 ang80;
    do over temp;if temp in (.,2,5) then temp=0;end;
     if mbrcn76=1 or nsbrc76>0 then cafh76=1; else cafh76=0;
     if doctor=1 then psexam80=2;
     if mmi76=1 or fmi76=1 then fmcvd76=1;
run;



%nur82(keep=wt82 hbp82 db82 chol82 mi82 ang82 str82 ra82 oa82 artri82 
     mclc82 fclc82 sclc82 bclc82 mbrcn82 sbrcn82 mmel82 fmel82 smel82 fmclc82 cafh82 ucol82
     mdb82 fdb82 sdb82 bdb82 dbfh82); 
if ra82=1 or oa82=1 then artri82=1;else artri82=0;
if mclc82=1 or fclc82=1 or sclc82=1 or bclc82=1 then fmclc82=1;else fmclc82=0; * CRC fhx;
cafh82=0; if mclc82=1 or fclc82=1 or sclc82=1 or bclc82=1 or mbrcn82=1 or sbrcn82=1 or mmel82=1 or fmel82=1 or smel82=1 then cafh82=1; * cancer fhx;
if fdb82=1 or mdb82=1 or sdb82=1 or bdb82=1 then dbfh82=1; else dbfh82=0;
run; 

%nur84(keep=wt84 hbp84 db84 chol84 mi84 ang84 str84 cabg84 ra84 oa84 artri84 ucol84 fmi84 mmi84 fmcvd84 mmi84f fmi84f); 
array dis hbp84 db84 chol84 mi84 ang84 str84 cabg84 ra84 oa84 ucol84;
     do over dis;if dis in (0,1) then dis=0;else if dis=2 then dis=1;end;
if ra84=1 or oa84=1 then artri84=1;else artri84=0;
if fmi84=2 or mmi84=2 then fmcvd84=1;

if mmi84=2 then mmi84f=1; else mmi84f=0;
if fmi84=2 then fmi84f=1; else fmi84f=0;

run;

%nur86(keep=wt86 hbp86 db86 chol86 mi86 ang86 str86 cabg86 ra86 oa86 artri86 ucol86 q986pt);
if ra86=1 or oa86=1 then artri86=1;else artri86=0;
run;

%nur88(keep=wt88 hbp88 db88 chol88 mi88 ang88 str88 cabg88 ra88 oa88 artri88 physx88 psexam88 
     mclc88 fclc88 sclc88 bclc88 mbrcn88 sbrcn88 mcanc88 fcanc88 fmclc88 cafh88
     mdb88 fdb88 bdb88 sdb88 dbfh88);
if ra88=1 or oa88=1 then artri88=1;else artri88=0;
if physx88=2 then psexam88=1;else if physx88=3 then psexam88=2;else psexam88=0; * 1=symptoms, 2=screening, 0=no;
fmclc88=0; if mclc88=1 or fclc88=1 or sclc88=1 or bclc88=1 then fmclc88=1;
cafh88=0; if mclc88=1 or fclc88=1 or sclc88=1 or bclc88=1 or mbrcn88=1 or sbrcn88=1 or mcanc88=1 or fcanc88=1 then cafh88=1;
if fdb88=1 or mdb88=1 or sdb88=1 or bdb88=1 then dbfh88=1; else dbfh88=0; 
run;

%nur90(keep=wt90 hbp90 db90 chol90 mi90 ang90 str90 cabg90 ra90 oa90 artri90 physx90 psexam90 tia90 cart90);
     if ra90=1 or oa90=1 then artri90=1;else artri90=0;
     if physx90=3 then psexam90=1; else if physx90=2 then psexam90=2;else psexam90=0;
run; 

%nur92(keep=wt92 hbp92 db92 chol92 mi92 ang92 str92 cabg92 ra92 oa92 artri92 ucol92 physx92 psexam92 
     mcolc92 fcolc92 scolc92 mbrcn92 mov92 sbrcn92 sov92 mmel92 fmel92 fmclc92 cafh92
     fdb92 mdb92 sdb92 dbfh92 tia92 cart92
     seuro92 scand92 ocauc92 afric92 hisp92 asian92 nativ92 oanc92);
fmclc92=0; if mcolc92=1 or fcolc92=1 or scolc92=1 then fmclc92=1;
cafh92=0; if sum(mbrcn92, mov92, mcolc92, fcolc92, sbrcn92, sov92, scolc92, mmel92, fmel92)>0 then cafh92=1;
if physx92=3 then psexam92=1;else if physx92=2 then psexam92=2; else psexam92=0;
if ra92=1 or oa92=1 then artri92=1;else artri92=0;
if fdb92=1 or mdb92=1 or sdb92=1 then dbfh92=1;else dbfh92=0; 
run; 

%nur94(keep=wt94 hbp94 db94 chol94 mi94 ang94 str94 cabg94 ucol94 physx94 psexam94 tia94 cart94);
if physx94=3 then psexam94=1;else if physx94=2 then psexam94=2;else psexam94=0;
run;

%nur96(keep=wt96 hbp96 db96 chol96 mi96 ang96 str96 cabg96 oa96 ra96 artri96 ucol96 physc96 physy96 psexam96
     fdcan96 mdcan96 pclc96 sclc196 sclc296 fmclc96 sbrc196 sbrc296 mbrcn96 mov96 sov96 mut96 sut96 fpro96 bpro196 bpro296 ppan96 spand96 pmel96 smel96 cafh96
     fdchd96 fdstr96 mdchd96 mdstr96 fmcvd96 tia96 cart96);
fmclc96=0; if pclc96=1 or sclc196=1 or sclc296=1 then fmclc96=1;
cafh96=0; if sum(fdcan96,mdcan96,pclc96,sclc196,sclc296,sbrc196,sbrc296,mbrcn96,mov96,sov96,mut96,sut96,fpro96,bpro196,bpro296,ppan96,spand96,pmel96,smel96)>0 then cafh96=1;
if ra96=1 or oa96=1 then artri96=1;else artri96=0;
if physc96=1 then psexam96=2;if physy96=1 then psexam96=1; else psexam96=0;
if fdchd96=1 or fdstr96=1 or mdchd96=1 or mdstr96=1 then fmcvd96=1;
run;  

%nur98(keep=wt98 hbp98 db98 chol98 mi98 ang98 str98 cabg98 ucol98 physc98 physy98 psexam98 tia98 cart98);
if physc98=1 then psexam98=2;if physy98=1 then psexam98=1;else psexam98=0;
run;

%nur00(keep=wt00 hbp00 db00 chol00 mi00 ang00 str00 cabg00 ra00 oa00 artri00 ucol00 physc00 physy00 psexam00 
     pclc00 sclc100 sclc200 mbrcn00 sbrc100 sbrc200 ppan00 span00 mov00 sov00 plng00 slng00 pmel00 smel00 fmclc00 cafh00 tia00 cart00 q35pt00);
if physc00=1 then psexam00=2;else if physy00=1 then psexam00=1;else psexam00=0;
fmclc00=0; if pclc00=1 or sclc100=1 or sclc200=1 then fmclc00=1;
cafh00=0; if sum(pclc00, sclc100, sclc200,mbrcn00,sbrc100,sbrc200,ppan00,span00,mov00,sov00,plng00,slng00,pmel00,smel00)>0 then cafh00=1;
if ra00=1 or oa00=1 then artri00=1;else artri00=0;
run; 

%nur02(keep=wt02 hbp02 db02 chol02 mi02 ang02 str02 cabg02 ra02 artri02 physc02 physy02 psexam02 tia02 cart02);
if physc02=1 then psexam02=2;else if physy02=1 then psexam02=1;else psexam02=0;
if ra02=1 then artri02=1;else artri02=0;
run;

%nur04(keep=wt04 hbp04 db04 chol04 mi04 ang04 str04 cabg04 ra04 oa04 artri04 ucol04 physc04 physy04 psexam04 
     cafh04 pclc04 sclc104 sclc204 mbrcn04 sbrc104 sbrc204 dbrcn04 mov04 sov04 dov04 fmclc04 tia04 cart04
     afric04 hisp04 asian04 white04);
if physc04=1 then psexam04=2;else if physy04=1 then psexam04=1; else psexam04=0;
fmclc04=0; if pclc04=1 or sclc104=1 or sclc204=1 then fmclc04=1;
cafh04=0; if pclc04=1 or sclc104=1 or sclc204=1 or mbrcn04=1 or sbrc104=1 or sbrc204=1 or dbrcn04=1 or mov04=1 or sov04=1 or dov04=1 then cafh04=1;
if ra04=1 or oa04=1 then artri04=1;else artri04=0;
run;

%nur06(keep=wt06 hbp06 db06 chol06 mi06 ang06 str06 cabg06 ra06 artri06 ucol06 physc06 physy06 psexam06 tia06 cart06);
if physc06=1 then psexam06=2;else if physy06=1 then psexam06=1; else psexam06=0;
if ra06=1 then artri06=1;else artri06=0;
run;

%nur08(keep=wt08 hbp08 db08 chol08 mi08 ang08 str08 cabg08 oa08 ra08 artri08 ucol08 physc08 physy08 psexam08 
     sclc108 sclc208 sbrc108 sbrc208 dbrcn08 mov08 sov08 dov08 ppan08 span08 pmel08 smel08 omel08 mut08 sut08 out08 pkdc08 skidc08 fmclc08 cafh08
     mstr08 fstr08 sstr08 fmcvd08 tia08 cart08);
if physc08=1 then psexam08=2;else if physy08=1 then psexam08=1;else psexam08=0;
if oa08=1 or ra08=1 then artri08=1; else artri08=0;
if sclc108=1 or sclc208=1 then fmclc08=1; else fmclc08=0;
cafh08=0; if sclc108=1 or sclc208=1 or sbrc108=1 or  sbrc208=1 or  dbrcn08=1 or  mov08=1 or  sov08=1 or  dov08=1 or  ppan08=1 or  span08=1 or  pmel08=1 or  smel08=1 or  omel08=1 or mut08=1 or  sut08=1 or  out08=1 or  pkdc08=1 or  skidc08=1 then cafh08=1;
if mstr08=1 or fstr08=1 or sstr08=1 then fmcvd08=1;
run;

%nur10(keep=wt10 hbp10 db10 chol10 mi10 ang10 str10 cabg10 ra10 oa10 artri10 ucol10 physc10 physy10 psexam10 tia10 cart10);
if physc10=1 then psexam10=2;else if physy10=1 then psexam10=1;else psexam10=0;
if ra10=1 or oa10=1 then artri10=1;else artri10=0;
run;

%nur12(keep=wt12 hbp12 db12 chol12 mi12 ang12 str12 cabg12 ra12 oa12 artri12 ucol12 physc12 physy12 psexam12 sbrcn12 sov12 cafh12 tia12 cart12);
if physc12=1 then psexam12=2;else if physy12=1 then psexam12=1; else psexam12=0;
cafh12=0; if sbrcn12=1 or sov12=1 then cafh12=1;
if ra12=1 or oa12=1 then artri12=1;else artri12=0;
run;

%nur14(keep=wt14 hbp14 db14 chol14 mi14 ang14 str14 cabg14 ra14 artri14 ucol14 physc14 physy14 psexam14 tia14 cart14);
if physc14=1 then psexam14=2;else if physy14=1 then psexam14=1;else psexam14=0;
if ra14=1 then artri14=1;else artri14=0;
run; 

%nur16(keep=wt16 hbp16 db16 chol16 mi16 ang16 str16 cabg16 ost16 artri16 ucol16 physc16 physy16 psexam16 tia16 cart16);
if physc16=1 then psexam16=2;else if physy16=1 then psexam16=1;else psexam16=0;
if ost16=1 then artri16=1;else artri16=0;
run; 

%nur20(keep=wt20 hbp20 db20 chol20 mi20 ang20 str20 cabg20 ost20 artri20 ucol20 physc20 physy20 psexam20 tia20 cart20);
if physc20=1 then psexam20=2;else if physy20=1 then psexam20=1;else psexam20=0;
if ost20=1 then artri20=1;else artri20=0;
run; 




%supp8020(keep=mvitu80 mvitu82 mvitu84 mvitu86 mvitu86 mvitu88 mvitu90 mvitu92 mvitu94 mvitu96 mvitu98 mvitu00 mvitu02 mvitu04 mvitu06 mvitu08 mvitu10 mvitu12 mvitu14 mvitu16 mvitu20);
 /* Label multivitamin use   $label 0.nonuser;\   1.current user;\   9.unknown status */ 


/********************************* Merge datasets ***************************/
data nhs_data;
     merge nhs_pa_met deadff nses7616 nhs_alcohol nhs_sigmoid 
           der7620(in=mstr) nhs_ahei
           n767880 nur82 nur84 nur86 nur88 nur90 nur92 nur94 nur96 nur98 nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nur16 nur20 supp8020
           n80_nts n84_nts n86_nts n90_nts n94_nts n98_nts n02_nts n06_nts n10_nts 
     end=_end_;

     by id;
     exrec=1;
     if first.id and mstr then exrec=0; 
run;

proc datasets nolist;
 delete   deadff nses7616
           der7620 nhs_ahei
           n767880 nur82 nur84 nur86 nur88 nur90 nur92 nur94 nur96 nur98 nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nur16 nur20 supp8020
           n84_nts n86_nts n90_nts n94_nts n98_nts n02_nts n06_nts n10_nts;
run;


data nhs_data;
  set nhs_data end=_end_;

* cohort indicator ;  
  cohort=2; 


  cutoff=1458;   /* set cutoff to 2021.6  */ 

* Questionnaire return ;
/***** 
Correct dates using the standard sample codes 
https://docs.google.com/document/d/1k476ZHU96qkylX-RiLzFPPozrGEJR1GbhjoV1_IuzQ4/edit?tab=t.0
******/

array irta {21}  irt80 irt82 irt84 irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt20 cutoff;

/* From 1980 to 2016*/
do i=1 to 19;
if irta{i}<942+(24*i) or irta{i}>=966+(24*i) then irta{i}=942+(24*i);
end;

/* From 2000 onwards: use dates synced to NHS2 questionnaire dates*/
do i=20 to 20;
if irta{i}<954+(24*i) or irta{i}>=978+(24*i) then irta{i}=954+(24*i);
end;





/***** Set up date array that suit my program  ******/
* add 2018 cycle to later conduct pooled analysis with HPFS ;

irt18=1422; *add 2018 cycle ;

array tvar {*} t84 t86 t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18 t20; 
array irt  {*} irt84 irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 irt20 cutoff; 
array period {19} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11 period12 period13 period14 period15 period16 period17 period18 period19;


* Birthday ;
     if mobf<=0 or mobf>12 then mobf=6;if yobf>20 then birthday=yobf*12+mobf; else birthday=.;

* race; 
     if race9204=1 then white=1; else white=0;


* Age ;
array agemoa {*} agemo84 agemo86 agemo88 agemo90 agemo92 agemo94 agemo96 agemo98 agemo00 agemo02 agemo04 agemo06 agemo08 agemo10 agemo12 agemo14 agemo16 agemo18 agemo20;  
array agea {*} age84 age86 age88 age90 age92 age94 age96 age98 age00 age02 age04 age06 age08 age10 age12 age14 age16 age18 age20; 
array agega {*} ageg84 ageg86 ageg88 ageg90 ageg92 ageg94 ageg96 ageg98 ageg00 ageg02 ageg04 ageg06 ageg08 ageg10 ageg12 ageg14 ageg16 ageg18 ageg20; 

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
array bmia{*} bmi84 bmi86 bmi88 bmi90 bmi92 bmi94 bmi96 bmi98 bmi00 bmi02 bmi04 bmi06 bmi08 bmi10 bmi12 bmi14 bmi16 bmi16 bmi20;
array bmicuma{*} bmicum84 bmicum86 bmicum88 bmicum90 bmicum92 bmicum94 bmicum96 bmicum98 bmicum00 bmicum02 bmicum04 bmicum06 bmicum08 bmicum10 bmicum12 bmicum14 bmicum16 bmicum16 bmicum20;
array bmiga{*} bmig84 bmig86 bmig88 bmig90 bmig92 bmig94 bmig96 bmig98 bmig00 bmig02 bmig04 bmig06 bmig08 bmig10 bmig12 bmig14 bmig16 bmig16 bmig20;

     if bmi76 lt 10 then bmi76=.;
     if bmi78 lt 10 then bmi78=.;
     if bmi80 lt 10 then bmi80=.;
     if bmi82 lt 10 then bmi82=.;

    do i=1 to dim(bmia);
        if bmia{i}<10 then bmia{i}=.;
    end;

     bmicum84=mean(bmi76,bmi78,bmi80,bmi82,bmi84);
     bmicum86=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86);
     bmicum88=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88);
     bmicum90=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90);
     bmicum92=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92);
     bmicum94=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94);
     bmicum96=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96);
     bmicum98=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98);
     bmicum00=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00);
     bmicum02=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02);
     bmicum04=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04);
     bmicum06=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06);
     bmicum08=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08);
     bmicum10=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10);
     bmicum12=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12);
     bmicum14=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14);
     bmicum16=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14, bmi16);
     bmicum20=mean(bmi76,bmi78,bmi80,bmi82,bmi84,bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14, bmi16, bmi20);


     if bmi78 eq . & bmi76 gt . then bmi78 = bmi76;
     if bmi80 eq . & bmi78 gt . then bmi80 = bmi78;
     if bmi82 eq . & bmi80 gt . then bmi82 = bmi80;
     if bmi84 eq . & bmi82 gt . then bmi84 = bmi82;

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



* smoking; 

array smkdra {*} smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14 smkdr16 smkdr16 smkdr20; 
array msquia {*} msqui84 msqui86 msqui88 msqui90 msqui92 msqui94 msqui96 msqui98 msqui00 msqui02 msqui04 msqui06 msqui08 msqui10 msqui12 msqui14 msqui16 msqui16 msqui20; 
array pkyra {*} pkyr84 pkyr86 pkyr88 pkyr90 pkyr92 pkyr94 pkyr96 pkyr98 pkyr00 pkyr02 pkyr04 pkyr06 pkyr08 pkyr10 pkyr12 pkyr14 pkyr16 pkyr16 pkyr20; 
array smk3ga {*} smkstatus84 smkstatus86 smkstatus88 smkstatus90 smkstatus92 smkstatus94 smkstatus96 smkstatus98 smkstatus00 smkstatus02 smkstatus04 smkstatus06 smkstatus08 smkstatus10 smkstatus12 smkstatus14 smkstatus16 smkstatus16 smkstatus20; 
array cigga {*} cigg84 cigg86 cigg88 cigg90 cigg92 cigg94 cigg96 cigg98 cigg00 cigg02 cigg04 cigg06 cigg08 cigg10 cigg12 cigg14 cigg16 cigg16 cigg20; 
array pkyrga {*} pkyrg84 pkyrg86 pkyrg88 pkyrg90 pkyrg92 pkyrg94 pkyrg96 pkyrg98 pkyrg00 pkyrg02 pkyrg04 pkyrg06 pkyrg08 pkyrg10 pkyrg12 pkyrg14 pkyrg16 pkyrg16 pkyrg20; 

     if smkdr78=0 & smkdr76^=0 then smkdr78=smkdr76;
     if smkdr80=0 & smkdr78^=0 then smkdr80=smkdr78;
     if smkdr82=0 & smkdr80^=0 then smkdr82=smkdr80;
     if smkdr84=0 & smkdr82^=0 then smkdr84=smkdr82;

     if smkdr78=15 & smkdr76 in (9,10,11,12,13,14) then smkdr78=smkdr76;
     if smkdr80=15 & smkdr78 in (9,10,11,12,13,14) then smkdr80=smkdr78;
     if smkdr82=15 & smkdr80 in (9,10,11,12,13,14) then smkdr82=smkdr80;
     if smkdr84=15 & smkdr82 in (9,10,11,12,13,14) then smkdr84=smkdr82;

     if msqui78=999 & msqui76^=999 then msqui78=msqui76;
     if msqui80=999 & msqui78^=999 then msqui80=msqui78;
     if msqui82=999 & msqui80^=999 then msqui82=msqui80;
     if msqui84=999 & msqui82^=999 then msqui84=msqui82;

     if msqui78=995 & 0 lt msqui76 lt 777 then msqui78=msqui76;
     if msqui80=995 & 0 lt msqui78 lt 777 then msqui80=msqui78;
     if msqui82=995 & 0 lt msqui80 lt 777 then msqui82=msqui80;
     if msqui84=995 & 0 lt msqui82 lt 777 then msqui84=msqui82;

     if pkyr78=999 & pkyr76^=999 then pkyr78=pkyr76;
     if pkyr80=999 & pkyr78^=999 then pkyr80=pkyr78;
     if pkyr82=999 & pkyr80^=999 then pkyr82=pkyr80;
     if pkyr84=999 & pkyr82^=999 then pkyr84=pkyr82;

     do i=1 to dim(smkdra);
          if smkdra{i}=0 then smkdra{i}=.;
          if msquia{i}=888 then msquia{i}=0;
          if pkyra{i}=998 then pkyra{i}=0;
          if pkyra{i}=999 then pkyra{i}=.;
          if i>1 then do;
               if smkdra{i}=15 & smkdra{i-1} in (9,10,11,12,13,14) then smkdra{i}=smkdra{i-1};
               if smkdra{i}=. & smkdra{i-1}^=. then smkdra{i}=smkdra{i-1};
               if msquia{i} in (995,999) & msquia{i-1} lt 995 then msquia{i}=msquia{i-1};
               if pkyra{i}=0 & pkyra{i-1}^=0 & smkdra{i}^=1 then pkyra{i}=pkyra{i-1};
               if pkyra{i}=. & pkyra{i-1}^=. then pkyra{i}=pkyra{i-1};
          end;

          if smkdra{i} =1 then smk3ga{i}=1; *never;
     else if smkdra{i} in (2,3,4,5,6,7,8) then smk3ga{i}=2; *past;
     else if smkdra{i} in (9,10,11,12,13,14,15) then smk3ga{i}=3; *current;

          if smkdra{i}=1 /*| smkdra{i}=.*/ then cigga{i}=1; * never *;
          else if smkdra{i} in (2,3,4,5,6,7,8) & (120 le msquia{i} lt 777) then cigga{i}=2; * past >=10y *;
          else if smkdra{i} in (2,3,4,5,6,7,8) & (msquia{i} lt 120 | msquia{i} ge 777) then cigga{i}=3; * past <10y *;
          else if smkdra{i} in (9,10,11,12,13,14,15) then cigga{i}=4;
          /*else if smkdra{i} in (9,10) then cigga{i}=4; * current 1-14/d*;
          else if smkdra{i} in (11) then cigga{i}=5; * current 15-24/d*;
          else if smkdra{i} in (12,13,14,15) then cigga{i}=6; * current 25- /d*;*/


          if pkyra{i}<=0 then pkyrga{i}=1;
          else if pkyra{i}<5 then pkyrga{i}=2;
          else if pkyra{i}<15 then pkyrga{i}=3;
          else if pkyra{i}<25 then pkyrga{i}=4;
          else if pkyra{i}>=25 then pkyrga{i}=5;
     end;


* Menopause ;
array dmnpa{*} dmnp84 dmnp86 dmnp88 dmnp90 dmnp92 dmnp94 dmnp96 dmnp98 dmnp00 dmnp02 dmnp04 dmnp04 dmnp04 dmnp04 dmnp04 dmnp04 dmnp04 dmnp04 dmnp04; 
array nhora{*} nhor84 nhor86 nhor88 nhor90 nhor92 nhor94 nhor96 nhor98 nhor00 nhor02 nhor04 nhor06 nhor08 nhor10 nhor12 nhor14 nhor16 nhor16 nhor20; 
array menopa{*} menop84 menop86 menop88 menop90 menop92 menop94 menop96 menop98 menop00 menop02 menop04 menop06 menop08 menop10 menop12 menop14 menop16 menop16 menop20; 
array pmha{*} pmh84 pmh86 pmh88 pmh90 pmh92 pmh94 pmh96 pmh98 pmh00 pmh02 pmh04 pmh06 pmh08 pmh10 pmh12 pmh14 pmh16 pmh16 pmh20; 

     if dmnp76=2 or dmnp78=2 or dmnp80=2 or dmnp82=2 then dmnp84=2; * post;
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

     if dmnp80 in (1,3) or nhor80=1 then pmh80=1;
     else if dmnp80=2 and nhor80=2 then pmh80=2;
     else if dmnp80=2 and nhor80=4 then pmh80=3;
     else if dmnp80=2 and nhor80=3 then pmh80=4;
     if pmh82 eq . and pmh80 ne . then pmh82=pmh80;
     if dmnp82 in (1,3) or nhor82=1 then pmh82=1;
     else if dmnp82=2 and nhor82=2 then pmh82=2;
     else if dmnp82=2 and nhor82=4 then pmh82=3;
     else if dmnp82=2 and nhor82=3 then pmh82=4;
     if pmh84 eq . and pmh82 ne . then pmh84=pmh82;

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
array alcocuma{*} alcocum84 alcocum86 alcocum86 alcocum90 alcocum90 alcocum94 alcocum94 alcocum98 alcocum98 alcocum02 alcocum02 alcocum06 alcocum06 alcocum10 alcocum10 alcocum10 alcocum10 alcocum10 alcocum10;
array alcoga{*}   alcog84 alcog86 alcog86 alcog90 alcog90 alcog94 alcog94 alcog98 alcog98 alcog02 alcog02 alcog06 alcog06 alcog10 alcog10 alcog10 alcog10 alcog10 alcog10;

     alcocum84=mean(alco80n,alco84n);
     alcocum86=mean(alco80n,alco84n,alco86n);
     alcocum90=mean(alco80n,alco84n,alco86n,alco90n);
     alcocum94=mean(alco80n,alco84n,alco86n,alco90n,alco94n);
     alcocum98=mean(alco80n,alco84n,alco86n,alco90n,alco94n,alco98n);
     alcocum02=mean(alco80n,alco84n,alco86n,alco90n,alco94n,alco98n,alco02n);
     alcocum06=mean(alco80n,alco84n,alco86n,alco90n,alco94n,alco98n,alco02n,alco06n);
     alcocum10=mean(alco80n,alco84n,alco86n,alco90n,alco94n,alco98n,alco02n,alco06n,alco10n);

     if alco84n eq . & alco80n gt . then alco84n = alco80n;

     do i=1 to dim(alcoga);
          if i>1 then do;if alcocuma{i}=. then alcocuma{i}=alcocuma{i-1};end;
          if .<alcocuma{i}<5 then alcoga{i}=1;
          else if 5<=alcocuma{i}<15 then alcoga{i}=2;
          else if alcocuma{i}>=15 then alcoga{i}=3;
     end;



* beer ;
  beercum80=beer80;
  beercum84=mean(beer80, beer84);
  beercum86=mean(beer80, beer84, beer86);
  beercum90=mean(beer80, beer84, beer86, beer90);
  beercum94=mean(beer80, beer84, beer86, beer90, beer94);
  beercum98=mean(beer80, beer84, beer86, beer90, beer94, beer98);
  beercum02=mean(beer80, beer84, beer86, beer90, beer94, beer98, beer02);
  beercum06=mean(beer80, beer84, beer86, beer90, beer94, beer98, beer02, beer06);
  beercum10=mean(beer80, beer84, beer86, beer90, beer94, beer98, beer02, beer06, beer10);

* wine ;
  winecum80=wine80;
  winecum84=mean(wine80, wine84);
  winecum86=mean(wine80, wine84, wine86);
  winecum90=mean(wine80, wine84, wine86, wine90);
  winecum94=mean(wine80, wine84, wine86, wine90, wine94);
  winecum98=mean(wine80, wine84, wine86, wine90, wine94, wine98);
  winecum02=mean(wine80, wine84, wine86, wine90, wine94, wine98, wine02);
  winecum06=mean(wine80, wine84, wine86, wine90, wine94, wine98, wine02, wine06);
  winecum10=mean(wine80, wine84, wine86, wine90, wine94, wine98, wine02, wine06, wine10);


* liquor ;
  liqcum80=liq80;
  liqcum84=mean(liq80, liq84);
  liqcum86=mean(liq80, liq84, liq86);
  liqcum90=mean(liq80, liq84, liq86, liq90);
  liqcum94=mean(liq80, liq84, liq86, liq90, liq94);
  liqcum98=mean(liq80, liq84, liq86, liq90, liq94, liq98);
  liqcum02=mean(liq80, liq84, liq86, liq90, liq94, liq98, liq02);
  liqcum06=mean(liq80, liq84, liq86, liq90, liq94, liq98, liq02, liq06);
  liqcum10=mean(liq80, liq84, liq86, liq90, liq94, liq98, liq02, liq06, liq10);

* alc ;
  alccum80=alc80;
  alccum84=mean(alc80, alc84);
  alccum86=mean(alc80, alc84, alc86);
  alccum90=mean(alc80, alc84, alc86, alc90);
  alccum94=mean(alc80, alc84, alc86, alc90, alc94);
  alccum98=mean(alc80, alc84, alc86, alc90, alc94, alc98);
  alccum02=mean(alc80, alc84, alc86, alc90, alc94, alc98, alc02);
  alccum06=mean(alc80, alc84, alc86, alc90, alc94, alc98, alc02, alc06);
  alccum10=mean(alc80, alc84, alc86, alc90, alc94, alc98, alc02, alc06, alc10);



array beercuma {*} beercum84 beercum86 beercum86 beercum90 beercum90 beercum94 beercum94 beercum98 beercum98 beercum02 beercum02 beercum06 beercum06 beercum10 beercum10 beercum10 beercum10 beercum10 beercum10;
array winecuma {*} winecum84 winecum86 winecum86 winecum90 winecum90 winecum94 winecum94 winecum98 winecum98 winecum02 winecum02 winecum06 winecum06 winecum10 winecum10 winecum10 winecum10 winecum10 winecum10;
array liqcuma {*} liqcum84 liqcum86 liqcum86 liqcum90 liqcum90 liqcum94 liqcum94 liqcum98 liqcum98 liqcum02 liqcum02 liqcum06 liqcum06 liqcum10 liqcum10 liqcum10 liqcum10 liqcum10 liqcum10;
array alccuma {*} alccum84 alccum86 alccum86 alccum90 alccum90 alccum94 alccum94 alccum98 alccum98 alccum02 alccum02 alccum06 alccum06 alccum10 alccum10 alccum10 alccum10 alccum10 alccum10;





* Cumulative average for AHEI, calories ; 
    array nut2{8, 2} 
       calor84n  nAHEI84 
       calor86n  nAHEI86 
       calor90n  nAHEI90 
       calor94n  nAHEI94 
       calor98n  nAHEI98 
       calor02n  nAHEI02 
       calor06n  nAHEI06 
       calor10n  nAHEI10 
    ;


    array nutv2{8, 2} 
       ccalor84n  cAHEI84 
       ccalor86n  cAHEI86 
       ccalor90n  cAHEI90 
       ccalor94n  cAHEI94 
       ccalor98n  cAHEI98 
       ccalor02n  cAHEI02 
       ccalor06n  cAHEI06 
       ccalor10n  cAHEI10 
    ;

    do j=1 to 2;
        do i=2 to 8;
            if nut2{i,j}=. and nut2{i-1,j}^=. then nut2{i,j}=nut2{i-1,j};
        end;
    end;

    do j=1 to 2;
          nutv2{1,j}=nut2{1,j};
        do i=2 to 8; 
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


array ccalora{*} ccalor84n ccalor86n ccalor86n ccalor90n ccalor90n ccalor94n ccalor94n ccalor98n ccalor98n ccalor02n ccalor02n ccalor06n ccalor06n ccalor10n ccalor10n ccalor10n ccalor10n ccalor10n ccalor10n;
array caheia {*} cAHEI84 cAHEI86 cAHEI86 cAHEI90 cAHEI90 cAHEI94 cAHEI94 cAHEI98 cAHEI98 cAHEI02 cAHEI02 cAHEI06 cAHEI06 cAHEI10 cAHEI10 cAHEI10 cAHEI10 cAHEI10 cAHEI10;


* Intermediate endpoints ;
array diaba{*}  db84 db86 db88 db90 db92 db94 db96 db98 db00 db02 db04 db06 db08 db10 db12 db14 db16 db16 db20; 
array mia{*}    mi84 mi86 mi88 mi90 mi92 mi94 mi96 mi98 mi00 mi02 mi04 mi06 mi08 mi10 mi12 mi14 mi16 mi16 mi20; 
array stra{*}   str84 str86 str88 str90 str92 str94 str96 str98 str00 str02 str04 str06 str08 str10 str12 str14 str16 str16 str20;  
array cana{*}   can84 can86 can88 can90 can92 can94 can96 can98 can00 can02 can04 can06 can08 can10 can12 can14 can16 can16 can20; 

array anga{*}   ang84 ang86 ang88 ang90 ang92 ang94 ang96 ang98 ang00 ang02 ang04 ang06 ang08 ang10 ang12 ang14 ang16 ang16 ang20; 
array hichola{*} chol84 chol86 chol88 chol90 chol92 chol94 chol96 chol98 chol00 chol02 chol04 chol06 chol08 chol10 chol12 chol14 chol16 chol16 chol20; 
array hbpa{*}   hbp84 hbp86 hbp88 hbp90 hbp92 hbp94 hbp96 hbp98 hbp00 hbp02 hbp04 hbp06 hbp08 hbp10 hbp12 hbp14 hbp16 hbp16 hbp20; 
array cabga{*}   cabg84 cabg86 cabg88 cabg90 cabg92 cabg94 cabg96 cabg98 cabg00 cabg02 cabg04 cabg06 cabg08 cabg10 cabg12 cabg14 cabg16 cabg16 cabg20;
array tiaa{*}    XXXX XXXX XXXX tia90 tia92 tia94 tia96 tia98 tia00 tia02 tia04 tia06 tia08 tia10 tia12 tia14 tia16 tia16 tia20;
array carta{*}   XXXX XXXX XXXX cart90 cart92 cart94 cart96 cart98 cart00 cart02 cart04 cart06 cart08 cart10 cart12 cart14 cart16 cart16 cart20;

array interma{*} interm84 interm86 interm88 interm90 interm92 interm94 interm96 interm98 interm00 interm02 interm04 interm06 interm08 interm10 interm12 interm14 interm16 interm16 interm20;

     if db76=1 | db78=1 | db80=1 | db82=1 then db84=1;
     if mi76=1 | mi78=1 | mi80=1 | mi82=1 then mi84=1;
     if str82=1 then str84=1;
     if can76=1 | can78=1 | can80=1 | can82=1 then can84=1;

     if ang76=1 | ang78=1 | ang80=1 | ang82=1 then ang84=1;
     if chol76=1 | chol78=1 | chol80=1 | chol82=1 then chol84=1;
     if hbp76=1 | hbp78=1 | hbp80=1 | hbp82=1 then hbp84=1;

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
          if anga{i}=1 | hichola{i}=1 | hbpa{i}=1 | cabga{i}=1 | tiaa{i}=1 | carta{i}=1 then interma{i}=1;
          else interma{i}=0;
     end;

* SES ;
array sesa{*} nsescav84 nsescav86 nsescav88 nsescav90 nsescav92 nsescav94 nsescav96 nsescav98 nsescav00 nsescav02 nsescav04 nsescav06 nsescav08 nsescav10 nsescav12 nsescav14 nsescav14 nsescav14 nsescav14;


* physical examine for screening purpose ;
array pscexama {*} psexam80 psexam80 psexam88 psexam90 psexam92 psexam94 psexam96 psexam98 psexam00 psexam02 psexam04 psexam06 psexam08 psexam10 psexam12 psexam14 psexam16 psexam16 psexam20 ;

/* 0=no, 1=for symptoms, 2=for screening */
  do i=2 to dim(pscexama);
   if pscexama{i}=. then pscexama{i}=pscexama{i-1};
  end;

  do i=1 to dim(pscexama);
    if pscexama{i} in (.,0,1) then pscexama{i}=0; 
    else if pscexama{i}=2 then pscexama{i}=1;    /* code screening for symptom as 1 */
  end;




* family history of db ; 
if dbfh82=1 or dbfh88=1 or dbfh92=1 then dbfh=1; else dbfh=0;

* family history of MI ; 
mifh=0;
if mmi76=1 or fmi76=1 or mmi84f=1 or fmi84f=1 then mifh=1;

* family history of cancer ; 
canfh=0;
if cafh82=1 or cafh88=1 then canfh=1;




* Endo history ;
array endo {*} endo84 endo86 endo88 endo90 endo92 endo94 endo96 endo98 endo00 endo02 endo04 endo06 endo08 endo10 endo12 endo14 endo16 endo16 endo20;

do i=2 to dim(endo);
   if endo{i}=. then endo{i}=endo{i-1};
end;


* MV ;
 array mvita {*} mvitu84 mvitu86 mvitu88 mvitu90 mvitu92 mvitu94 mvitu96 mvitu98 mvitu00 mvitu02 mvitu04 mvitu06 mvitu08 mvitu10 mvitu10 mvitu14 mvitu16 mvitu16 mvitu20;

 do i=2 to dim(mvita); 
    if mvita{i}=. then mvita{i}=mvita{i-1};
 end;





* ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo; 
* Physical activity: cumulative average
* ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo; 

/* MET-hour/week */
totalpa86mv = mean(totalpa86m);
totalpa88mv = mean(totalpa86m, totalpa88m);
totalpa92mv = mean(totalpa86m, totalpa88m, totalpa92m);
totalpa94mv = mean(totalpa86m, totalpa88m, totalpa92m, totalpa94m);
totalpa96mv = mean(totalpa86m, totalpa88m, totalpa92m, totalpa94m, totalpa96m);
totalpa98mv = mean(totalpa86m, totalpa88m, totalpa92m, totalpa94m, totalpa96m, totalpa98m);
totalpa00mv = mean(totalpa86m, totalpa88m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m);
totalpa04mv = mean(totalpa86m, totalpa88m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa04m);
totalpa08mv = mean(totalpa86m, totalpa88m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa04m, totalpa08m);
totalpa12mv = mean(totalpa86m, totalpa88m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa04m, totalpa08m, totalpa12m);
totalpa14mv = mean(totalpa86m, totalpa88m, totalpa92m, totalpa94m, totalpa96m, totalpa98m, totalpa00m, totalpa04m, totalpa08m, totalpa12m, totalpa14m);



/* total PA, cumulative average, 2-year lag */
              /* QQ       84          86          88          90          92          94          96          98          00          02          04          06          08          10          12          14          16          18          20*/
 array totalpav2laga {19} totalpa86mv totalpa86mv totalpa86mv totalpa88mv totalpa88mv totalpa92mv totalpa94mv totalpa96mv totalpa98mv totalpa00mv totalpa00mv totalpa04mv totalpa04mv totalpa08mv totalpa08mv totalpa12mv totalpa14mv totalpa14mv totalpa14mv;

/* total PA, cumulative average, 4-year lag */
 array totalpav4laga {19} totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa88mv totalpa88mv totalpa92mv totalpa94mv totalpa96mv totalpa98mv totalpa00mv totalpa00mv totalpa04mv totalpa04mv totalpa08mv totalpa08mv totalpa12mv totalpa14mv totalpa14mv ;

/* total PA, cumulative average, 8-year lag */
 array totalpav8laga {19} totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa88mv totalpa88mv totalpa92mv totalpa94mv totalpa96mv totalpa98mv totalpa00mv totalpa00mv totalpa04mv totalpa04mv totalpa08mv totalpa08mv totalpa12mv   ;

/* total PA, cumulative average, 12-year lag */ 
 array totalpav12laga {19} totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa86mv totalpa88mv totalpa88mv totalpa92mv totalpa94mv totalpa96mv totalpa98mv totalpa00mv totalpa00mv totalpa04mv totalpa04mv totalpa08mv     ;


/* percentage of times meeting guideline, 2-year lag */
 array pctmeet2laga {19} pctmeet86 pctmeet86 pctmeet86 pctmeet88 pctmeet88 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet00 pctmeet04 pctmeet04 pctmeet08 pctmeet08 pctmeet12 pctmeet14 pctmeet14 pctmeet14;
 array pctmeett2laga {19} pctmeett86 pctmeett86 pctmeett86 pctmeett88 pctmeett88 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett00 pctmeett04 pctmeett04 pctmeett08 pctmeett08 pctmeett12 pctmeett14 pctmeett14 pctmeett14;
 array pctmeettt2laga {19} pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt88 pctmeettt88 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt00 pctmeettt04 pctmeettt04 pctmeettt08 pctmeettt08 pctmeettt12 pctmeettt14 pctmeettt14 pctmeettt14;

/* percentage of times meeting guideline, 4-year lag */
 array pctmeet4laga {19} pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet88 pctmeet88 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet00 pctmeet04 pctmeet04 pctmeet08 pctmeet08 pctmeet12 pctmeet14 pctmeet14;
 array pctmeett4laga {19} pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett88 pctmeett88 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett00 pctmeett04 pctmeett04 pctmeett08 pctmeett08 pctmeett12 pctmeett14 pctmeett14;
 array pctmeettt4laga {19} pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt88 pctmeettt88 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt00 pctmeettt04 pctmeettt04 pctmeettt08 pctmeettt08 pctmeettt12 pctmeettt14 pctmeettt14;

/* percentage of times meeting guideline, 8-year lag */
 array pctmeet8laga {19} pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet88 pctmeet88 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet00 pctmeet04 pctmeet04 pctmeet08 pctmeet08 pctmeet12  ;
 array pctmeett8laga {19} pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett88 pctmeett88 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett00 pctmeett04 pctmeett04 pctmeett08 pctmeett08 pctmeett12  ;
 array pctmeettt8laga {19} pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt88 pctmeettt88 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt00 pctmeettt04 pctmeettt04 pctmeettt08 pctmeettt08 pctmeettt12  ;

/* percentage of times meeting guideline, 12-year lag */
 array pctmeet12laga {19} pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet86 pctmeet88 pctmeet88 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet00 pctmeet04 pctmeet04 pctmeet08    ;
 array pctmeett12laga {19} pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett86 pctmeett88 pctmeett88 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett00 pctmeett04 pctmeett04 pctmeett08    ;
 array pctmeettt12laga {19} pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt86 pctmeettt88 pctmeettt88 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt00 pctmeettt04 pctmeettt04 pctmeettt08    ;


 /* number of times reported PA questionnaire, 2-year lag */
 array treporta {19} treport86 treport86 treport86 treport88 treport88 treport92 treport94 treport96 treport98 treport00 treport00 treport04 treport04 treport08 treport08 treport12 treport14 treport14 treport14;




