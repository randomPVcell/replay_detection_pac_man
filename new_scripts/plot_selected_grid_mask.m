%plot pacman new method. 
clear all
cd D:\public-archivedwl-90\Dropbo_data8\N-BLU_Day7_Ctrl-16x30_no_reexp
load('decoded_replay_events.mat');
num_tracks = length(decoded_replay_events);
num_replay_events = length(decoded_replay_events(1).replay_events);
for track = 1 : num_tracks
        for event = 1 : num_replay_events
            decoded_event = decoded_replay_events(track).replay_events(event);
            if length(find(isnan(decoded_event.decoded_position)))>0 | length(decoded_event.timebins_centre)<5 | size(decoded_event.spikes,1)==0
                scored_replay(track).replay_events(event).path_score_normalised=NaN;
            else
                decoded_position=modify_decoding(decoded_event);  % make column zero if there aren't any spikes
%                 [scored_replay(track).replay_events(event).path_score,~] = pacman(decoded_position);
                [scored_replay(track).replay_events(event).path_score_normalised, matrix, selected_grid_mask, maxsum] = fast_pacman_path(decoded_position);
            end
        end
end

%% 
% Normalize each column so its values sum to 1
column_sums = sum(matrix, 1);
column_sums(column_sums == 0) = eps; % Avoid division by zero for columns that sum to 0
normalized_maxsum = matrix./ column_sums;

% Plot the heatmap of the normalized matrix
figure;
subplot(2,1,1);
heatmap(normalized_maxsum);
subplot(2,1,2);
heatmap(selected_grid_mask);
%% 

save matrix matrix
save maxsum maxsum
save selected_grid_mask selected_grid mask



function modified_decoded_event = modify_decoding(events)
modified_decoded_event = events.decoded_position;
for i = 1 : length(events.timebins_edges)-1
    spikes = find(events.spikes(:,2)>=events.timebins_edges(i) & events.spikes(:,2)<events.timebins_edges(i+1),1);  %>= and < used, to match histcount function
    if isempty(spikes)
        modified_decoded_event(:,i) = zeros(size(modified_decoded_event(:,i)));
    end
end
end

