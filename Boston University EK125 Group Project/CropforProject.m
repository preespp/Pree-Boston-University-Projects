%import the data and start scrubbing the data by delete the columns we
%don't use
crop = table2struct(readtable('crop_production.csv','PreserveVariableNames',true));
%crop2 to show the original data before scrubbing
crop2 = table2struct(readtable('crop_production.csv','PreserveVariableNames',true));
crop = rmfield(crop,'FlagCodes');
crop = rmfield(crop,'FREQUENCY');
crop = rmfield(crop,'INDICATOR');
crop = rmfield(crop,'index');

%delete the data of Thousands hector and Thousands tonne
%since the data of tonnes per hector already included and calculated
i = 1;
while i <= length(crop)
    if crop(i).MEASURE == "THND_HA" || crop(i).MEASURE == "THND_TONNE"
        crop(i) = [];
    else
        i=i+1;
    end
end

%we separate each type of crops to Rice, Maize,Soybean, and Wheat
%the following code is the code that allocate which type of each data set
%will be in. And, create the table then convert to variables type struct 
%(Rice, Wheat, Maize, Soybean)

riceLoc = [];
riceTim = [];
riceVal = [];
for i = 1:length(crop)
    if crop(i).SUBJECT == "RICE"
        riceLoc = [riceLoc; convertCharsToStrings(crop(i).LOCATION)];
        riceTim = [riceTim; crop(i).TIME];
        riceVal = [riceVal; crop(i).Value];
    end
end

Rice = table2struct(table(riceLoc,riceTim,riceVal));

wheatLoc = [];
wheatTim = [];
wheatVal = [];
for i = 1:length(crop)
    if crop(i).SUBJECT == "WHEAT"
        wheatLoc = [wheatLoc; convertCharsToStrings(crop(i).LOCATION)];
        wheatTim = [wheatTim; crop(i).TIME];
        wheatVal = [wheatVal; crop(i).Value];
    end
end

Wheat = table2struct(table(wheatLoc,wheatTim,wheatVal));

maizeLoc = [];
maizeTim = [];
maizeVal = [];
for i = 1:length(crop)
    if crop(i).SUBJECT == "MAIZE"
        maizeLoc = [maizeLoc; convertCharsToStrings(crop(i).LOCATION)];
        maizeTim = [maizeTim; crop(i).TIME];
        maizeVal = [maizeVal; crop(i).Value];
    end
end

Maize = table2struct(table(maizeLoc,maizeTim,maizeVal));

soybeanLoc = [];
soybeanTim = [];
soybeanVal = [];
for i = 1:length(crop)
    if crop(i).SUBJECT == "SOYBEAN"
        soybeanLoc = [soybeanLoc; convertCharsToStrings(crop(i).LOCATION)];
        soybeanTim = [soybeanTim; crop(i).TIME];
        soybeanVal = [soybeanVal; crop(i).Value];
    end
end

Soybean = table2struct(table(soybeanLoc,soybeanTim,soybeanVal));

%we create vector of every country's name.
%EU28 is a exception case because they didn't calculate the Tonnes/Hectors data for us
%When we scrubbed the data, we already delete Tonnes and Hectors
%Therefore, we decide to delete EU28

Allcountries = unique(riceLoc);
Allcountries(Allcountries=="EU28")=[];

%create vector of Time 1990-2025
Time = [];
for i = 1990:2025
    Time = [Time; i];
end

%to shuffle random order every time
rng shuffle

%create an allannual variable to store the total amount of crop for each
%country and each year
allannual = zeros(length(Time),1+length(Allcountries));
allannual(1:length(Time),1) = Time;
for a = 1:27
    allannual(1:length(Time),a+1) = calannual(a,Maize,Soybean,Rice,Wheat,Allcountries);
end
for a = 30:44
    allannual(1:length(Time),a+1) = calannual(a,Maize,Soybean,Rice,Wheat,Allcountries);
end
for a = 46:length(allannual)-1
    allannual(1:length(Time),a+1) = calannual(a,Maize,Soybean,Rice,Wheat,Allcountries);
end
Nameofcol = ["Time"; Allcountries];

%we cut down those 3 countries that have the data different from others
%they are missing some of the year for some crops such as rice 1990-1993
%we found this error when running the code and debugging it; we found the error at
%the point where i = i th order of those countries which are: NZL, OECD and WLD
%So, we store all of those 3 countries' data as zero.

%convert those array into a table and rename it to the countries
allannualtable = array2table(allannual);
allvars = 1:width(allannualtable);
allannualtable = renamevars(allannualtable,allvars,Nameofcol);

%now we classify it into 6 continents 
%North America: CAN(6) HTI(15) MEX(23) USA(43)
%South America: ARG(1) BRA(4) CHL(8) COL(10) PER(31) PRY(33) URY(42)
%Asia: AUS(2) BGD(3) CHN(9) IDN(16) IND(17) IRN(18) ISR(19) JPN(20) KAZ(21) KOR(22)
%MYS(25) PAK(30) PHL(32) SAU(35) THA(38) TUR(39) VNM(44)
%Europe: CHE(7) NOR(27) RUS(34) UKR(41)
%Africa: DZA(11) EGY(12) ETH(13) GHA(14) MOZ(24) NGA(26) SDN(36) TZA(40)
%ZAF(46) ZMB(47)

%group of countries: BRICS(5) OECD(29) and unknown countries: SSA(37) WLD(45)
% which we will not use this and NZL(28) is already zeros; 
% So, it will not affect any data. 

%create an Allcontinents variable to store the total amount of crop for each
%continent and each year (we use function calannual2 to ramdomize the data)
%randorder is the variable that contain the order of the randomized countries
%for each continent

Allcontinents = ["Asia";"Europe";"North America";"South America";"Africa"];
allannual2 = zeros(length(Time),1+length(Allcontinents));
allannual2(1:length(Time),1) = Time;
randorder = [];
for a = 1:5
    [allannual2(1:length(Time),a+1),order]= calannual2(a,allannualtable);
    randorder = [randorder order];
end
Nameofcol2 = ["Time"; Allcontinents];

%convert those array into a table and rename it to the continents
allannualtable2 = array2table(allannual2);
allvars = 1:width(allannualtable2);
allannualtable2 = renamevars(allannualtable2,allvars,Nameofcol2);

%get the data from 1990-2021 in variable cropspresent
cropspresent = allannualtable2(1:32,:);

%Opening population data for all countries
Pop_country = readtable('Pop_data.csv');

Year = [1990;1995;2000;2005;2010;2015;2020;2025];

%creating table and choosing random countries to represent each continent.
Pop_ALL = table(Year);
Asia_pop = Pop_country(1:end,[3,4,10,17:23,26,31,33,36,39,40,45]);
Asia = (sum(table2array(Asia_pop(1:end,randorder(1:4)))'))';
Pop_ALL.Asia=Asia;

EU_pop = Pop_country(1:end,[8,28,35,42]);
EU = (sum(table2array(EU_pop(1:end,randorder(5:8)))'))';
Pop_ALL.Europe=EU;

NA_pop = Pop_country(1:end,[7,16,24,44]);
NA = (sum(table2array(NA_pop(1:end,randorder(9:12)))'))';
Pop_ALL.NA = NA;

SA_pop = Pop_country(1:end,[2,5,9,11,32,34,43]);
SA = (sum(table2array(SA_pop(1:end,randorder(13:16)))'))';
Pop_ALL.SA = SA;

AFRICA_pop = Pop_country(1:end,[12:15,25,27,37,41,47,48]);
AFRICA = (sum(table2array(AFRICA_pop(1:end,randorder(17:20)))'))';
Pop_ALL.AFRICA = AFRICA;

%here is the function calannual to find the total amount of crops for each countries
function output = calannual(j,Maize,Soybean,Rice,Wheat,Allcountries)
    annualmaize1 = [];
    annualrice1 = [];
    annualsoybean1 = [];
    annualwheat1 = [];
    annual1 = [];
    for i = 1:length(Maize)
        if Maize(i).maizeLoc == Allcountries(j)
           annualmaize1 = [annualmaize1; Maize(i).maizeVal];
        end
    end
    for i = 1:length(Soybean)
        if Soybean(i).soybeanLoc == Allcountries(j)
           annualsoybean1 = [annualsoybean1; Soybean(i).soybeanVal];
        end
    end
    for i = 1:length(Rice)
        if Rice(i).riceLoc == Allcountries(j)
           annualrice1 = [annualrice1; Rice(i).riceVal];
        end
    end
    for i = 1:length(Wheat)
        if Wheat(i).wheatLoc == Allcountries(j)
           annualwheat1 = [annualwheat1; Wheat(i).wheatVal];
        end
    end
    annual1 = annualmaize1 + annualrice1 + annualsoybean1 + annualwheat1;
    output = annual1;
end

%here is the function calannual2 to find the total amount of crops for each
%continent with ramdomizing 4 countries in each continent
%*The order of each country +1 because we added the column of
%Time as the first column in allannualtable
function [output,varargout] = calannual2(j,allannualtable)
    switch j
        case 1 %Asia
            Asia = allannualtable(1:end,[3,4,10,17:23,26,31,33,36,39,40,45]);
            order = randperm(width(Asia));
            output = (sum(table2array(Asia(1:end,order(1:4)))'))';
            varargout{1} = order(1:4);
        case 2 %Europe
            Europe = allannualtable(1:end,[8,28,35,42]);
            order = randperm(width(Europe));
            output = (sum(table2array(Europe(1:end,order(1:4)))'))';
            varargout{1} = order(1:4);
        case 3 %North America
            NA = allannualtable(1:end,[7,16,24,44]);
            order = randperm(width(NA));
            output = (sum(table2array(NA(1:end,order(1:4)))'))';
            varargout{1} = order(1:4);
        case 4 %South America
            SA = allannualtable(1:end,[2,5,9,11,32,34,43]);
            order = randperm(width(SA));
            output = (sum(table2array(SA(1:end,order(1:4)))'))';
            varargout{1} = order(1:4);
        case 5 %Africa
            Africa = allannualtable(1:end,[12:15,25,27,37,41,47,48]);
            order = randperm(width(Africa));
            output = (sum(table2array(Africa(1:end,order(1:4)))'))';
            varargout{1} = order(1:4);
    end
end
