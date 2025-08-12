/*
options linesize=125 pagesize=78;
filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/';
filename local '/usr/local/channing/sasautos/';
filename PHSmacro '/proj/phdats/phdat01/phstools/sasautos/';
libname readfmt '/proj/nhsass/nhsas00/formats/';
options mautosource sasautos=(local nhstools PHSmacro);
options fmtsearch=(readfmt);
*/

/*read Endoscopy */

/********************
sigm190 i1        94      When First Colon. or Sigm. (L8a)
                              $range 0-9
 			   LABEL         COUNT 
	          1 = BEFORE 1980      10842
                    2 = 1980-83           3935
                    3 = 1984-85           2641
                    4 = 1986              1639
                    5 = 1987              1920
                    6 = 1988              2347
                    7 = 1989              2209
                    8 = 1990 OR LATER     1234
                    9 = PASS THR           210

sigm90 i1        93      Colonoscopy or Sigmoidoscopy (L8)
                              $range 0-3
 			   LABEL         COUNT 
		         1 = YES         26977
		         2 = NO          58347
		         3 = PASS THR      333
                         BLANK           19585


sigmr90         i1        102     Most Recent Colon. or Sigm. (L8c)
                              $range 0-9
 			   LABEL         COUNT 
	          1 = BEFORE 1980       5930
                    2 = 1980-83           2472
                    3 = 1984-85           2141
                    4 = 1986              1538
                    5 = 1987              2168
                    6 = 1988              3670
                    7 = 1989              4646
                    8 = 1990 OR LATER     3299
                    9 = PASS THR          1113
*************/

%nur88(keep=sigm88 endo88a);  
   if sigm88 in (2,3) then endo88a=1; /*1: no; 2: yes, screening; 3: yes, symptoms; 4: pt*/
      else if sigm88 eq 4 or sigm88 = . then endo88a=.;	
      else endo88a=0;

%nur90(keep=sigm90 sigmr90 sigm190 endo90 endo80 endo84 endo86 endo88b);
   if sigm90=1 then endo90=1; /*yes*/
      else if sigm90=3 or sigm90=. then endo90=.;
      else endo90=0;

   if sigm190 in (1) or sigmr90 in (1)                  then endo80=1;
      else if sigm190 in (9,.) and sigmr90 in (9,.)     then endo80=.;
      else endo80=0;

   if sigm190 in (2) or sigmr90 in (2)                  then endo84=1;
      else if sigm190 in (9,.) and sigmr90 in (9,.)     then endo84=.;
      else endo84=0;

   if sigm190 in (3) or sigmr90 in (3)                  then endo86=1;
      else if sigm190 in (9,.) and sigmr90 in (9,.)     then endo86=.;
      else endo86=0;

   if sigm190 in (4, 5) or sigmr90 in (4,5)             then endo88b=1;
   if sigm190 in (6, 7) or sigmr90 in (6,7)             then endo90=1;
/*keep this this way, without missings for 88 or 90 as nurses may have skipped this but answered nur88 and nur90 questions above*/

data nur8890; 
   merge nur88 nur90; by id;
   if endo88a=1 or endo88b=1 then endo88=1;
      else endo88=endo88a;
run;

%nur92(keep=sigm92 endo92);
   if sigm92 in (2,3) then endo92=1; /*yes-screening and symptoms*/
      else if sigm92=4 or sigm92 = . then endo92=.;
      else endo92=0;

%nur94(keep=sigm94 endo94);
   if sigm94=2 then endo94=1; /*yes*/
      else if sigm94=3 or sigm94=. then endo94=.;
      else endo94=0;

%nur96(keep=sigm96 endo96);
   if sigm96=2 then endo96=1; /*yes*/
      else if sigm96=3 or sigm96=. then endo96=.;
      else endo96=0;

%nur98(keep=sigm98 endo98 );
   if sigm98=2 then endo98=1; /*yes*/
      else if sigm98=3 or sigm98=. then endo98=.;
      else endo98=0;

%nur00(keep=sigm00 endo00);
   if sigm00=1 then endo00=1;    /*yes*/
      else if sigm00=3 or sigm00=. then endo00=.;
      else endo00=0;

%nur02(keep=sigm02 endo02);
   if sigm02=2 then endo02=1; /*yes*/
      else if sigm02=3 or sigm02=. then endo02=.;
      else endo02=0;

/************
virtc04		i1		248		Virtual CT Colonoscopy (L18)
	$label 1.no; 2.yes; 3.pt

colsc04		i1		249		Colonoscopy (L18)
	$label 1.no; 2.yes; 3.pt

sigsc04		i1		250		Sigmoidoscopy (L18)
	$label 1.no; 2.yes; 3.pt

sigm04		i1		251		Colonoscopy/Sigmoidoscopy BOOKLET ONLY (B23) only in 2004
	$label 1.no; 2.yes; 3.pt
*************/

%nur04(keep=sigm04 sigsc04 colsc04 virtc04 endo04 );
   if sigm04=2 or sigsc04=2 or colsc04=2 or virtc04=2 then endo04=1; /*yes*/
      else if sigm04 in (.,3) and sigsc04 in (.,3) and colsc04 in (.,3) and virtc04 in (.,3) then endo04=.;
      else endo04=0;

%nur06(keep=sigsc06 colsc06 virtc06 endo06 );
   if sigsc06=2 or colsc06=2 or virtc06=2 then endo06=1; /*yes*/
      else if sigsc06 in (.,3) and colsc06 in (.,3) and virtc06 in (.,3) then endo06=.;
      else endo06=0;

%nur08(keep=sigsc08 colsc08 virtc08 endo08 );
   if sigsc08=2 or colsc08=2 or virtc08=2 then endo08=1; /*yes*/
      else if sigsc08 in (.,3) and colsc08 in (.,3) and virtc08 in (.,3) then endo08=.;
      else endo08=0;

%nur10(keep=sigsc10 colsc10 virtc10 endo10);
   if sigsc10=2 or colsc10=2 or virtc10=2 then endo10=1; /*yes*/
      else if sigsc10 in (.,3) and colsc10 in (.,3) and virtc10 in (.,3) then endo10=.;
      else endo10=0;

%nur12(keep=sigsc12 colsc12 virtc12 endo12);
   if sigsc12=2 or colsc12=2 or virtc12=2 then endo12=1; /*yes*/
      else if sigsc12 in (.,3) and colsc12 in (.,3) and virtc12 in (.,3) then endo12=.;
      else endo12=0;

%nur14(keep=sigsc14 colsc14 virtc14 endo14);
   if sigsc14=2 or colsc14=2 or virtc14=2 then endo14=1; /*yes*/
      else if sigsc14 in (.,3) and colsc14 in (.,3) and virtc14 in (.,3) then endo14=.;
      else endo14=0;

%nur16(keep=sigsc16 colsc16 virtc16 endo16);
   if sigsc16=2 or colsc16=2 or virtc16=2 then endo16=1; /*yes*/
      else if sigsc16 in (.,3) and colsc16 in (.,3) and virtc16 in (.,3) then endo16=.;
      else endo16=0;

%nur20(keep=sigsc20 colsc20 virtc20 endo20);
   if sigsc20=2 or colsc20=2 or virtc20=2 then endo20=1; /*yes*/
      else if sigsc20 in (.,3) and colsc20 in (.,3) and virtc20 in (.,3) then endo20=.;
      else endo20=0;


data nhs_sigmoid; 
   merge nur8890 nur92 nur94 nur96 nur98 nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nur16 nur20;
   by id;
   keep id endo80 endo84 endo86 endo88 endo90 endo92 endo94 endo96 endo98 endo00 endo02 endo04 endo06 endo08 endo10 endo12 endo14 endo16 endo20;
run;

proc datasets;
delete nur88 nur90 nur8890 nur92 nur94 nur96 nur98 nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nur16 nur20; 
run;

proc freq data=nhs_sigmoid;
	tables endo80 endo84 endo86 endo88 endo90 endo92 endo94 endo96 endo98 endo00 endo02 endo04 endo06 endo08 endo10 endo12 endo14 endo16 endo20;
run;



