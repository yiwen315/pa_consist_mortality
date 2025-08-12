/* Purpose: HPFS, to read in total PA, moderate PA and vigorous PA, in MET hour/wk, and create consistency variables */

/*
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos/';
filename channing '/usr/local/channing/sasautos/';
libname hpsfmt '/proj/hpsass/hpsas00/formats/';
options mautosource sasautos=(channing hpstools);
options fmtsearch=(hpsfmt);
*/



 %hmet8620(keep =
    act86 wlk86 flt86 jog86 run86 bik86 swi86 ten86 raq86 row86    
    act88 wlk88 flt88 jog88 run88 bik88 swi88 ten88 raq88 row88 dig88
    act90 wlk90 flt90 jog90 run90 bik90 swi90 ten90 raq90 row90 dig90             lif90
    act92 wlk92 flt92 jog92 run92 bik92 swi92 ten92 raq92 row92 dig92             lif92
    act94 wlk94 flt94 jog94 run94 bik94 swi94 ten94 raq94 row94 dig94             lif94
    act96 wlk96 flt96 jog96 run96 bik96 swi96 ten96 raq96 row96 dig96             lif96
    act98 wlk98 flt98 jog98 run98 bik98 swi98 ten98 raq98 row98 dig98             lif98
    act00 wlk00 flt00 jog00 run00 bik00 swi00 ten00 raq00 row00 dig00             lif00
    act02 wlk02 flt02 jog02 run02 bik02 swi02 ten02 raq02 row02 dig02             lif02
    act04 wlk04 flt04 jog04 run04 bik04 swi04 ten04 raq04 row04       mod04 hod04 lif04
    act06 wlk06 flt06 jog06 run06 bik06 swi06 ten06 raq06 row06       mod06 hod06 lif06
    act08 wlk08 flt08 jog08 run08 bik08 swi08 ten08 raq08 row08       mod08 hod08 lif08
    act10 wlk10 flt10 jog10 run10 bik10 swi10 ten10 sqa10 aer10 lin10 mod10 hod10 wta10 wtl10 
    act12 wlk12 flt12 jog12 run12 bik12 swi12 ten12 sqa12 aer12 lin12 mod12 hod12 wta12 wtl12
    act14 wlk14 flt14 jog14 run14 bik14 swi14 ten14       aer14 lin14 mod14 hod14 wta14 wtl14
    act16 wlk16       jog16 run16       swi16 ten16       aer16 lin16             wta16 wtl16 biks16 bikp16 bikr16 ovig16    
    act20 wlk20       jog20 run20       swi20 ten20       aer20 lin20             wta20 wtl20 biks20 bikp20 bikr20 ovig20
)
;  
run;

/* 
rowxx: other aerobics, e.g., calisthenics, rowing, ski...
aerxx: aerobic exercise
linxx: low intensity exercise 
modxx: moderate outdoor work
hodxx: heavy outdoor work 
*/

data PA_hpfs; set hmet8620;

  array  act{*}

    act86 wlk86 flt86 jog86 run86 bik86 swi86 ten86 raq86 row86    
    act88 wlk88 flt88 jog88 run88 bik88 swi88 ten88 raq88 row88 dig88
    act90 wlk90 flt90 jog90 run90 bik90 swi90 ten90 raq90 row90 dig90             lif90
    act92 wlk92 flt92 jog92 run92 bik92 swi92 ten92 raq92 row92 dig92             lif92
    act94 wlk94 flt94 jog94 run94 bik94 swi94 ten94 raq94 row94 dig94             lif94
    act96 wlk96 flt96 jog96 run96 bik96 swi96 ten96 raq96 row96 dig96             lif96
    act98 wlk98 flt98 jog98 run98 bik98 swi98 ten98 raq98 row98 dig98             lif98
    act00 wlk00 flt00 jog00 run00 bik00 swi00 ten00 raq00 row00 dig00             lif00
    act02 wlk02 flt02 jog02 run02 bik02 swi02 ten02 raq02 row02 dig02             lif02
    act04 wlk04 flt04 jog04 run04 bik04 swi04 ten04 raq04 row04       mod04 hod04 lif04
    act06 wlk06 flt06 jog06 run06 bik06 swi06 ten06 raq06 row06       mod06 hod06 lif06
    act08 wlk08 flt08 jog08 run08 bik08 swi08 ten08 raq08 row08       mod08 hod08 lif08
    act10 wlk10 flt10 jog10 run10 bik10 swi10 ten10 sqa10 aer10 lin10 mod10 hod10 wta10 wtl10
    act12 wlk12 flt12 jog12 run12 bik12 swi12 ten12 sqa12 aer12 lin12 mod12 hod12 wta12 wtl12
    act14 wlk14 flt14 jog14 run14 bik14 swi14 ten14       aer14 lin14 mod14 hod14 wta14 wtl14
    act16 wlk16       jog16 run16       swi16 ten16       aer16 lin16             wta16 wtl16 biks16 bikp16 bikr16 ovig16  
    act20 wlk20       jog20 run20       swi20 ten20       aer20 lin20             wta20 wtl20 biks20 bikp20 bikr20 ovig20  
;

  array  miss{*}

    act86m wlk86m flt86m jog86m run86m bik86m swi86m ten86m raq86m row86m    
    act88m wlk88m flt88m jog88m run88m bik88m swi88m ten88m raq88m row88m dig88m
    act90m wlk90m flt90m jog90m run90m bik90m swi90m ten90m raq90m row90m dig90m               lif90m
    act92m wlk92m flt92m jog92m run92m bik92m swi92m ten92m raq92m row92m dig92m               lif92m
    act94m wlk94m flt94m jog94m run94m bik94m swi94m ten94m raq94m row94m dig94m               lif94m
    act96m wlk96m flt96m jog96m run96m bik96m swi96m ten96m raq96m row96m dig96m               lif96m
    act98m wlk98m flt98m jog98m run98m bik98m swi98m ten98m raq98m row98m dig98m               lif98m
    act00m wlk00m flt00m jog00m run00m bik00m swi00m ten00m raq00m row00m dig00m               lif00m
    act02m wlk02m flt02m jog02m run02m bik02m swi02m ten02m raq02m row02m dig02m               lif02m
    act04m wlk04m flt04m jog04m run04m bik04m swi04m ten04m raq04m row04m        mod04m hod04m lif04m
    act06m wlk06m flt06m jog06m run06m bik06m swi06m ten06m raq06m row06m        mod06m hod06m lif06m
    act08m wlk08m flt08m jog08m run08m bik08m swi08m ten08m raq08m row08m        mod08m hod08m lif08m
    act10m wlk10m flt10m jog10m run10m bik10m swi10m ten10m sqa10m aer10m lin10m mod10m hod10m wta10m wtl10m
    act12m wlk12m flt12m jog12m run12m bik12m swi12m ten12m sqa12m aer12m lin12m mod12m hod12m wta12m wtl12m
    act14m wlk14m flt14m jog14m run14m bik14m swi14m ten14m        aer14m lin14m mod14m hod14m wta14m wtl14m
    act16m wlk16m        jog16m run16m        swi16m ten16m        aer16m lin16m               wta16m wtl16m biks16m bikp16m bikr16m ovig16m    
    act20m wlk20m        jog20m run20m        swi20m ten20m        aer20m lin20m               wta20m wtl20m biks20m bikp20m bikr20m ovig20m
;
  
    do j=1 to dim(act); 
    miss{j}=act{j};
    end;

    do j=1 to dim(act); 
    if act(j)<0 or act(j)>=998 then miss{j}=.; /*pass thru is 998 and missing 999*/
    end;


/* Total PA using regular questionnaire only */

  totalpa86m = sum(wlk86m, flt86m, jog86m, run86m, bik86m, swi86m, ten86m, raq86m, row86m);
  totalpa88m = sum(wlk88m, flt88m, jog88m, run88m, bik88m, swi88m, ten88m, raq88m, row88m, dig88m);
  totalpa90m = sum(wlk90m, flt90m, jog90m, run90m, bik90m, swi90m, ten90m, raq90m, row90m, dig90m, lif90m);
  totalpa92m = sum(wlk92m, flt92m, jog92m, run92m, bik92m, swi92m, ten92m, raq92m, row92m, dig92m, lif92m);
  totalpa94m = sum(wlk94m, flt94m, jog94m, run94m, bik94m, swi94m, ten94m, raq94m, row94m, dig94m, lif94m);
  totalpa96m = sum(wlk96m, flt96m, jog96m, run96m, bik96m, swi96m, ten96m, raq96m, row96m, dig96m, lif96m);
  totalpa98m = sum(wlk98m, flt98m, jog98m, run98m, bik98m, swi98m, ten98m, raq98m, row98m, dig98m, lif98m);
  totalpa00m = sum(wlk00m, flt00m, jog00m, run00m, bik00m, swi00m, ten00m, raq00m, row00m, dig00m, lif00m);
  totalpa02m = sum(wlk02m, flt02m, jog02m, run02m, bik02m, swi02m, ten02m, raq02m, row02m, dig02m, lif02m);
  totalpa04m = sum(wlk04m, flt04m, jog04m, run04m, bik04m, swi04m, ten04m, raq04m, row04m,        mod04m, hod04m, lif04m);
  totalpa06m = sum(wlk06m, flt06m, jog06m, run06m, bik06m, swi06m, ten06m, raq06m, row06m,        mod06m, hod06m, lif06m);
  totalpa08m = sum(wlk08m, flt08m, jog08m, run08m, bik08m, swi08m, ten08m, raq08m, row08m,        mod08m, hod08m, lif08m);
  totalpa10m = sum(wlk10m, flt10m, jog10m, run10m, bik10m, swi10m, ten10m, sqa10m, aer10m, lin10m, mod10m, hod10m, wta10m, wtl10m);
  totalpa12m = sum(wlk12m, flt12m, jog12m, run12m, bik12m, swi12m, ten12m, sqa12m, aer12m, lin12m, mod12m, hod12m, wta12m, wtl12m);
  totalpa14m = sum(wlk14m, flt14m, jog14m, run14m, bik14m, swi14m, ten14m,         aer14m, lin14m, mod14m, hod14m, wta14m, wtl14m);
  totalpa16m = sum(wlk16m,         jog16m, run16m,         swi16m, ten16m,         aer16m, lin16m,                 wta16m, wtl16m, biks16m, bikp16m, bikr16m, ovig16m);
  totalpa20m = sum(wlk20m,         jog20m, run20m,         swi20m, ten20m,         aer20m, lin20m,                 wta20m, wtl20m, biks20m, bikp20m, bikr20m, ovig20m);

/*Moderate physical activity in METs-h/week
MET<6
walking, 
digging (MET=5.5),
moderate outdoor activity (MET=4.5),
heavy outdoor activity (MET=5.5),
weightligting (MET=5.5), 
low-intensity exerise,yoga,stretch (MET=3)
*/

  modpa86m = sum(wlk86m); 
  modpa88m = sum(wlk88m, dig88m); 
  modpa90m = sum(wlk86m, dig90m, lif90m);    
  modpa92m = sum(wlk92m, dig92m, lif92m);    
  modpa94m = sum(wlk94m, dig94m, lif94m);  
  modpa96m = sum(wlk96m, dig96m, lif96m);
  modpa98m = sum(wlk98m, dig98m, lif98m); 
  modpa00m = sum(wlk00m, dig00m, lif00m); 
  modpa02m = sum(wlk02m, dig02m, lif02m); 
  modpa04m = sum(wlk04m,         lif04m,         mod04m, hod04m); 
  modpa06m = sum(wlk06m,         lif06m,         mod06m, hod06m); 
  modpa08m = sum(wlk08m,         lif08m,         mod08m, hod08m);     
  modpa10m = sum(wlk10m,         wta10m, wtl10m, mod10m, hod10m, lin10m); 
  modpa12m = sum(wlk12m,         wta12m, wtl12m, mod12m, hod12m, lin12m); 
  modpa14m = sum(wlk14m,         wta14m, wtl14m, mod14m, hod14m, lin14m); 
  modpa16m = sum(wlk16m,         wta16m, wtl16m,                 lin16m); 
  modpa20m = sum(wlk20m,         wta20m, wtl20m,                 lin20m); 


/*Vigorous physical activity in METs-h/week
MET>=6
jogging, 
running, 
biking, 
swimming
tennis, 
racquetball,
row/other aerobics
other vigorous activites,lawn mowing (MET=6),
stair climbing (MET=8.5)
*/

  vigpa86m = sum(flt86m, jog86m, run86m, bik86m, swi86m, ten86m, raq86m, row86m);
  vigpa88m = sum(flt88m, jog88m, run88m, bik88m, swi88m, ten88m, raq88m, row88m);
  vigpa90m = sum(flt90m, jog90m, run90m, bik90m, swi90m, ten90m, raq90m, row90m);
  vigpa92m = sum(flt92m, jog92m, run92m, bik92m, swi92m, ten92m, raq92m, row92m);
  vigpa94m = sum(flt94m, jog94m, run94m, bik94m, swi94m, ten94m, raq94m, row94m);
  vigpa96m = sum(flt96m, jog96m, run96m, bik96m, swi96m, ten96m, raq96m, row96m);
  vigpa98m = sum(flt98m, jog98m, run98m, bik98m, swi98m, ten98m, raq98m, row98m);
  vigpa00m = sum(flt00m, jog00m, run00m, bik00m, swi00m, ten00m, raq00m, row00m);
  vigpa02m = sum(flt02m, jog02m, run02m, bik02m, swi02m, ten02m, raq02m, row02m);
  vigpa04m = sum(flt04m, jog04m, run04m, bik04m, swi04m, ten04m, raq04m, row04m);
  vigpa06m = sum(flt06m, jog06m, run06m, bik06m, swi06m, ten06m, raq06m, row06m);
  vigpa08m = sum(flt08m, jog08m, run08m, bik08m, swi08m, ten08m, raq08m, row08m);
  vigpa10m = sum(flt10m, jog10m, run10m, bik10m, swi10m, ten10m, sqa10m, aer10m);
  vigpa12m = sum(flt12m, jog12m, run12m, bik12m, swi12m, ten12m, sqa12m, aer12m);
  vigpa14m = sum(flt14m, jog14m, run14m, bik14m, swi14m, ten14m,         aer14m);
  vigpa16m = sum(        jog16m, run16m,         swi16m, ten16m,         aer16m, biks16m, bikp16m, bikr16m, ovig16m);
  vigpa20m = sum(        jog20m, run20m,         swi20m, ten20m,         aer20m, biks20m, bikp20m, bikr20m, ovig20m);



/*Aerobics vs resistance training*/

  respa90m = lif90m;
  respa92m = lif92m;
  respa94m = lif94m;
  respa96m = lif96m;
  respa96m = lif96m;
  respa98m = lif98m;
  respa00m = lif00m;
  respa02m = lif02m;
  respa04m = lif04m;
  respa06m = lif06m;
  respa08m = lif08m;
  respa10m = sum(wta10m, wtl10m);
  respa12m = sum(wta12m, wtl12m);
  respa14m = sum(wta14m, wtl14m);
  respa16m = sum(wta16m, wtl16m);
  respa20m = sum(wta20m, wtl20m);

/* walking was at any pace  */
  aerpa86m = sum(wlk86m, flt86m, jog86m, run86m, bik86m, swi86m, ten86m, raq86m, row86m);
  aerpa88m = sum(wlk88m, flt88m, jog88m, run88m, bik88m, swi88m, ten88m, raq88m, row88m, dig88m);
  aerpa90m = sum(wlk90m, flt90m, jog90m, run90m, bik90m, swi90m, ten90m, raq90m, row90m, dig90m);
  aerpa92m = sum(wlk92m, flt92m, jog92m, run92m, bik92m, swi92m, ten92m, raq92m, row92m, dig92m);
  aerpa94m = sum(wlk94m, flt94m, jog94m, run94m, bik94m, swi94m, ten94m, raq94m, row94m, dig94m);
  aerpa96m = sum(wlk96m, flt96m, jog96m, run96m, bik96m, swi96m, ten96m, raq96m, row96m, dig96m);
  aerpa98m = sum(wlk98m, flt98m, jog98m, run98m, bik98m, swi98m, ten98m, raq98m, row98m, dig98m);
  aerpa00m = sum(wlk00m, flt00m, jog00m, run00m, bik00m, swi00m, ten00m, raq00m, row00m, dig00m);
  aerpa02m = sum(wlk02m, flt02m, jog02m, run02m, bik02m, swi02m, ten02m, raq02m, row02m, dig02m);
  aerpa04m = sum(wlk04m, flt04m, jog04m, run04m, bik04m, swi04m, ten04m, raq04m, row04m,         mod04m, hod04m);
  aerpa06m = sum(wlk06m, flt06m, jog06m, run06m, bik06m, swi06m, ten06m, raq06m, row06m,         mod06m, hod06m);
  aerpa08m = sum(wlk08m, flt08m, jog08m, run08m, bik08m, swi08m, ten08m, raq08m, row08m,         mod08m, hod08m);
  aerpa10m = sum(wlk10m, flt10m, jog10m, run10m, bik10m, swi10m, ten10m, sqa10m, aer10m, lin10m, mod10m, hod10m);
  aerpa12m = sum(wlk12m, flt12m, jog12m, run12m, bik12m, swi12m, ten12m, sqa12m, aer12m, lin12m, mod12m, hod12m);
  aerpa14m = sum(wlk14m, flt14m, jog14m, run14m, bik14m, swi14m, ten14m,         aer14m, lin14m, mod14m, hod14m);
  aerpa16m = sum(wlk16m,         jog16m, run16m,         swi16m, ten16m,         aer16m, lin16m,                 biks16m, bikp16m, bikr16m, ovig16m);
  aerpa20m = sum(wlk20m,         jog20m, run20m,         swi20m, ten20m,         aer20m, lin20m,                 biks20m, bikp20m, bikr20m, ovig20m);

run;


/* exclude those with unreasonable PA > 250 met-h/wk - reference: Channing physical activity file  */
data PA_hpfs; set PA_hpfs;
if totalpa86m>250 then delete;
if totalpa88m>250 then delete;
if totalpa90m>250 then delete;
if totalpa92m>250 then delete;
if totalpa94m>250 then delete;
if totalpa96m>250 then delete;
if totalpa98m>250 then delete;
if totalpa00m>250 then delete;
if totalpa02m>250 then delete;
if totalpa04m>250 then delete;
if totalpa06m>250 then delete;
if totalpa08m>250 then delete;
if totalpa10m>250 then delete;
if totalpa12m>250 then delete;
if totalpa14m>250 then delete;
if totalpa16m>250 then delete;
if totalpa20m>250 then delete;
run;


/* Calculate percentage of follow-up years meeting the recommende level >=7.5 MET-hours/week, using raw physical activity variables */
data PA_hpfs;
  set PA_hpfs;

 array totalpa {*} totalpa86m totalpa88m totalpa90m totalpa92m totalpa94m totalpa96m totalpa98m totalpa00m totalpa02m totalpa04m totalpa06m totalpa08m totalpa10m totalpa12m totalpa14m totalpa16m totalpa20m;
 array reporty {*} report86 report88 report90 report92 report94 report96 report98 report00 report02 report04 report06 report08 report10 report12 report14 report16 report20; 
 array targety {*} meet86 meet88 meet90 meet92 meet94 meet96 meet98 meet00 meet02 meet04 meet06 meet08 meet10 meet12 meet14 meet16 meet20; 


/* count how many times reported */
 do i=1 to dim(totalpa); 
    
    reporty{i}=.;
    if totalpa{i} ne . then reporty{i}=1; 

 end;

treport86 = report86;
treport88 = sum(report86, report88);
treport90 = sum(report86, report88, report90);
treport92 = sum(report86, report88, report90, report92);
treport94 = sum(report86, report88, report90, report92, report94);
treport96 = sum(report86, report88, report90, report92, report94, report96);
treport98 = sum(report86, report88, report90, report92, report94, report96, report98);
treport00 = sum(report86, report88, report90, report92, report94, report96, report98, report00);
treport02 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02);
treport04 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02, report04);
treport06 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02, report04, report06);
treport08 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02, report04, report06, report08);
treport10 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02, report04, report06, report08, report10);
treport12 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02, report04, report06, report08, report10, report12);
treport14 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02, report04, report06, report08, report10, report12, report14);
treport16 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02, report04, report06, report08, report10, report12, report14, report16);
treport20 = sum(report86, report88, report90, report92, report94, report96, report98, report00, report02, report04, report06, report08, report10, report12, report14, report16, report20);


/* count how many times meet guideline */
 do i=1 to dim(totalpa); 

    targety{i}=.;
    if totalpa{i}>=7.5 then targety{i}=1;
    if totalpa{i}<7.5 then targety{i}=0; 

 end;

ttarget86 = meet86;
ttarget88 = sum(meet86, meet88);
ttarget90 = sum(meet86, meet88, meet90);
ttarget92 = sum(meet86, meet88, meet90, meet92);
ttarget94 = sum(meet86, meet88, meet90, meet92, meet94);
ttarget96 = sum(meet86, meet88, meet90, meet92, meet94, meet96);
ttarget98 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98);
ttarget00 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00);
ttarget02 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02);
ttarget04 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02, meet04);
ttarget06 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02, meet04, meet06);
ttarget08 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02, meet04, meet06, meet08);
ttarget10 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02, meet04, meet06, meet08, meet10);
ttarget12 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02, meet04, meet06, meet08, meet10, meet12);
ttarget14 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02, meet04, meet06, meet08, meet10, meet12, meet14);
ttarget16 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02, meet04, meet06, meet08, meet10, meet12, meet14, meet16);
ttarget20 = sum(meet86, meet88, meet90, meet92, meet94, meet96, meet98, meet00, meet02, meet04, meet06, meet08, meet10, meet12, meet14, meet16, meet20);


/* calculate percentage */
 array treport {*} treport86 treport88 treport90 treport92 treport94 treport96 treport98 treport00 treport02 treport04 treport06 treport08 treport10 treport12 treport14 treport16 treport20; 
 array ttarget {*} ttarget86 ttarget88 ttarget90 ttarget92 ttarget94 ttarget96 ttarget98 ttarget00 ttarget02 ttarget04 ttarget06 ttarget08 ttarget10 ttarget12 ttarget14 ttarget16 ttarget20; 
 array pctmeet {*} pctmeet86 pctmeet88 pctmeet90 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet02 pctmeet04 pctmeet06 pctmeet08 pctmeet10 pctmeet12 pctmeet14 pctmeet16 pctmeet20; 

 do i=1 to dim(treport);

    pctmeet{i}=.; 
    if treport{i} ne . and ttarget{i} ne . then pctmeet{i} = ttarget{i} / treport{i}; 

 end;




/* alternative cut-off of meeting guideline: >=5 */

array targetty {*} meett86 meett88 meett90 meett92 meett94 meett96 meett98 meett00 meett02 meett04 meett06 meett08 meett10 meett12 meett14 meett16 meett20; 

 do i=1 to dim(totalpa); 

    targetty{i}=.;
    if totalpa{i}>=5 then targetty{i}=1;
    if totalpa{i}<5 then targetty{i}=0; 

 end;

ttargett86 = meett86;
ttargett88 = sum(meett86, meett88);
ttargett90 = sum(meett86, meett88, meett90);
ttargett92 = sum(meett86, meett88, meett90, meett92);
ttargett94 = sum(meett86, meett88, meett90, meett92, meett94);
ttargett96 = sum(meett86, meett88, meett90, meett92, meett94, meett96);
ttargett98 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98);
ttargett00 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00);
ttargett02 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02);
ttargett04 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02, meett04);
ttargett06 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02, meett04, meett06);
ttargett08 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02, meett04, meett06, meett08);
ttargett10 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02, meett04, meett06, meett08, meett10);
ttargett12 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02, meett04, meett06, meett08, meett10, meett12);
ttargett14 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02, meett04, meett06, meett08, meett10, meett12, meett14);
ttargett16 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02, meett04, meett06, meett08, meett10, meett12, meett14, meett16);
ttargett20 = sum(meett86, meett88, meett90, meett92, meett94, meett96, meett98, meett00, meett02, meett04, meett06, meett08, meett10, meett12, meett14, meett16, meett20);


array ttargett {*} ttargett86 ttargett88 ttargett90 ttargett92 ttargett94 ttargett96 ttargett98 ttargett00 ttargett02 ttargett04 ttargett06 ttargett08 ttargett10 ttargett12 ttargett14 ttargett16 ttargett20; 
array pctmeett {*} pctmeett86 pctmeett88 pctmeett90 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett02 pctmeett04 pctmeett06 pctmeett08 pctmeett10 pctmeett12 pctmeett14 pctmeett16 pctmeett20; 


 do i=1 to dim(treport);

    pctmeett{i}=.; 
    if treport{i} ne . and ttargett{i} ne . then pctmeett{i} = ttargett{i} / treport{i}; 

 end;





/* alternative cut-off of meeting guideline: >=15 */

array targettty {*} meettt86 meettt88 meettt90 meettt92 meettt94 meettt96 meettt98 meettt00 meettt02 meettt04 meettt06 meettt08 meettt10 meettt12 meettt14 meettt16 meettt20; 

 do i=1 to dim(totalpa); 

    targettty{i}=.;
    if totalpa{i}>=15 then targettty{i}=1;
    if totalpa{i}<15  then targettty{i}=0; 

 end;

ttargettt86 = meettt86;
ttargettt88 = sum(meettt86, meettt88);
ttargettt90 = sum(meettt86, meettt88, meettt90);
ttargettt92 = sum(meettt86, meettt88, meettt90, meettt92);
ttargettt94 = sum(meettt86, meettt88, meettt90, meettt92, meettt94);
ttargettt96 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96);
ttargettt98 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98);
ttargettt00 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00);
ttargettt02 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02);
ttargettt04 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02, meettt04);
ttargettt06 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02, meettt04, meettt06);
ttargettt08 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02, meettt04, meettt06, meettt08);
ttargettt10 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02, meettt04, meettt06, meettt08, meettt10);
ttargettt12 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02, meettt04, meettt06, meettt08, meettt10, meettt12);
ttargettt14 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02, meettt04, meettt06, meettt08, meettt10, meettt12, meettt14);
ttargettt16 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02, meettt04, meettt06, meettt08, meettt10, meettt12, meettt14, meettt16);
ttargettt20 = sum(meettt86, meettt88, meettt90, meettt92, meettt94, meettt96, meettt98, meettt00, meettt02, meettt04, meettt06, meettt08, meettt10, meettt12, meettt14, meettt16, meettt20);


 array ttargettt {*} ttargettt86 ttargettt88 ttargettt90 ttargettt92 ttargettt94 ttargettt96 ttargettt98 ttargettt00 ttargettt02 ttargettt04 ttargettt06 ttargettt08 ttargettt10 ttargettt12 ttargettt14 ttargettt16 ttargettt20; 
 array pctmeettt {*} pctmeettt86 pctmeettt88 pctmeettt90 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt02 pctmeettt04 pctmeettt06 pctmeettt08 pctmeettt10 pctmeettt12 pctmeettt14 pctmeettt16 pctmeettt20; 

 do i=1 to dim(treport);

    pctmeettt{i}=.; 
    if treport{i} ne . and ttargettt{i} ne . then pctmeettt{i} = ttargettt{i} / treport{i}; 

 end;



run;





proc means data=PA_hpfs n nmiss min median mean max;
var 
totalpa86m totalpa88m totalpa90m totalpa92m totalpa94m totalpa96m totalpa98m totalpa00m totalpa02m totalpa04m totalpa06m totalpa08m totalpa10m totalpa12m totalpa14m totalpa16m totalpa20m
modpa86m modpa88m modpa90m modpa92m modpa94m modpa96m modpa98m modpa00m modpa02m modpa04m modpa06m modpa08m modpa10m modpa12m modpa14m modpa16m modpa20m
vigpa86m vigpa88m vigpa90m vigpa92m vigpa94m vigpa96m vigpa98m vigpa00m vigpa02m vigpa04m vigpa06m vigpa08m vigpa10m vigpa12m vigpa14m vigpa16m vigpa20m
                  respa90m respa92m respa94m respa96m respa98m respa00m respa02m respa04m respa06m respa08m respa10m respa12m respa14m respa16m respa20m
aerpa86m aerpa88m aerpa90m aerpa92m aerpa94m aerpa96m aerpa98m aerpa00m aerpa02m aerpa04m aerpa06m aerpa08m aerpa10m aerpa12m aerpa14m aerpa16m aerpa20m
;

run;

proc freq data=PA_hpfs;
  tables treport86 treport88 treport90 treport92 treport94 treport96 treport98 treport00 treport02 treport04 treport06 treport08 treport10 treport12 treport14 treport16 treport20
         ttarget86 ttarget88 ttarget90 ttarget92 ttarget94 ttarget96 ttarget98 ttarget00 ttarget02 ttarget04 ttarget06 ttarget08 ttarget10 ttarget12 ttarget14 ttarget16 ttarget20/missing;
run;


proc means data=PA_hpfs nmiss min max median mean;
  var pctmeet86 pctmeet88 pctmeet90 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet02 pctmeet04 pctmeet06 pctmeet08 pctmeet10 pctmeet12 pctmeet14 pctmeet16 pctmeet20
      pctmeett86 pctmeett88 pctmeett90 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett02 pctmeett04 pctmeett06 pctmeett08 pctmeett10 pctmeett12 pctmeett14 pctmeett16 pctmeett20
      pctmeettt86 pctmeettt88 pctmeettt90 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt02 pctmeettt04 pctmeettt06 pctmeettt08 pctmeettt10 pctmeettt12 pctmeettt14 pctmeettt16 pctmeettt20
  ; 
run;

 

data hpfs_pa_met;
    set PA_hpfs;
    keep id 
totalpa86m totalpa88m totalpa90m totalpa92m totalpa94m totalpa96m totalpa98m totalpa00m totalpa02m totalpa04m totalpa06m totalpa08m totalpa10m totalpa12m totalpa14m totalpa16m totalpa20m
modpa86m modpa88m modpa90m modpa92m modpa94m modpa96m modpa98m modpa00m modpa02m modpa04m modpa06m modpa08m modpa10m modpa12m modpa14m modpa16m modpa20m
vigpa86m vigpa88m vigpa90m vigpa92m vigpa94m vigpa96m vigpa98m vigpa00m vigpa02m vigpa04m vigpa06m vigpa08m vigpa10m vigpa12m vigpa14m vigpa16m vigpa20m
                  respa90m respa92m respa94m respa96m respa98m respa00m respa02m respa04m respa06m respa08m respa10m respa12m respa14m respa16m respa20m
aerpa86m aerpa88m aerpa90m aerpa92m aerpa94m aerpa96m aerpa98m aerpa00m aerpa02m aerpa04m aerpa06m aerpa08m aerpa10m aerpa12m aerpa14m aerpa16m aerpa20m

pctmeet86 pctmeet88 pctmeet90 pctmeet92 pctmeet94 pctmeet96 pctmeet98 pctmeet00 pctmeet02 pctmeet04 pctmeet06 pctmeet08 pctmeet10 pctmeet12 pctmeet14 pctmeet16 pctmeet20
pctmeett86 pctmeett88 pctmeett90 pctmeett92 pctmeett94 pctmeett96 pctmeett98 pctmeett00 pctmeett02 pctmeett04 pctmeett06 pctmeett08 pctmeett10 pctmeett12 pctmeett14 pctmeett16 pctmeett20
pctmeettt86 pctmeettt88 pctmeettt90 pctmeettt92 pctmeettt94 pctmeettt96 pctmeettt98 pctmeettt00 pctmeettt02 pctmeettt04 pctmeettt06 pctmeettt08 pctmeettt10 pctmeettt12 pctmeettt14 pctmeettt16 pctmeettt20

treport86 treport88 treport90 treport92 treport94 treport96 treport98 treport00 treport02 treport04 treport06 treport08 treport10 treport12 treport14 treport16 treport20

;
run;


proc datasets;
    delete hmet8620 PA_hpfs;
run; 


