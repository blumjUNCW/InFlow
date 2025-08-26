libname flow xlsx '~/InFlow/Northside Flows Clean 2005-2008.xlsx';

data flows;
  set flow.flowdata;
  OneDayPrevRain = lag1(Rain);
  ThreeDayPrevRain = lag3(Rain);
run;