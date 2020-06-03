%% Read frames routine
% This will cycle through the selected runs and display an option to verify
% which runs you would like to compare. Then you will be asked to define
% (i) the start and stop times, and (ii) the desired frame width of the
% runs.

%% Initialisation
clf;
figure(1)

m   = 1;
hst = zeros(2,4,endim); 

for i=1:endim
    if i==1
        % Find the smallest file and initialize 3 dimensional arrays (x,z,t)
        min_x   = 4000;
        min_z   = 1000;
        min_t   = 1000;

        for j=1:endim
            [ncpath,wspath,info] = getRunInfo(j,experiment_path,selected_runs);
           if info.Size(1)<min_x
              min_x     = info.Size(1);
              fwidth    = 3088;
              width     = data(selected_runs(i),15);
              wratio    = (width/fwidth);
           end
           if info.Size(2)<min_z
              min_z     = info.Size(2);
              depth     = -data(selected_runs(i),2);
           end
           if info.Size(3)<min_t
              min_t     = info.Size(3);
              min_run   = selected_runs(i);
           end
        end


        % t_i = input(...
        %     sprintf('Which frame would you like to start from (max is %i)?\t',...
        %     min_t));

        t_i = 1;
        initial_array   = zeros(min_x,min_z,endim);
        final_array     = zeros(size(initial_array)); 
    end
    
    [ncpath,wspath,info] = getRunInfo(i,experiment_path,selected_runs);
        
    initial_array(:,:,i)    =  ncread(ncpath,'anom',[1 1 t_i],...
        [min_x min_z 1]);
    final_array(:,:,i)      =  ncread(ncpath,'anom',[1 1 min_t],...
        [min_x min_z 1]);
    
    % Retrieving the pixel location of the hills at frames 't_i' and 'min_t'
    [hLL,hLR,hRL,hRR]   = getNans(initial_array(:,:,i));
    hst(1,:,i) = [hLL,hLR,hRL,hRR];
    [hLL,hLR,hRL,hRR]   = getNans(final_array(:,:,i)); 
    hst(2,:,i) = [hLL,hLR,hRL,hRR];
       
    title_phrase = {sprintf('Run: %i frame (%i)',...
                    selected_runs(i),t_i),...
                    sprintf('Run: %i frame (%i/%i)',...
                    selected_runs(i),min_t,info.Size(3))};
    
    % Show the start and final frames
    M = size(initial_array,3);
    
    getSubPlot(M,m,initial_array(:,:,i),width,depth,title_phrase{1})
    getSubPlot(M,m+1,final_array(:,:,i),width,depth,title_phrase{2})
%     getSubPlot(M,m,initial_array(:,:,i),min_x,min_z,title_phrase{1})
%     getSubPlot(M,m+1,final_array(:,:,i),min_x,min_z,title_phrase{2})
    
    m = m+2;
end

% Shift runs
prompt = input('Which runs would you like to shift (comma separated)? ','s');

if isempty(prompt)
   disp('No runs selected.')
   shift_runs = [];
   skipnext = true;
elseif length(prompt)>3
    prompt = split(prompt,',');
    for i=1:length(prompt)
       shift_runs(i) = str2double(prompt{i});
    end
    skipnext = false;
else 
    shift_runs = str2double(prompt);
    skipnext = false;
end

if ~skipnext
    
    for i=1:length(shift_runs)
        
        index = find(selected_runs==shift_runs(i));
        [ncpath,wspath,info] = getRunInfo(index,experiment_path,selected_runs);
        
        inbounds = true;
        while inbounds
            shift = input(sprintf('For run %i, how many frames would you like to shift it forward (<%i)?: ',...
                shift_runs(i),info.Size(3)-min_t));

            if isempty(shift)
                disp('Nothing entered. Try again.')
            elseif shift>(info.Size(3)-min_t)
                disp('That is out of bounds. Try again.')
            else
                break
            end
        end
        
        while true
            title_phrase = {sprintf('Run: %i frame (%i)',...
                        shift_runs(i),t_i+shift),...
                        sprintf('Run: %i frame (%i/%i)',...
                        shift_runs(i),min_t+shift,info.Size(3))};

            initial_array(:,:,index)    =  ncread(ncpath,'anom',[1 1 t_i+shift],...
                [min_x min_z 1]);
            final_array(:,:,index)      =  ncread(ncpath,'anom',[1 1 min_t+shift],...
                [min_x min_z 1]);

            [hLL,hLR,hRL,hRR]   = getNans(initial_array(:,:,index));
            hst(1,:,index) = [hLL,hLR,hRL,hRR];
            [hLL,hLR,hRL,hRR]   = getNans(final_array(:,:,index)); 
            hst(2,:,index) = [hLL,hLR,hRL,hRR];

            getSubPlot(M,index+2,initial_array(:,:,index),width,depth,title_phrase{1})
            getSubPlot(M,index+3,final_array(:,:,index),width,depth,title_phrase{2})
            
            exit_prompt = input(sprintf('Press enter to continue or enter a new shift (<%i): ',...
                info.Size(3)-min_t));
            if isempty(exit_prompt)
               break 
            else
                shift = exit_prompt;
            end
        end
        shift_array(i) = shift;
        fprintf('Run %i has been shifted by %i frames\n',shift_runs(i),shift);
    end
end

%% Hill information

% Get the average hill width
whill = mean(hst(1,2,:)-hst(1,1,:));

% Find the minimum distance between hLL and hRR
min_sep = min(hst(1,4,i)-hst(1,1,i));
min_sep_index = find(hst(1,4,i)-hst(1,1,i)==min_sep);

% Get the widest hill seperation
sep_array = hst(1,4,:)-hst(1,1,:);
max_sep = max(sep_array);
max_sep_index = find(sep_array==max_sep);
midpt_max_sep   = floor(max_sep/2);

% Get the pixel locations of the left and right-most hills from the
% selected runs
left_pad = min(min(hst(1,1,:)));
right_pad = max(max(hst(2,3,:)));

% Find the minimum distance between either hLL or hRR and the edges
if (info.Size(1)-right_pad)<left_pad
    r = info.Size(1)-right_pad-100;
else
    r = left_pad-100; 
end

% %% Replotting 
% figure(2)
% disp('Plotting initial and final frames centered about the hill')
% frame_wide = floor(max_sep+2*r);
% m = 1;
% for i=1:endim
%     
%     [hLL,hLR,hRL,hRR]   = getNans(initial_array(:,:,i));
%     midpt_i = 0.5*(hRL-hLR);
%     xmin_i  = hLL-r;
%     
%     [hLL,hLR,hRL,hRR]   = getNans(final_array(:,:,i)); 
%     midpt_f = 0.5*(hRL-hLR);
%     xmin_f  = hLL-r;
%     
%     if i~=max_sep_index
% 
%         xmin_i = midpt_i-midpt_max_sep/2;
%         xmin_f = midpt_f-midpt_max_sep/2;
%     end
%     
%     i_crop = [xmin_i 1 frame_wide size(initial_array,2)];
%     f_crop = [xmin_f 1 frame_wide size(initial_array,2)];
%     
%     initial_crop    = imcrop(initial_array(:,:,i)',i_crop)';
%     final_crop      = imcrop(final_array(:,:,i)',f_crop)';
%     
%     getSubPlot(M,m,initial_crop,size(initial_crop,1),size(initial_crop,2),'Cropped')
%     getSubPlot(M,m+1,final_crop,size(final_crop,1),size(final_crop,2),'Cropped')
%     m = m+2;
% end
% %% 
% 
% initial_array_cropped   = zeros(frame_wide,min_z,endim);
% final_array_cropped     = zeros(size(initial_array_cropped));
% 
% m = 1;
% for i=1:endim
%     [ncpath,wspath,info] = getRunInfo(i,experiment_path,selected_runs);
%     
%     if ~isempty(shift_runs)
%         if intersect(selected_runs(i),shift_runs)
%             t = shift_array(find(shift_runs==selected_runs(i)));
%         else
%             t = t_i;
%         end
%     else
%         t = t_i;
%     end
%     
%     if i~=max_sep_index
%         align = r+midpt_max_sep; 
%     else
%         align = r;
%     end
%     
%     [hLL,hLR,hRL,hRR]   = getNans(ncread(ncpath,'anom',[1 1 t],...
%         [frame_wide min_z 1]));
%     xmin_i = hLL - align;
%     fprintf('(%i) xmin: %i hLL %i r %i\t',i,xmin_i,hLL,align)
%     [hLL,hLR,hRL,hRR]   = getNans(ncread(ncpath,'anom',[1 1 min_t],...
%         [frame_wide min_z 1])); 
%     fprintf('xmin: %i hLL %i r %i\n',xmin_i,hLL,align)
%     xmin_f = hLL-align;
%     
%      initial_array_cropped(:,:,i) =  ncread(ncpath,'anom',[xmin_i 1 t],...
%         [frame_wide min_z 1]);
%     final_array_cropped(:,:,i)    =  ncread(ncpath,'anom',[xmin_f 1 min_t],...
%         [frame_wide min_z 1]); 
%     
%     title_phrase = {sprintf('Run: %i frame (%i)',...
%                     selected_runs(i),t),...
%                     sprintf('Run: %i frame (%i/%i)',...
%                     selected_runs(i),min_t,info.Size(3))};
%     
%     % Show the start and final frames
%     M = size(initial_array_cropped,3);
%     
%     getSubPlot(M,m,initial_array_cropped(:,:,i),width,depth,title_phrase{1})
%     getSubPlot(M,m+1,final_array_cropped(:,:,i),width,depth,title_phrase{2})
%     
%     m = m+2; 
% end
