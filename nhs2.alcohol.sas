/* read in alcohol type: serving/week covert to g/day */

/*
filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/';
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos/';
libname nhsfmt '/proj/nhsass/nhsas00/formats';
libname hpfsfmt '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing nhstools hpstools);
options fmtsearch=(nhsfmt hpfsfmt) nocenter nofmterr;
options ls=125 ps=78; */


/* serving/day */

%serv91(keep=beer_s91 lbeer_s91 rwine_s91 wwine_s91 liq_s91   coff_s91 dcaf_s91);run;
%serv95(keep=beer_s95 lbeer_s95 rwine_s95 wwine_s95 liq_s95   coff_s95 dcaf_s95);run;
%serv99(keep=beer_s99 lbeer_s99 rwine_s99 wwine_s99 liq_s99   coff_s99 dcaf_s99);run;
%serv03(keep=beer_s03 lbeer_s03 rwine_s03 wwine_s03 liq_s03   coff_s03 dcaf_s03);run;
%serv07(keep=beer_s07 lbeer_s07 rwine_s07 wwine_s07 liq_s07   coff_s07 dcaf_s07);run;
%serv11(keep=beer_s11 lbeer_s11 rwine_s11 wwine_s11 liq_s11   coff_s11 dcaf_s11);run;
%serv15(keep=beer_s15 lbeer_s15 rwine_s15 wwine_s15 liq_s15   coff_s15 dcaf_s15);run;


data nhs2_alcohol;
	merge  serv91 serv95 serv99 serv03 serv07 serv11 serv15 end=_end_;
	by id;


/* ethanol content for one serving of each alcoholic beverage 
14.0 g of alcohol for a 1.5 oz/44 mL serving of liquor, 
12.8 g for a 12 oz/355 mL serving of regular beer, or 11.3 g for light beer, 
11.3 g for a 4 oz/118 mL serving of wine
*/

obeer91=beer_s91*12.8;
lbeer91=lbeer_s91*11.3;
rwine91=rwine_s91*11.3;
wwine91=wwine_s91*11.3;
liq91=liq_s91*14.0;

obeer95=beer_s95*12.8;
lbeer95=lbeer_s95*11.3;
rwine95=rwine_s95*11.3;
wwine95=wwine_s95*11.3;
liq95=liq_s95*14.0;

obeer99=beer_s99*12.8;
lbeer99=lbeer_s99*11.3;
rwine99=rwine_s99*11.3;
wwine99=wwine_s99*11.3;
liq99=liq_s99*14.0;

obeer03=beer_s03*12.8;
lbeer03=lbeer_s03*11.3;
rwine03=rwine_s03*14.1;
wwine03=wwine_s03*14.1;
liq03=liq_s03*14.0;

obeer07=beer_s07*12.8;
lbeer07=lbeer_s07*11.3;
rwine07=rwine_s07*14.1;
wwine07=wwine_s07*14.1;
liq07=liq_s07*14.0;

obeer11=beer_s11*12.8;
lbeer11=lbeer_s11*11.3;
rwine11=rwine_s11*14.1;
wwine11=wwine_s11*14.1;
liq11=liq_s11*14.0;

obeer15=beer_s15*12.8;
lbeer15=lbeer_s15*11.3;
rwine15=rwine_s15*14.1;
wwine15=wwine_s15*14.1;
liq15=liq_s15*14.0;



/*Create Total Alcohol Variables - alcxx*/
alc91=sum(obeer91, lbeer91, rwine91, wwine91, liq91);
alc95=sum(obeer95, lbeer95, rwine95, wwine95, liq95);
alc99=sum(obeer99, lbeer99, rwine99, wwine99, liq99);
alc03=sum(obeer03, lbeer03, rwine03, wwine03, liq03);
alc07=sum(obeer07, lbeer07, rwine07, wwine07, liq07);
alc11=sum(obeer11, lbeer11, rwine11, wwine11, liq11);
alc15=sum(obeer15, lbeer15, rwine15, wwine15, liq15);

/*Create Total Wine Variables - winexx*/
wine91=sum(rwine91, wwine91);
wine95=sum(rwine95, wwine95);
wine99=sum(rwine99, wwine99);
wine03=sum(rwine03, wwine03);
wine07=sum(rwine07, wwine07);
wine11=sum(rwine11, wwine11);
wine15=sum(rwine15, wwine15);

/*Create Total Beer Variables - beerxx*/
beer91=sum(obeer91, lbeer91);
beer95=sum(obeer95, lbeer95);
beer99=sum(obeer99, lbeer99);
beer03=sum(obeer03, lbeer03);
beer07=sum(obeer07, lbeer07);
beer11=sum(obeer11, lbeer11);
beer15=sum(obeer15, lbeer15);



keep id 
alc91 alc95 alc99 alc03 alc07 alc11 alc15
beer91 beer95 beer99 beer03 beer07 beer11 beer15
wine91 wine95 wine99 wine03 wine07 wine11 wine15 
liq91 liq95 liq99 liq03 liq07 liq11 liq15;

run;



proc datasets;
    delete serv80 serv84 serv86 serv90 serv94 serv98 serv02 serv06 serv10;
run; 


proc means data=nhs2_alcohol n nmiss min median mean max;
var 
alc91 alc95 alc99 alc03 alc07 alc11 alc15
beer91 beer95 beer99 beer03 beer07 beer11 beer15
wine91 wine95 wine99 wine03 wine07 wine11 wine15 
liq91 liq95 liq99 liq03 liq07 liq11 liq15;
run;



