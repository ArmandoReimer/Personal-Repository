function clearjavapath() 

    % Switch off warning
    warning_state = warning('off');
    
    wtf = javaclasspath('-dynamic');
    len = length(wtf);
    for i = 1:len
        javarmpath(wtf{i});
    end
    
end