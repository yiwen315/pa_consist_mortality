/* read in multivitamin use */


/*
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos';
filename ehmac '/udd/stleh/ehmac';
libname formats '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing hpstools ehmac); *path to macro;

options fmtsearch=(formats);
options nocenter ls=100 ps=68 replace; 
*/



%h86_dt(keep=mvyn86 mvt86d ); if mvt86d=2 then mvyn86=1;else if mvt86d=1 then mvyn86=0; run;

%hp88(keep=mvt88 mvyn88); if mvt88=1 then mvyn88=1; else if mvt88=2 then mvyn88=0; run;

%h90_dt(keep=mvt90d mvyn90);if mvt90d=2 then mvyn90=1;else if mvt90d=1 then mvyn90=0;run;

%hp92(keep=mvt92 mvyn92); if mvt92=2 then mvyn92=1; else mvyn92=0; run;

%h94_dt(keep=mvt94d mvyn94);if mvt94d=2 then mvyn94=1;else if mvt94d=1 then mvyn94=0;run;

%hp96(keep= mvt96 mvyn96); if mvt96=2 then mvyn96=1; else if mvt96=1 then mvyn96=0; run; 

%h98_dt(keep=mvt98d mvyn98);if mvt98d=2 then mvyn98=1;else if mvt98d=1 then mvyn98=0;run;

%hp00(keep=mvt00 mvyn00); if mvt00=2 then mvyn00=1; else if mvt00=1 then mvyn00=0; run;

%hp02(keep=mvt02 mvyn02); if mvt02=2 then mvyn02=1; else if mvt02=1 then mvyn02=0; run;

%hp04(keep=mvt04 mvyn04); if mvt04=2 then mvyn04=1; else if mvt04=1 then mvyn04=0; run;

%hp06(keep=mvt06 mvyn06); if mvt06=2 then mvyn06=1; else if mvt06=1 then mvyn06=0; run;

%hp08(keep=mvt08 mvyn08); if mvt08=2 then mvyn08=1; else if mvt08=1 then mvyn08=0; run;

%hp10(keep=mvt10 mvyn10); if mvt10=2 then mvyn10=1; else if mvt10=1 then mvyn10=0; run;

%hp12(keep=mvt12 mvyn12); if mvt12=2 then mvyn12=1; else if mvt12=1 then mvyn12=0; run;

%hp14(keep=mvt14 mvyn14); if mvt14=2 then mvyn14=1; else if mvt14=1 then mvyn14=0; run;

*hp16;

%hp18(keep=mvt18 mvyn18); if mvt18=2 then mvyn18=1; else if mvt18=1 then mvyn18=0; run;


data hpfs_mv; 
  merge h86_dt hp88 h90_dt hp92 h94_dt hp96 h98_dt hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp18;
  by id;

keep id 
mvyn86 mvyn88 mvyn90 mvyn92 mvyn94 mvyn96 mvyn98 mvyn00 mvyn02 mvyn04 mvyn06 mvyn08 mvyn10 mvyn12 mvyn14 mvyn18;

run;



proc datasets;
    delete h86_dt hp88 h90_dt hp92 h94_dt hp96 h98_dt hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp18;
run; 







