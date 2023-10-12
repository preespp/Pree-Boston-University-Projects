%Opening population data for all countries
Pop_country = readtable('Pop_data.csv');

Year = [1990;1995;2000;2005;2010;2015;2020;2025];

%creating table and choosing random countries to represent each continent.
Pop_ALL = table(Year);
Asia_pop = Pop_country(1:end,[3,4,10,17:23,26,31,33,36,39,40,45]);
order = randperm(width(Asia_pop));
Asia = (sum(table2array(Asia_pop(1:end,order(1:4)))'))';
Pop_ALL.Asia=Asia;

EU_pop = Pop_country(1:end,[8,28,35,42]);
order = randperm(width(EU_pop));
EU = (sum(table2array(EU_pop(1:end,order(1:4)))'))';
Pop_ALL.Europe=EU;

NA_pop = Pop_country(1:end,[7,16,24,44]);
order = randperm(width(NA_pop));
NA = (sum(table2array(NA_pop(1:end,order(1:4)))'))';
Pop_ALL.NA = NA;

SA_pop = Pop_country(1:end,[2,5,9,11,32,34,43]);
order = randperm(width(SA_pop));
SA = (sum(table2array(SA_pop(1:end,order(1:4)))'))';
Pop_ALL.SA = SA;

AFRICA_pop = Pop_country(1:end,[12:15,25,27,37,41,47,48]);
order = randperm(width(AFRICA_pop));
AFRICA = (sum(table2array(AFRICA_pop(1:end,order(1:4)))'))';
Pop_ALL.AFRICA = AFRICA;