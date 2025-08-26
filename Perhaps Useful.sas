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















