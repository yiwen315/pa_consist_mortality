/*
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos';
filename ehmac '/udd/stleh/ehmac';
filename cardio10 '/proj/hpchds/hpchd0q/CARDIO2010/cardio2010.03092013';  
libname formats '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing hpstools ehmac); *path to macro;
options fmtsearch=(formats);
options linesize=175 pagesize=78 NOCENTER;
*/

/*read Endoscopy */
/*sigsy88  sigmoidoscopy- symptoms, 
  sigsc88  1=yes, Sigmoidoscopy - Routine
  sigx88   1=no sigmoidoscopy
  colsy88  colonoscopy -symptoms
  colsc88  1=yes Colonoscopy - Routine
  colx88   1=no Colonoscopy */
%hp88(keep=sigsy88 sigsc88 sigx88 colsy88 colsc88 colx88 endo88a);  
if (sigx88=1 and colx88=1) then endo88a=0; *no sigmoidoscopy or colonoscopy;
   else if (sigsy88=1 or sigsc88=1 or colsy88=1 or colsc88=1 ) then endo88a=1;
   else endo88a=.; *include pass throughs as missing;

/* sigm190             i1             111            Date First Sig/Colonoscopy (L13)
	$label 1.Before 1986;\
	2.1986;\
	3.1987;\
	4.1988;\
	5.1989;\
	6.1990 or later;\
	7.PASSTHRU
sigmr90             i1             119            Most recent Sig/Colonoscopy (L13)
	$label 1.Before 1986;\
	2.1986;\
	3.1987;\
	4.1988;\
	5.1989;\
	6.1990 or later;\
	7.PASSTHRU */
%hp90(keep=sigm90 sigm190 sigmr90 endo90 endo88b endo86);
   endo86=0; endo90=0; endo88b=0;
   if sigm90=2 then endo90=1;
   if (sigmr90 in (1,2) or sigm190 in (1,2)) then endo86=1;
      else if (sigmr90 in (3,4) or sigm190 in (3,4)) then endo88b=1;
      else if (sigmr90 in (5) or sigm190 in (5)) then endo90=1;

data hp8890;
   merge hp88 hp90; by id;
   if endo88a=1 or endo88b=1 then endo88=1;
      else endo88=endo88a;
run;
/*keep this this way, without missings for 88 or 90 as nurses may have skipped this but answered nur88 and nur90 questions above*/

%hp92(keep=sigm92 sig9092 endo92);
   if sigm92=2 or sig9092=2 then endo92=1;
      else if sigm92=1 and sig9092=1 then endo92=0;
      else endo92=.;

%hp94(keep=sigm94 endo94);
   if sigm94=1 then endo94=0;
      else if sigm94=2 then endo94=1;
      else endo94=.;

%hp96(keep=sig9496 endo96);
   if sig9496=1 then endo96=0;
      else if sig9496=2 then endo96=1;
      else endo96=.;

%hp98(keep=sigm98 endo98);
   if sigm98=1 then endo98=0;
      else if sigm98=2 then endo98=1;
      else endo98=.;

%hp00(keep=sigm00 endo00);
   if sigm00=1 then endo00=0;
      else if sigm00=2 then endo00=1;
      else endo00=.;

%hp02(keep=sigmd02 endo02);
   if sigmd02=1 then endo02=0;
      else if sigmd02=2 then endo02=1;
      else endo02=.;

%hp04(keep=sigmd04 colsc04 virt04 endo04);
   if (sigmd04=2 or colsc04=2 or virt04=1) then endo04=1;
      else if (sigmd04=1 and colsc04=1) then endo04=0;
      else endo04=.;
  
%hp06(keep=sigmd06 colsc06 virt06 endo06);
   if (sigmd06=2 or colsc06=2 or virt06=1) then endo06=1;
      else if (sigmd06=1 and colsc06=1) then endo06=0;
      else endo06=.;

%hp08(keep=sigmd08 colsc08 ctcol08 virt08 endo08);
   if (sigmd08=2 or colsc08=2 or ctcol08=2 or virt08=1) then endo08=1;
      else if (sigmd08=1 and colsc08=1 and ctcol08=1) then endo08=0;
      else endo08=.;

%hp10(keep=sigmd10 colsc10 ctcol10 virt10 endo10);
   if (sigmd10=2 or colsc10=2 or ctcol10=2 or virt10=1) then endo10=1;
      else if (sigmd10=1 and colsc10=1 and ctcol10=1) then endo10=0;
      else endo10=.;

%hp12(keep=sigmd12 colsc12 ctcol12 virt12 endo12);
   if (sigmd12=2 or colsc12=2 or ctcol12=2 or virt12=1) then endo12=1;
      else if (sigmd12=1 and colsc12=1 and ctcol12=1) then endo12=0;
      else endo12=.;

%hp14(keep=sigmd14 colsc14 ctcol14 endo14);
   if (sigmd14=2 or colsc14=2 or ctcol14=2) then endo14=1;
      else if (sigmd14=1 and colsc14=1 and ctcol14=1) then endo14=0;
      else endo14=.;

%hp16(keep=sigmd16 colsc16 ctcol16 endo16);
   if (sigmd16=2 or colsc16=2 or ctcol16=2) then endo16=1;
      else if (sigmd16=1 and colsc16=1 and ctcol16=1) then endo16=0;
      else endo16=.;

%hp18(keep=sigmd18 colsc18 ctcol18 endo18);
   if (sigmd18=2 or colsc18=2 or ctcol18=2) then endo18=1;
      else if (sigmd18=1 and colsc18=1 and ctcol18=1) then endo18=0;
      else endo16=.;

%hp20(keep=sigmd20 colsc20 ctcol20 endo20);
   if (sigmd20=2 or colsc20=2 or ctcol20=2) then endo20=1;
      else if (sigmd20=1 and colsc20=1 and ctcol20=1) then endo20=0;
      else endo20=.;

data sigmoid; 
   merge hp8890 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hp18 hp20;
   by id;
   keep id endo86 endo88 endo90 endo92 endo94 endo96 endo98 endo00 endo02 endo04 endo06 endo08 endo10 endo12 endo14 endo16 endo18 endo20;
run;

proc datasets;
delete hp88 hp90 hp8890 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hp18 hp20; 
run;

proc freq data=sigmoid;
	tables endo86 endo88 endo90 endo92 endo94 endo96 endo98 endo00 endo02 endo04 endo06 endo08 endo10 endo12 endo14 endo16 endo18 endo20/missing;
run;

