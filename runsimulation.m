
function data = runsimulation(modelobj, cs)

data = sbiosimulate(modelobj, cs, [], []);

plottype_Time(data, '<all>', 'one axes', '');
[time2, data2, names2] = getdata(data);
dataWithTime = [time2, data2];
names3 = [{'Time'}; names2];
fileID = fopen('combined_data.txt', 'w');

for i = 1:numel(names3)
    if i < numel(names3)
        fprintf(fileID, '%s,', names3{i});
    else
        fprintf(fileID, '%s\n', names3{i});
    end
end
for i = 1:size(dataWithTime, 1)
    for j = 1:size(dataWithTime, 2)
        if j < size(dataWithTime, 2)
            fprintf(fileID, '%f,', dataWithTime(i, j));
        else
            fprintf(fileID, '%f\n', dataWithTime(i, j));
        end
    end
end
fclose(fileID);

% ----------------------------------------------------------
function plottype_Time(tobj, y, plotStyle, axesStyle)

if ~isempty(tobj(1).RunInfo.ConfigSet) && tobj(1).RunInfo.ConfigSet.CompileOptions.UnitConversion && all(strcmp({tobj.TimeUnits},tobj(1).TimeUnits)) && ~isempty(tobj(1).TimeUnits)
    labelX = ['Time (' tobj(1).TimeUnits ')'];
else
    labelX = 'Time';
end
 
labelArgs = timeGetLabels(axesStyle, 'States versus Time', labelX, 'States');

if (length(tobj) > 1)
    switch (plotStyle)
    case 'one axes'
        haxes = sbioplot(tobj, @timeplotdata, [], y, labelArgs{:});
    case 'trellis'
        htrellis = sbiotrellis(tobj,@timesubplotdata, [], y, labelArgs{:});
        haxes    = htrellis.plots;
    end
    
    if isfield(axesStyle, 'Properties')
        set(haxes, axesStyle.Properties);
    end
else
    handles = timesubplotdata(tobj, [], y);
    
    if isfield(axesStyle, 'Properties') && length(handles)>=1
        haxes = get(handles(1), 'Parent');
        set(haxes, axesStyle.Properties);
    end
    
    title(labelArgs{2});
    xlabel(labelArgs{4});
    ylabel(labelArgs{6});
    
    if strcmpi(y, '<all>')
        [~, ~, names] = getdata(tobj);
    else
        names = y;
    end
    
    leg = legend(names, 'Location', 'NorthEastOutside');
    set(leg, 'Interpreter', 'none');
    
end

%--------------------------------------------------------
function [handles, names] = timeplotdata(tobj, ~, y)

colors    = get(gca, 'ColorOrder');
numColors = length(colors);

if strcmpi(y, '<all>')
    [~, ~, names] = getdata(tobj(1));
else
    [~, ~, names] = selectbyname(tobj(1), y);
end
handles = zeros(length(names), length(tobj));

for i=1:length(tobj)
    nexttobj = tobj(i);

    if strcmpi(y, '<all>')
        [time, data, names] = getdata(nexttobj);
    else
        [time, data, names] = selectbyname(nexttobj, y);
    end

    if size(data,2) == 0
        error('Data specified do not exist.');
    end
    set(gca, 'ColorOrderIndex', 1);
    if(size(data,2) ==1)
        hLine = plot(time, data, 'color',colors(mod(i-1,numColors)+1,:));
    else
        hLine = plot(time, data);
    end
    handles(:,i) = hLine;
end


% ---------------------------------------------------------
function handles = timesubplotdata(tobj, ~, y)

if strcmpi(y, '<all>')                
    [time, data] = getdata(tobj);
else
    [time, data] = selectbyname(tobj, y);
end

if size(data,2) == 0
    error('Species specified do not exist.');
end

handles = plot(time, data);

% ---------------------------------------------------------
function out = timeGetLabels(axesStyle, labelTitle, labelX, labelY)

out = {'title', labelTitle, 'xlabel', labelX, 'ylabel', labelY};

if isfield(axesStyle, 'Labels')
    allLabels = axesStyle.Labels;
    
    if isfield(allLabels, 'Title')
        out{2} = allLabels.Title;
    end
    
    if isfield(allLabels, 'XLabel')
        out{4} = allLabels.XLabel;
    end
    
    if isfield(allLabels, 'YLabel')
        out{6} = allLabels.YLabel;
    end
end

