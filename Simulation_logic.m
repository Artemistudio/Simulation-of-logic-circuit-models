clear all
clc

modelobj = sbmlimport('or-both.xml');  % sbmlimport('projFilename.xml');
configSet = getconfigset(modelobj);

result_data = runsimulation(modelobj, configSet);

