function updateWaitBar(f,counter,display)
% Check for waitbar cancelation
if getappdata(f,'canceling')
    delete(f)
    return
end
% Update waitbar and message
waitbar(counter,f,display)
end

