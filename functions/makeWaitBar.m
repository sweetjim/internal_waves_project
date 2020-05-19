function f = makeWaitBar(header)
f = waitbar(0,'1','Name',header,...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(f,'canceling',0);
end

