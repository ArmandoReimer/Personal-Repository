function graph_patser_results(in)

    t = fileread(in);
    tinverse = flip(t);
    expression0 = '(\=erocs)';
    s0 = regexp(tinverse, expression0);
    tf = {};
    for i = 1:length(s0)
        pos = s0(i);
                    postf = strfind(tinverse(pos:length(tinverse)), '_FT');

%         try
%             postf = strfind(tinverse(pos:length(tinverse)), '_FT');
%         catch
%             postf = strfind(tinverse(pos:length(tinverse)), '_FT');  
%         end
        b= postf(1)+pos;
        tf{i} = tinverse(b-50:b-2);
        z = strfind(tf{i}, sprintf('\r'));
        tf{i} = tf{i}(z:end);
        tf{i} = flip(tf{i});
    end
    expression01 = '(\d*\.\d)(?=   \=erocs)';
    s01 = regexp(tinverse, expression01, 'tokens'); 
    values =  zeros(1,length(s01));
    for i = 1:length(s01)
        s = s01{i};
        values(i) = str2double(flip(s{1}));
    end
    tf = flip(tf);
    values = flip(values);


    bar(values)
    ax = gca;
    set(ax,'xticklabel',tf)
    ax.XTick = 1:1:length(tf);
    ax.XTickLabelRotation=45;
end