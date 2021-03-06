%reproduce Nature Geo paper results

%load surface wind
u_wind_subset = permute(ncread('wind_subset2.nc','u10'),[2 1 3]);
[wind_anoms, windDates]= getMonthlyAnomalies(u_wind_subset,wndDates,1979,2010);
lat = double(ncread('wind_subset2.nc','latitude'));
lon = double(ncread('wind_subset2.nc','longitude'));


[map,pc]=eof(wind_anoms,1);

load monthly_nino_data.mat
nino34 = data(data(:,1)>=start_year & data(:,1)<=end_year,10);

corr(nino34,pc)

[sstA sstA_dates] = getMonthlyAnomalies(sst,sstDates,1979,2010);


%
        %sstA_year = getAnnualSSTAnomalies(i,i,1979,2010,sstA,sstA_dates);
[index, maxI, maxJ, minI, minJ, maxValues, minValues] = buildSSTLon(sstA, sstLat, sstLon);

        
for i=1:12
    clim(i) = mean(index(i:12:end));
end

cc = repmat(clim,1,32);
index_anom = index - cc';

corr(nino34,pc)
        
worldmap world
pcolorm(lat,lon,map)
coast = load('coast');
geoshow(coast.lat, coast.long, 'Color', 'black')

[a,az] = distnace(maxJ,maxI,minJ,minI);
corr(index,pc)