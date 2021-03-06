%predict trop temps
load('trop_warming_jan_1979_dec_2010.mat')
%load('ersstv3_1854_2012_raw.mat')
[sstA sstA_dates] = getMonthlyAnomalies(sst,sstDates,1979,2010);
annualSST = getAnnualSSTAnomalies(6,10, 1979, 2010, sstA, sstA_dates);
%build June-Oct index
[index_jun_oct, maxI__jun_oct, maxJ__jun_oct, minI__jun_oct, minJ__jun_oct, maxValues__jun_oct, minValues__jun_oct] = buildSSTLon(annualSST, sstLat, sstLon);
%
%monthly s-enso
[index, maxI, maxJ, minI, minJ, maxValues, minValues] = buildSSTLon(sstA, sstLat, sstLon);


