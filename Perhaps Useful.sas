libname flow xlsx '~/InFlow/Northside Flows Clean 2005-2008.xlsx';

data flows;
  set flow.flowdata;
  OneDayPrevRain = lag1(Rain);
  ThreeDayPrevRain = lag3(Rain);
  TwoDayTotRain = lag1(Rain)+lag2(Rain);
  *TwoDayTotRain = rain+lag1(Rain);
  SevenDayTotRain = lag1(Rain)+lag2(Rain)+lag3(Rain)+lag4(Rain)+lag5(Rain)+lag6(Rain)+lag7(Rain);
run;

/**Look up the ARRAY statement for the DATA step

  Macro language?**/


data flows;
  set flow.flowdata;

  array RainAvg(3);
  array TempAvg(3);
  array HHTAvg(3);
  /**   ^^^ want to create these for some distance back in time (currently limited to 3 days)**/
  array RainLags(3);
  array TempLags(3);
  array HHTLags(3);
  /**   ^^^ I can use these to get those averages **/

  /**Set up all of the lagging I want...**/
  RainLags(1)=Lag1(Rain);RainLags(2)=Lag2(Rain);RainLags(3)=Lag3(Rain);
  TempLags(1)=Lag1(Temp);TempLags(2)=Lag2(Temp);TempLags(3)=Lag3(Temp);
  HHTLags(1)=Lag1(HHT);HHTLags(2)=Lag2(HHT);HHTLags(3)=Lag3(HHT);
  /**Not much fun, especially if we increase the look-back time window
    I can employ macro language to help me with this...**/  

  Retain tot:;
  TotRain=0;TotTemp=0;TotHHT=0;
  do j = 1 to 3;/**do across number of days the computing of averages**/
     TotRain=TotRain+RainLags(j);
     RainAvg(j)=TotRain/j;
     TotTemp=TotTemp+TempLags(j);
     TempAvg(j)=TotTemp/j;
     TotHHT=TotHHT+HHTLags(j);
     HHTAvg(j)=TotHHT/j;
  end;

  drop Tot:;
run;

%let days=3;/**macro variable days is assigned the value 3**/
options symbolgen; /**macro variables are also called symbols, symbolgen puts a message in the log each time one is evaluated**/
data flows;
  set flow.flowdata;

  array RainAvg(&days);/**Every &days is replaced by 3 during compilation**/
  array TempAvg(&days);
  array HHTAvg(&days);
  /**   ^^^ want to create these for some distance back in time (currently limited to 3 days)**/
  array RainLags(&days);
  array TempLags(&days);
  array HHTLags(&days);
  /**   ^^^ I can use these to get those averages **/

  /**Set up all of the lagging I want...**/
  RainLags(1)=Lag1(Rain);RainLags(2)=Lag2(Rain);RainLags(3)=Lag3(Rain);
  TempLags(1)=Lag1(Temp);TempLags(2)=Lag2(Temp);TempLags(3)=Lag3(Temp);
  HHTLags(1)=Lag1(HHT);HHTLags(2)=Lag2(HHT);HHTLags(3)=Lag3(HHT);
  /**Not much fun, especially if we increase the look-back time window
    I can employ macro language to help me with this...**/  

  Retain tot:;
  TotRain=0;TotTemp=0;TotHHT=0;
  do j = 1 to &days;/**do across number of days the computing of averages**/
     TotRain=TotRain+RainLags(j);
     RainAvg(j)=TotRain/j;
     TotTemp=TotTemp+TempLags(j);
     TempAvg(j)=TotTemp/j;
     TotHHT=TotHHT+HHTLags(j);
     HHTAvg(j)=TotHHT/j;
  end;

  drop Tot:;
run;


%macro CreateAvg(days); /**%macro defines a macro/function/module and possibly any parameters for it**/
                        /**%macro mymacro(parm1,parm2,...); %macro mymac(parm1=,parm2=default,...);**/
data flows;
  set flow.flowdata;

  array RainAvg(&days);/**Every &days is replaced by 3 during compilation**/
  array TempAvg(&days);
  array HHTAvg(&days);
  /**   ^^^ want to create these for some distance back in time (currently limited to 3 days)**/
  array RainLags(&days);
  array TempLags(&days);
  array HHTLags(&days);
  /**   ^^^ I can use these to get those averages **/

  /**Set up all of the lagging I want...**/
  RainLags(1)=Lag1(Rain);RainLags(2)=Lag2(Rain);RainLags(3)=Lag3(Rain);
  TempLags(1)=Lag1(Temp);TempLags(2)=Lag2(Temp);TempLags(3)=Lag3(Temp);
  HHTLags(1)=Lag1(HHT);HHTLags(2)=Lag2(HHT);HHTLags(3)=Lag3(HHT);
  /**Not much fun, especially if we increase the look-back time window
    I can employ macro language to help me with this...**/  

  Retain tot:;
  TotRain=0;TotTemp=0;TotHHT=0;
  do j = 1 to &days;/**do across number of days the computing of averages**/
     TotRain=TotRain+RainLags(j);
     RainAvg(j)=TotRain/j;
     TotTemp=TotTemp+TempLags(j);
     TempAvg(j)=TotTemp/j;
     TotHHT=TotHHT+HHTLags(j);
     HHTAvg(j)=TotHHT/j;
  end;

  drop Tot:;
run;
%mend;

%createAvg(4);/**call the macro with its name and parameter value choices**/


%macro CreateAvg(days); /**%macro defines a macro/function/module and possibly any parameters for it**/
                        /**%macro mymacro(parm1,parm2,...); %macro mymac(parm1=,parm2=default,...);**/
data flows;
  set flow.flowdata;

  array RainAvg(&days);/**Every &days is replaced by 3 during compilation**/
  array TempAvg(&days);
  array HHTAvg(&days);
  /**   ^^^ want to create these for some distance back in time (currently limited to 3 days)**/
  array RainLags(&days);
  array TempLags(&days);
  array HHTLags(&days);
  /**   ^^^ I can use these to get those averages **/

  /**Don't hard-code this, have it write as many as it needs for 
      the days request...

      write things like: RainLags(&j)=Lag&j(Rain); for j from 1 to days**/
  RainLags(1)=Lag1(Rain);RainLags(2)=Lag2(Rain);RainLags(3)=Lag3(Rain);
  TempLags(1)=Lag1(Temp);TempLags(2)=Lag2(Temp);TempLags(3)=Lag3(Temp);
  HHTLags(1)=Lag1(HHT);HHTLags(2)=Lag2(HHT);HHTLags(3)=Lag3(HHT);
  /**Not much fun, especially if we increase the look-back time window
    I can employ macro language to help me with this...**/  

  Retain tot:;
  TotRain=0;TotTemp=0;TotHHT=0;
  do j = 1 to &days;/**do across number of days the computing of averages**/
     TotRain=TotRain+RainLags(j);
     RainAvg(j)=TotRain/j;
     TotTemp=TotTemp+TempLags(j);
     TempAvg(j)=TotTemp/j;
     TotHHT=TotHHT+HHTLags(j);
     HHTAvg(j)=TotHHT/j;
  end;

  drop Tot:;
run;
%mend;





