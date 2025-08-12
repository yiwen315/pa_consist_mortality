/* read in alcohol type: serving/week covert to g/day */

/*
filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/';
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos/';
libname nhsfmt '/proj/nhsass/nhsas00/formats';
libname hpfsfmt '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing nhstools hpstools);
options fmtsearch=(nhsfmt hpfsfmt) nocenter nofmterr;
options ls=125 ps=78;
*/

/* serving/day */
%serv80(keep=beer_s80 wine_s80 liq_s80   coff_s80); run;
%serv84(keep=beer_s84 rwine_s84 wwine_s84 liq_s84   coff_s84 dcaf_s84); run;
%serv86(keep=beer_s86 rwine_s86 wwine_s86 liq_s86   coff_s86 dcaf_s86); run;
%serv90(keep=beer_s90 rwine_s90 wwine_s90 liq_s90   coff_s90 dcaf_s90); run;
%serv94(keep=beer_s94 lbeer_s94 rwine_s94 wwine_s94 liq_s94   coff_s94 dcaf_s94); run;
%serv98(keep=beer_s98 lbeer_s98 rwine_s98 wwine_s98 liq_s98   coff_s98 dcaf_s98); run;
%serv02(keep=beer_s02 lbeer_s02 rwine_s02 wwine_s02 liq_s02   coff_s02 dcaf_s02); run;
%serv06(keep=beer_s06 lbeer_s06 rwine_s06 wwine_s06 liq_s06   coff_s06 dcaf_s06); run;
%serv10(keep=beer_s10 lbeer_s10 rwine_s10 wwine_s10 liq_s10   coff_s10 dcaf_s10); run;




data nhs_alcohol;
	merge  serv80 serv84 serv86 serv90 serv94 serv98 serv02 serv06 serv10 end=_end_;
	by id;


/* ethanol content for one serving of each alcoholic beverage 
14.0 g of alcohol for a 1.5 oz/44 mL serving of liquor, 
12.8 g for a 12 oz/355 mL serving of regular beer, or 11.3 g for light beer, 
11.3 g for a 4 oz/118 mL serving of wine
*/


beer80=beer_s80*12.8;
rwine80=wine_s80*11.3/2; /* assume half white, half red..*/
wwine80=wine_s80*11.3/2;
liq80=liq_s80*14.0;


beer84=beer_s84*12.8;
rwine84=rwine_s84*11.3;
wwine84=wwine_s84*11.3;
liq84=liq_s84*14.0;

beer86=beer_s86*12.8;
rwine86=rwine_s86*11.3;
wwine86=wwine_s86*11.3;
liq86=liq_s86*14.0;

beer90=beer_s90*12.8;
rwine90=rwine_s90*11.3;
wwine90=wwine_s90*11.3;
liq90=liq_s90*14.0;

obeer94=beer_s94*12.8;
lbeer94=lbeer_s94*11.3;
rwine94=rwine_s94*11.3;
wwine94=wwine_s94*11.3;
liq94=liq_s94*14.0;

obeer98=beer_s98*12.8;
lbeer98=lbeer_s98*11.3;
rwine98=rwine_s98*11.3;
wwine98=wwine_s98*11.3;
liq98=liq_s98*14.0;

obeer02=beer_s02*12.8;
lbeer02=lbeer_s02*11.3;
rwine02=rwine_s02*11.3;
wwine02=wwine_s02*11.3;
liq02=liq_s02*14.0;

obeer06=beer_s06*12.8;
lbeer06=lbeer_s06*11.3;
rwine06=rwine_s06*14.1;
wwine06=wwine_s06*14.1;
liq06=liq_s06*14.0;

obeer10=beer_s10*12.8;
lbeer10=lbeer_s10*11.3;
rwine10=rwine_s10*14.1;
wwine10=wwine_s10*14.1;
liq10=liq_s10*14.0;



/*Create Total Alcohol Variables - alcxx*/
alc80=sum(beer80, rwine80, wwine80, liq80);
alc84=sum(beer84, rwine84, wwine84, liq84);
alc86=sum(beer86, rwine86, wwine86, liq86);
alc90=sum(beer90, rwine90, wwine90, liq90);
alc94=sum(obeer94, lbeer94, rwine94, wwine94, liq94);
alc98=sum(obeer98, lbeer98, rwine98, wwine98, liq98);
alc02=sum(obeer02, lbeer02, rwine02, wwine02, liq02);
alc06=sum(obeer06, lbeer06, rwine06, wwine06, liq06);
alc10=sum(obeer10, lbeer10, rwine10, wwine10, liq10);

/*Create Total Wine Variables - winexx*/
wine80=sum(rwine80, wwine80);
wine84=sum(rwine84, wwine84);
wine86=sum(rwine86, wwine86);
wine90=sum(rwine90, wwine90);
wine94=sum(rwine94, wwine94);
wine98=sum(rwine98, wwine98);
wine02=sum(rwine02, wwine02);
wine06=sum(rwine06, wwine06);
wine10=sum(rwine10, wwine10);

/*Create Total Beer Variables - beerxx*/
beer94=sum(obeer94, lbeer94);
beer98=sum(obeer98, lbeer98);
beer02=sum(obeer02, lbeer02);
beer06=sum(obeer06, lbeer06);
beer10=sum(obeer10, lbeer10);


keep id 
alc80 alc84 alc86 alc90 alc94 alc98 alc02 alc06 alc10
beer80 beer84 beer86 beer90 beer94 beer98 beer02 beer06 beer10 
wine80 wine84 wine86 wine90 wine94 wine98 wine02 wine06 wine10 
liq80 liq84 liq86 liq90 liq94 liq98 liq02 liq06 liq10 ;

run;



proc datasets;
    delete serv80 serv84 serv86 serv90 serv94 serv98 serv02 serv06 serv10;
run; 


proc means data=nhs_alcohol n nmiss min median mean max;
var 
alc80 alc84 alc86 alc90 alc94 alc98 alc02 alc06 alc10
beer80 beer84 beer86 beer90 beer94 beer98 beer02 beer06 beer10 
wine80 wine84 wine86 wine90 wine94 wine98 wine02 wine06 wine10 
liq80 liq84 liq86 liq90 liq94 liq98 liq02 liq06 liq10 ;
run;








