%This is meant to convert the pwms downloaded from the DePace siteout
%website and convert them into a format Patser recognizes.
pwm_folder = 'C:\Users\ArmandoReimer\Documents\pwm';
d = dir(pwm_folder);
out_path2 = ['C:\Users\ArmandoReimer\Documents\pwm_patser', filesep,'all_pwms.txt'];
fid2 = fopen(out_path2,'wt');
for i = 3:length(d)
    name = d(i).name;
    in_path = [pwm_folder,filesep, name];
    s = load(in_path);
    s = num2str(s');
    line0 = ['>TF_', name];
    line1 = ['A | ', s(1,:)];
    line2 = ['C | ', s(2,:)];
    line3 = ['G | ', s(3,:)];
    line4 = ['T | ', s(4,:)];
    out_path = ['C:\Users\ArmandoReimer\Documents\pwm_patser',filesep, name(1:end-3), '.txt'];
    fid = fopen(out_path,'wt');
    fprintf(fid, '%s\n%s\n%s\n%s\n%s', line0, line1, line2, line4, line3);
    fclose(fid);
    fprintf(fid2,'\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', line0, line1, line2, line4, line3);
end
fclose(fid2);