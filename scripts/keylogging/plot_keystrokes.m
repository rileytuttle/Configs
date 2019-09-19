function plot_keystrokes(varargin)
    if nargin == 1
        fid = fopen(varargin{1})
        a = textscan(fid, '%s %u');
        fclose(fid);
        dates = zeros(size(a{1}));
        for i = 1:length(a{1})
            dates(i,1) = datenum(a{1}{i}, 29);
        end
        plot(dates,a{2}, '.b')
        datetick('x', 'yyyy-mm-dd')
        print -djpg plot.jpg
    else
        disp('too many args')
    end
        
end
