function r = cmusets()

cp = evalin('base','cmubase');

r = csvimport([cp filesep 'cmu-mocap-index-spreadsheet.csv']);