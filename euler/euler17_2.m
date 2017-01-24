n = {};
n{1} = 'one';
n{2} = 'two';
n{3} = 'three';
n{4} = 'four';
n{5} = 'five';
n{6} = 'six';
n{7} = 'seven';
n{8} = 'eight';
n{9} = 'nine';
n{10} = 'ten';
n{11} = 'eleven';
n{12} = 'twelve';
n{13} = 'thirteen';
n{14} = 'fourteen';
n{15} = 'fifteen';
n{16} = 'sixteen';
n{17} = 'seventeen';
n{18} = 'eighteen';
n{19} = 'nineteen';
n{20} = 'twenty';
n{30} = 'thirty';
n{40} = 'forty';
n{50} = 'fifty';
n{60} = 'sixty';
n{70} = 'seventy';
n{80} = 'eighty';
n{90} = 'ninety';
n{100}  = 'hundred';
n{1000} = 'thousand';

number = 99;
for i = 20:number
    if isempty(n{i})
        tens = floor(i/10);
        ones = mod(i, 10);
        s = [n{tens*10}, n{ones}]
        n{i} = s;
    end
end

number = 999;
for i = 100:number
    if isempty(n{i})
        hundreds = floor(i/100);
        tensones = mod(i,100);
        if tensones
            s = [n{hundreds}, 'hundredand', n{tensones}]
        else
            s = [n{hundreds}, 'hundred']
        end
        n{i} = s;
    end
end

n{100} = 'onehundred';
n{1000}= 'onethousand';
number = length(n);
s = '';
for i = 1:number
    s = [s, n{i}];
end

display(length(s));