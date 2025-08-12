/*
options linesize=125 pagesize=78 nocenter;
filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/';
filename local '/usr/local/channing/sasautos/';
filename PHSmacro '/proj/phdats/phdat01/phstools/sasautos/';
libname readfmt '/proj/nhsass/nhsas00/formats/';
options mautosource sasautos=(local nhstools PHSmacro);
options fmtsearch=(readfmt);
options nocenter;
*/

/*read Endoscopy */

/*
sigm91  Colonoscopy/Sigmoidoscopy
   $range 1-4
   1 = no
   2 = yes screening
   3 = yes symptoms
   4 = pass through
*/

%nur91(keep=id sigm91 endo91 reasoned91);
if sigm91 in (2,3) then endo91=1;
   else if sigm91 = 1 then endo91=0;
   else endo91=.;

* reason for endoscopy 
   1 = symptom, 2 = screen/family hx *;
    if sigm91=3 then reasoned91=1;
    if sigm91=2 then reasoned91=2;


%nur93(keep=id sigm93 endo93 reasoned93);
if sigm93 in (2,3) then endo93=1;
   else if sigm93 = 1 then endo93=0;
   else endo93=.;

    if sigm93=3 then reasoned93=1;
    if sigm93=2 then reasoned93=2;


%nur95(keep=id sigm95 endo95 reasoned95);
if sigm95 in (2,3) then endo95=1;
   else if sigm95 = 1 then endo95=0;
   else endo95=.;

    if sigm95=3 then reasoned95=1;
    if sigm95=2 then reasoned95=2;

/*
sigmx97   Colonoscopy/sigmoidoscopy - No
sigsc97   Colonoscopy/Sig - Screening
sigsy97   Colonoscopy/Sig - Symptoms
sigpt97   Colonoscopy/Sig PT
*/

%nur97(keep=id sigmx97 sigsc97 sigsy97 sigpt97 endo97 reasoned95);
if sigsc97=1 or sigsy97=1 then endo97=1;
   else if sigmx97=1 then endo97=0;
   else endo97=.;

    if sigsy97=1 then reasoned95=1;
    if sigsc97=1 then reasoned95=2;



%nur99(keep=id sigmx99 sigsc99 sigsy99 sigpt99 endo99 reasoned99);
if sigsc99=1 or sigsy99=1 then endo99=1;
   else if sigmx99=1 then endo99=0;
   else endo99=.;

    if sigsy99=1 then reasoned99=1;
    if sigsc99=1 then reasoned99=2;


/*
sigm01   Colonoscopy/Sigmoidscopy
 label 1.yes; 2.no; 3.pt
*/

%nur01(keep=id sigm01 endo01
       vbld01 fecal01 abdpn01 diarr01 bariu01 hxclc01 rout01 reasoned01);
if sigm01=1 then endo01=1;
   else if sigm01=2 then endo01=0;
   else endo01=.;

    if (vbld01=1 or fecal01=1 or abdpn01=1 or diarr01=1 or bariu01=1) then reasoned01=1;
    else if (hxclc01=1 or rout01=1) then reasoned01=2;    


/*
sigm03    Sigmoidoscopy Since 06/01   $label 1.no; 2.yes; 3.pt
colsc03   Colonoscopy Since 06/01     $label 1.no; 2.yes; 3.pt
virt03    Virtual (CT) Colonography   $range 1
*/

%nur03(keep=id sigm03 colsc03 virt03 endo03
       vbld03 fecal03 abdpn03 diarr03 bariu03 hxclc03 rout03 virt03 cpolp03 reasoned03);
if sigm03=2 or colsc03=2 or virt03=1 then endo03=1;
   else if sigm03=1 and colsc03=1 then endo03=0;
   else endo03=.;

    if (vbld03=1 or fecal03=1 or abdpn03=1 or diarr03=1 or bariu03=1) then reasoned03=1;
    else if (hxclc03=1 or rout03=1 or virt03=1 or cpolp03=1) then reasoned03=2;     

/*
virtc05   Virtual Colonoscopy Since June 2003   $label 1.no; 2.yes; 3.pt
sigsc05   Sigmoidoscopy Since June 2003         $label 1.no; 2.yes; 3.pt
colsc05   Colonoscopy Since June 2003           $label 1.no; 2.yes; 3.pt
*/

%nur05(keep=id sigsc05 colsc05 virtc05 endo05
       vbld05 fecal05 abdpn05 diarr05 bariu05 hxclc05 rout05 cpolp05 virt05 reasoned05);
if sigsc05=2 or colsc05=2 or virtc05=2 then endo05=1;
   else if sigsc05=1 and colsc05=1 and virtc05=1 then endo05=0;
   else endo05=.;

    if (vbld05=1 or fecal05=1 or abdpn05=1 or diarr05=1 or bariu05=1) then reasoned05=1;
    else if (hxclc05=1 or rout05=1 or cpolp05=1 or virt05=1) then reasoned05=2;    


%nur07(keep=id sigsc07 colsc07 virtc07 endo07
       vbld07 fecal07 abdpn07 diarr07 bariu07 hxclc07 rout07 cpolp07 virt07 reasoned07);
if sigsc07=2 or colsc07=2 or virtc07=2 then endo07=1;
   else if sigsc07=1 and colsc07=1 and virtc07=1 then endo07=0;
   else endo07=.;

    if (vbld07=1 or fecal07=1 or abdpn07=1 or diarr07=1 or bariu07=1) then reasoned07=1;
    else if (hxclc07=1 or rout07=1 or cpolp07=1 or virt07=1) then reasoned07=2;



%nur09(keep=id sigsc09 colsc09 virtc09 endo09
       vbld09 fecal09 abdpn09 diarr09 bariu09 hxclc09 rout09 cpolp09 virt09 reasoned09);
if sigsc09=2 or colsc09=2 or virtc09=2 then endo09=1;
   else if sigsc09=1 and colsc09=1 and virtc09=1 then endo09=0;
   else endo09=.;

    if (vbld09=1 or fecal09=1 or abdpn09=1 or diarr09=1 or bariu09=1) then reasoned09=1;
    else if (hxclc09=1 or rout09=1 or cpolp09=1 or virt09=1) then reasoned09=2; 


%nur11(keep=id sigsc11 colsc11 virtc11 endo11
       vbld11 fecal11 abdpn11 diarr11 bariu11 hxclc11 rout11 cpolp11 virt11 reasoned11);
if sigsc11=2 or colsc11=2 or virtc11=2 then endo11=1;
   else if sigsc11=1 and colsc11=1 and virtc11=1 then endo11=0;
   else endo11=.;

    if (vbld11=1 or fecal11=1 or abdpn11=1 or diarr11=1 or bariu11=1) then reasoned11=1;
    else if (hxclc11=1 or rout11=1 or cpolp11=1 or virt11=1) then reasoned11=2; 


%nur13(keep=id sigsc13 colsc13 virtc13 endo13
       vbld13 fecal13 abdpn13 diarr13 bariu13 hxclc13 rout13 cpolp13 virt13 reasoned13);
if sigsc13=2 or colsc13=2 or virtc13=2 then endo13=1;
   else if sigsc13=1 and colsc13=1 and virtc13=1 then endo13=0;
   else endo13=.;

    if (vbld13=1 or fecal13=1 or abdpn13=1 or diarr13=1 or bariu13=1) then reasoned13=1;
    else if (hxclc13=1 or rout13=1 or cpolp13=1 or virt13=1) then reasoned13=2;


%nur15(keep=id sigsc15 colsc15 virtc15 endo15
       vbld15 fecal15 abdpn15 diarr15 hxclc15 rout15 cpolp15 virt15 reasoned15);
if sigsc15=2 or colsc15=2 or virtc15=2 then endo15=1;
   else if sigsc15=1 and colsc15=1 and virtc15=1 then endo15=0;
   else endo15=.;

    if (vbld15=1 or fecal15=1 or abdpn15=1 or diarr15=1) then reasoned15=1;
    else if (hxclc15=1 or rout15=1 or cpolp15=1 or virt15=1) then reasoned15=2;


%nur17(keep=id sigsc17 colsc17 virtc17 endo17
       vbld17 fecal17 abdpn17 diarr17 hxclc17 rout17 cpolp17 virt17 reasoned17);
if sigsc17=2 or colsc17=2 or virtc17=2 then endo17=1;
   else if sigsc17=1 and colsc17=1 and virtc17=1 then endo17=0;
   else endo17=.;

    if (vbld17=1 or fecal17=1 or abdpn17=1 or diarr17=1) then reasoned17=1;
    else if (hxclc17=1 or rout17=1 or cpolp17=1 or virt17=1) then reasoned17=2;


data sigmoid; 
   merge nur91 nur93 nur95 nur97 nur99 nur01 nur03 nur05 nur07 nur09 nur11 nur13 nur15 nur17;
   by id;

    array endoxx [*] endo91 endo93 endo95 endo97 endo99 endo01 endo03 endo05 endo07 endo09 endo11 endo13 endo15 endo17; * 0=no endo, 1=yes endo ;
    array reasonxx[*] reasoned91 reasoned93 reasoned95 reasoned97 reasoned99 reasoned01 reasoned03 reasoned05 reasoned07 reasoned09 reasoned11 reasoned13 reasoned15 reasoned17; * 1=symptom,2=screening ;
    array endo3c [*] endo3c91 endo3c93 endo3c95 endo3c97 endo3c99 endo3c01 endo3c03 endo3c05 endo3c07 endo3c09 endo3c11 endo3c13 endo3c15 endo3c17;

   do i=1 to dim(endo3c);
      if i>1 then do;
         if reasonxx[i]=. and reasonxx[i-1]>. then reasonxx[i]=reasonxx[i-1];
      end;
      if endoxx[i]=0 then endo3c[i]=0; * no endo ;
      else if endoxx[i]=1 and reasonxx[i]=1 then endo3c[i]=1; * endo for symptoms;
      else if endoxx[i]=1 and reasonxx[i]=2 then endo3c[i]=2; * endo for screening;
      else endo3c[i]=.; *missing;
   end;


   keep id endo91 endo93 endo95 endo97 endo99 endo01 endo03 endo05 endo07 endo09 endo11 endo13 endo15 endo17
           reasoned91 reasoned93 reasoned95 reasoned97 reasoned99 reasoned01 reasoned03 reasoned05 reasoned07 reasoned09 reasoned11 reasoned13 reasoned15 reasoned17
           endo3c91 endo3c93 endo3c95 endo3c97 endo3c99 endo3c01 endo3c03 endo3c05 endo3c07 endo3c09 endo3c11 endo3c13 endo3c15 endo3c17;
run;

proc datasets;
delete nur91 nur93 nur95 nur97 nur99 nur01 nur03 nur05 nur07 nur09 nur11 nur13 nur15 nur17; 
run;


proc freq data=sigmoid;
   tables endo91 endo93 endo95 endo97 endo99 endo01 endo03 endo05 endo07 endo09 endo11 endo13 endo15 endo17
          reasoned91 reasoned93 reasoned95 reasoned97 reasoned99 reasoned01 reasoned03 reasoned05 reasoned07 reasoned09 reasoned11 reasoned13 reasoned15 reasoned17
          endo3c91 endo3c93 endo3c95 endo3c97 endo3c99 endo3c01 endo3c03 endo3c05 endo3c07 endo3c09 endo3c11 endo3c13 endo3c15 endo3c17/missing;
run;





