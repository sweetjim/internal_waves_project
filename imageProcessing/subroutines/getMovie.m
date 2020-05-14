%% Movie routine

if ~isempty(imageframes)
    close(gcf)
    videoTitle = strcat(exppath,'\Density_anomaly_',...
    expname,'_run',num2str(numexp),'.avi');

    % Sequence video filenames if overwriting is not selected
    if isfile(videoTitle)
        answer = questdlg('Overwrite previous video?','Yes',...
            'No');
        switch answer
            case 'Yes'
            case 'No'
                videoNumber = char(extractBefore(videoTitle,'.avi'));
                if strcmp(videoNumber(end-3:end-1),'run')
                   number = '1';
                else
                   number = num2str(str2double(videoNumber(end))+1);
                end
                videoTitle  = strcat(extractBefore(videoTitle,'.avi'),...
                    '_new',number,'.avi');
        end
    end

    tic;
    video = VideoWriter(char(videoTitle));
    video.FrameRate = 20;
    open(video);

    % If tracking is active, empty frames and changing frame sizes will
    % be found 'imageframes.cdata'. Selecting a region where the
    % frame size is constant and nonempty will allow the video to be
    % written.
    if tracking
        for i=1:length(imageframes)
            a(i) = size(imageframes(i).cdata,1); 
            b(i) = size(imageframes(i).cdata,2);
        end

        startvideo  = find(a>0,1,'first');
        endvideo    = find(b(startvideo:end-50)<max(b(startvideo:end-50)),1,'first')-5+startvideo;
        if isempty(endvideo)
            endvideo = length(imageframes); 
        end
        writeVideo(video,imageframes(startvideo:length(imageframes)));
    else
        writeVideo(video,imageframes);
    end
    close(video);
    toc;

    videoTime = minutes(toc);
end