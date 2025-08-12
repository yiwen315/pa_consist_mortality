
/* read in alcohol type: serving/week covert to g/day */

/*
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos';
filename ehmac '/udd/stleh/ehmac';
libname formats '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing hpstools ehmac); *path to macro;

options fmtsearch=(formats);
options nocenter ls=100 ps=68 replace; */


/* read in: seving/week*/

%h86_dt (keep=beer86d          rwine86d wwine86d liq86d);
%h90_dt (keep=beer90d          rwine90d wwine90d liq90d);
%h94_dt (keep=beer94d lbeer94d rwine94d wwine94d liq94d);
%h98_dt (keep=beer98d lbeer98d rwine98d wwine98d liq98d);
%hp02   (keep=beer02d lbeer02d rwine02d wwine02d liq02d);
%hp06   (keep=beer06d lbeer06d rwine06d wwine06d liq06d);
%hp10   (keep=beer10d lbeer10d rwine10d wwine10d liq10d);
%hp14   (keep=beer14d lbeer14d rwine14d wwine14d liq14d);
%hp18   (keep=beer18d lbeer18d rwine18d wwine18d liq18d);



data hpfs_alcohol;
	merge h86_dt h90_dt h94_dt h98_dt hp02 hp06 hp10 hp14 hp18 end=_end_;
	by id;

/* convert serving/week to werving/day */
array bevd 
beer86d          rwine86d wwine86d liq86d
beer90d          rwine90d wwine90d liq90d
beer94d lbeer94d rwine94d wwine94d liq94d
beer98d lbeer98d rwine98d wwine98d liq98d
beer02d lbeer02d rwine02d wwine02d liq02d
beer06d lbeer06d rwine06d wwine06d liq06d
beer10d lbeer10d rwine10d wwine10d liq10d
beer14d lbeer14d rwine14d wwine14d liq14d
beer18d lbeer18d rwine18d wwine18d liq18d ;

array bevs
beer86s          rwine86s wwine86s liq86s
beer90s          rwine90s wwine90s liq90s
beer94s lbeer94s rwine94s wwine94s liq94s
beer98s lbeer98s rwine98s wwine98s liq98s
beer02s lbeer02s rwine02s wwine02s liq02s
beer06s lbeer06s rwine06s wwine06s liq06s
beer10s lbeer10s rwine10s wwine10s liq10s
beer14s lbeer14s rwine14s wwine14s liq14s
beer18s lbeer18s rwine18s wwine18s liq18s ;

do over bevd;
if bevd=0 then bevs=0;
else if bevd=1 then bevs=0.065;
else if bevd=2 then bevs=0.143;
else if bevd=3 then bevs=0.429;
else if bevd=4 then bevs=0.786;
else if bevd=5 then bevs=1.0;
else if bevd=6 then bevs=2.5;
else if bevd=7 then bevs=4.5;
else if bevd=8 then bevs=6.0;
else bevs=0; /*if missing, assume 0*/
end;


/* ethanol content for one serving of each alcoholic beverage 
14.0 g of alcohol for a 1.5 oz/44 mL serving of liquor, 
12.8 g for a 12 oz/355 mL serving of regular beer, or 11.3 g for light beer, 
11.3 g for a 4 oz/118 mL serving of wine
*/

beer86=beer86s*12.8;
rwine86=rwine86s*11.3;
wwine86=wwine86s*11.3;
liq86=liq86s*14.0;

beer90=beer90s*12.8;
rwine90=rwine90s*11.3;
wwine90=wwine90s*11.3;
liq90=liq90s*14.0;

obeer94=beer94s*12.8;
lbeer94=lbeer94s*11.3;
rwine94=rwine94s*11.3;
wwine94=wwine94s*11.3;
liq94=liq94s*14.0;

obeer98=beer98s*12.8;
lbeer98=lbeer98s*11.3;
rwine98=rwine98s*11.3;
wwine98=wwine98s*11.3;
liq98=liq98s*14.0;

obeer02=beer02s*12.8;
lbeer02=lbeer02s*11.3;
rwine02=rwine02s*11.3;
wwine02=wwine02s*11.3;
liq02=liq02s*14.0;

obeer06=beer06s*12.8;
lbeer06=lbeer06s*11.3;
rwine06=rwine06s*14.1;
wwine06=wwine06s*14.1;
liq06=liq06s*14.0;

obeer10=beer10s*12.8;
lbeer10=lbeer10s*11.3;
rwine10=rwine10s*14.1;
wwine10=wwine10s*14.1;
liq10=liq10s*14.0;

obeer14=beer14s*12.8;
lbeer14=lbeer14s*11.3;
rwine14=rwine14s*14.1;
wwine14=wwine14s*14.1;
liq14=liq14s*14.0;

obeer18=beer18s*12.8;
lbeer18=lbeer18s*11.3;
rwine18=rwine18s*14.1;
wwine18=wwine18s*14.1;
liq18=liq18s*14.0;


/* sum total alcohol */
alc86=sum(beer86, rwine86, wwine86, liq86);
alc90=sum(beer90, rwine90, wwine90, liq90);
alc94=sum(obeer94, lbeer94, rwine94, wwine94, liq94);
alc98=sum(obeer98, lbeer98, rwine98, wwine98, liq98);
alc02=sum(obeer02, lbeer02, rwine02, wwine02, liq02);
alc06=sum(obeer06, lbeer06, rwine06, wwine06, liq06);
alc10=sum(obeer10, lbeer10, rwine10, wwine10, liq10);
alc14=sum(obeer14, lbeer14, rwine14, wwine14, liq14);
alc18=sum(obeer18, lbeer18, rwine18, wwine18, liq18);


/*Create Total Wine Variables - winexx*/
wine86=sum(rwine86, wwine86);
wine90=sum(rwine90, wwine90);
wine94=sum(rwine94, wwine94);
wine98=sum(rwine98, wwine98);
wine02=sum(rwine02, wwine02);
wine06=sum(rwine06, wwine06);
wine10=sum(rwine10, wwine10);
wine14=sum(rwine14, wwine14);
wine18=sum(rwine18, wwine18);

/*Create Total Beer Variables - beerxx*/
beer94=sum(obeer94, lbeer94);
beer98=sum(obeer98, lbeer98);
beer02=sum(obeer02, lbeer02);
beer06=sum(obeer06, lbeer06);
beer10=sum(obeer10, lbeer10);
beer14=sum(obeer14, lbeer14);
beer18=sum(obeer18, lbeer18);


keep id 
alc86 alc90 alc94 alc98 alc02 alc06 alc10 alc14 alc18
beer86 beer90 beer94 beer98 beer02 beer06 beer10 beer14 beer18
wine86 wine90 wine94 wine98 wine02 wine06 wine10 wine14 wine18
liq86 liq90 liq94 liq98 liq02 liq06 liq10 liq14 liq18 ;

run;




proc datasets;
    delete h86_dt h90_dt h94_dt h98_dt hp02 hp06 hp10 hp14 hp18;
run; 


proc means data=hpfs_alcohol n nmiss min median mean max;
var 
alc86 alc90 alc94 alc98 alc02 alc06 alc10 alc14 alc18
beer86 beer90 beer94 beer98 beer02 beer06 beer10 beer14 beer18
wine86 wine90 wine94 wine98 wine02 wine06 wine10 wine14 wine18
liq86 liq90 liq94 liq98 liq02 liq06 liq10 liq14 liq18;
run;




