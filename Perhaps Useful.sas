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
  array RainLags(3);
  array TempLags(3);
  array HHTLags(3);

  RainLags(1)=Lag1(Rain);RainLags(2)=Lag2(Rain);RainLags3=Lag3(Rain);
  TempLags(1)=Lag1(Temp);TempLags(2)=Lag2(Temp);TempLags3=Lag3(Temp);
  HHTLags(1)=Lag1(HHT);HHTLags(2)=Lag2(HHT);HHTLags3=Lag3(HHT);
  
  Retain tot:;
  TotRain=0;TotTemp=0;TotHHT=0;
  do j = 1 to 3;
     TotRain=TotRain+RainLags(j);
     RainAvg(j)=TotRain/j;
     TotTemp=TotTemp+TempLags(j);
     TempAvg(j)=TotTemp/j;
     TotHHT=TotHHT+HHTLags(j);
     HHTAvg(j)=TotHHT/j;
  end;

  drop Tot:;
run;












