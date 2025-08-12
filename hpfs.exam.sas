/*physical examination for screening purpose*/

/*
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos';
filename ehmac '/udd/stleh/ehmac';
libname formats '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing hpstools ehmac); *path to macro;

options fmtsearch=(formats);
options nocenter ls=100 ps=68 replace;
*/

%hp88(keep=physc88 psexam88);
if physc88=1 then psexam88=1; else psexam88=0;

%hp90(keep=physc90 psexam90);
if physc90=1 then psexam90=1; else psexam90=0;  

%hp92(keep=physx92 psexam92);
if physx92=3 then psexam92=1; else psexam92=0;  

%hp94(keep=physx94 psexam94);
if physx94=3 then psexam94=1; else psexam94=0;  

%hp96(keep=physx96 psexam96);
if physx96=3 then psexam96=1; else psexam96=0;  

%hp98(keep=physx98 psexam98);
if physx98=3 then psexam98=1; else psexam98=0;  

%hp00(keep=physx00 psexam00);
if physx00=3 then psexam00=1; else psexam00=0;  

%hp02(keep=physc02 psexam02);
if physc02=1 then psexam02=1; else psexam02=0;  

%hp04(keep=physc04 psexam04);
if physc04=1 then psexam04=1; else psexam04=0;  

%hp06(keep=physc06 psexam06);
if physc06=1 then psexam06=1; else psexam06=0;  

%hp08(keep=physc08 psexam08);
if physc08=1 then psexam08=1; else psexam08=0;  

%hp10(keep=physc10 psexam10);
if physc10=1 then psexam10=1; else psexam10=0;  

%hp12(keep=physc12 psexam12);
if physc12=1 then psexam12=1; else psexam12=0;  

%hp14(keep=physc14 psexam14);
if physc14=1 then psexam14=1; else psexam14=0;  

%hp16(keep=physc16 psexam16);
if physc16=1 then psexam16=1; else psexam16=0;  

%hp18(keep=physc18 psexam18);
if physc18=1 then psexam18=1; else psexam18=0;  

%hp20(keep=physc20 psexam20);
if physc20=1 then psexam20=1; else psexam20=0; 


data hpfs_psexam;
	merge  hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hp18 hp20;
	by id;

 array pscexam {*} psexam88 psexam90 psexam92 psexam94 psexam96 psexam98 psexam00 psexam02 psexam04 psexam06 psexam08 psexam10 psexam12 psexam14 psexam16 psexam18 psexam20;

 do i=2 to dim(pscexam);
   if pscexam{i}=. then pscexam{i}=pscexam{i-1};
 end;

run;


data hpfs_psexam;
	set hpfs_psexam;
	keep id psexam88 psexam90 psexam92 psexam94 psexam96 psexam98 psexam00 psexam02 psexam04 psexam06 psexam08 psexam10 psexam12 psexam14 psexam16 psexam18 psexam20;
run;

proc freq data=hpfs_psexam;
	tables psexam88 psexam90 psexam92 psexam94 psexam96 psexam98 psexam00 psexam02 psexam04 psexam06 psexam08 psexam10 psexam12 psexam14 psexam16 psexam18 psexam20;
run;

proc datasets nolist;
 delete  hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hp18 hp20;
run;


