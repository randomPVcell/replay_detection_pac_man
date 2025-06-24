function [] = ground_truth_replay_sequence_analysis_new_2(folders,BAYSESIAN_NORMALIZED_ACROSS_TRACKS)
for nfolder = 1:10

    
    tic
    cd(folders{nfolder})
    load extracted_place_fields_BAYESIAN
    
    % EXTRACT REPLAY EVENTS and BAYESIAN DECODING
    %     disp('processing replay events')
    if exist(fullfile(pwd, 'ground_truth_info_path.mat'), 'file') ~= 2
        disp('scoring replay events_for_path')
        ground_truth_info_path = replay_decoding_ground_truth(BAYSESIAN_NORMALIZED_ACROSS_TRACKS); %extract and decodes replay events
        save ground_truth_info_path
    else
        load(fullfile(pwd, 'ground_truth_info_path.mat'));
        % SCORING METHODS: TEST SIGNIFICANCE ON REPLAY EVENTS
    end
    
%    if exist(fullfile(pwd, 'scored_replay_path_original_2.mat'), 'file') ~= 2
%        scored_replay_path_original_2 = replay_scoring_new([],[0 0 0 0 1]);
%        save scored_replay_path_original_2 
%    else
%        load(fullfile(pwd,'scored_replay_path_original_2.mat'));
%    end
    
    %     % RUN SHUFFLES
         disp('running shuffles')
    
        num_shuffles=1000;
        analysis_type=[0 0 0 0 1];  %[linear wcorr path spearman path_normalised_1_track]
        load(fullfile(pwd, 'decoded_replay_events.mat'));
        %shuffle_choice={'PRE spike_train_circular_shift','PRE place_field_circular_shift', 'POST place bin circular shift','POST time bin circular shift','POST time bin permutation'};
        shuffle_choice={'PRE place_field_circular_shift', 'POST time bin circular shift'};
    if exist(fullfile(pwd,"shuffled_tracks_path_2.mat"),'file')~=2
        p = gcp; % Starting new parallel pool
    
        if ~isempty(p)
            for shuffle_id=1:length(shuffle_choice)
                shuffle_type{shuffle_id}.shuffled_track_path = ground_truth_parallel_shuffles_new_path(shuffle_choice{shuffle_id},analysis_type,num_shuffles,...
                    decoded_replay_events,place_fields_BAYESIAN,BAYSESIAN_NORMALIZED_ACROSS_TRACKS);
    
    %             shuffle_type{shuffle_id}.shuffled_track = parallel_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,decoded_replay_events);
    
            end
        else
            disp('parallel processing not possible');
            for shuffle_id=1:length(shuffle_choice)
                            shuffle_type{shuffle_id}.shuffled_track_path = ground_truth_run_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,...
                                decoded_replay_events,place_fields_BAYESIAN,BAYSESIAN_NORMALIZED_ACROSS_TRACKS);
    
    %             shuffle_type{shuffle_id}.shuffled_track = run_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,decoded_replay_events);
            end
    
        end
        %
        %     tempt = shuffle_type;
        %     load shuffled_tracks
        %     for type = 1:length(shuffle_choice)
        %         for track = 1:length(shuffle_type{type}.shuffled_track)
        %             for event = 1:length(shuffle_type{type}.shuffled_track(track).replay_events)
        %                 shuffle_type{type}.shuffled_track(track).replay_events(event).path_score = ...
        %                     tempt{type}.shuffled_track(track).replay_events(event).path_score;
        %
        %             end
        %         end
        %     end
        %
        save shuffled_tracks_path_2 shuffle_type;
    else
        load(fullfile(pwd, 'shuffled_tracks_path_2.mat'), 'shuffle_type');
    end
    %     tempt = [];
    
    
    % Evaluate significance
    %load('scored_replay_path.mat');
    
    if exist(fullfile(pwd, 'scored_replay_path_2.mat'), 'file')~= 2
    
        scored_replay_pat_2=replay_significance_new(scored_replay_path_original_2, shuffle_type);
        save scored_replay_path_2
       
    else
        load(fullfile(pwd, 'scored_replay_path_2.mat'));
    
    end
    
    
    %%%%%analyze segments%%%%%%%%%%
    % splitting replay events
    if exist(fullfile(pwd, 'scored_replay_segments_path_2.mat'), 'file')~= 2
    
        replay_decoding_split_events;
        load(fullfile(pwd, 'decoded_replay_events_segments.mat'));
        % load decoded_replay_events_segments;
        scored_replay1_path = replay_scoring_new(decoded_replay_events1,[0 0 0 0 1]);
        scored_replay2_path = replay_scoring_new(decoded_replay_events2,[0 0 0 0 1]);
        %
        %     load scored_replay_segments
        %     for track = 1:length(scored_replay)
        %         for events = 1:length(scored_replay(1).replay_events)
        %             scored_replay1(track).replay_events(events).path_score = tempt1(track).replay_events(events).path_score;
        %             scored_replay2(track).replay_events(events).path_score = tempt2(track).replay_events(events).path_score;
        %         end
        %     end
    
        save scored_replay_segments_path_2 scored_replay1_path scored_replay2_path;
     
    else
    
        load(fullfile(pwd, 'scored_replay_segments_path_2.mat'));
    end
    
    
    
    %just weighted correlation and pacman
    load(fullfile(pwd, 'decoded_replay_events_segments.mat'));
    %load decoded_replay_events_segments;
    
    if exist(fullfile(pwd,"shuffled_tracks_segments_path_2.mat"),'file')~=2
        num_shuffles=1000;
        analysis_type=[0 0 0 0 1];  
        p = gcp; % Starting new parallel pool
    
        if ~isempty(p)
            for shuffle_id=1:length(shuffle_choice)
                shuffle_type1{shuffle_id}.shuffled_track_path = ground_truth_parallel_shuffles_new_path(shuffle_choice{shuffle_id},analysis_type,num_shuffles,...
                    decoded_replay_events1,place_fields_BAYESIAN,BAYSESIAN_NORMALIZED_ACROSS_TRACKS);
                shuffle_type2{shuffle_id}.shuffled_track_path = ground_truth_parallel_shuffles_new_path(shuffle_choice{shuffle_id},analysis_type,num_shuffles,...
                    decoded_replay_events2,place_fields_BAYESIAN,BAYSESIAN_NORMALIZED_ACROSS_TRACKS);
                %
                %             shuffle_type1{shuffle_id}.shuffled_track = parallel_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,decoded_replay_events1);
                %             shuffle_type2{shuffle_id}.shuffled_track = parallel_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,decoded_replay_events2);
    
            end
        else
            disp('parallel processing not possible');
            for shuffle_id=1:length(shuffle_choice)
                shuffle_type1{shuffle_id}.shuffled_track_path = ground_truth_run_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,...
                    decoded_replay_events1,place_fields_BAYESIAN,BAYSESIAN_NORMALIZED_ACROSS_TRACKS);
                shuffle_type2{shuffle_id}.shuffled_track_path = ground_truth_run_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,...
                    decoded_replay_events2,place_fields_BAYESIAN,BAYSESIAN_NORMALIZED_ACROSS_TRACKS);
    
                %             shuffle_type1{shuffle_id}.shuffled_track = run_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,decoded_replay_events1);
                %             shuffle_type2{shuffle_id}.shuffled_track = run_shuffles(shuffle_choice{shuffle_id},analysis_type,num_shuffles,decoded_replay_events2);
    
            end
        end
    
        % add specific score to scored_replay
        %     tempt1 = shuffle_type1;
        %     tempt2 = shuffle_type2;
        %
        %     load shuffled_tracks_segments
        %     for type = 1:length(shuffle_choice)
        %         for track = 1:length(shuffle_type{type}.shuffled_track)
        %             for event = 1:length(shuffle_type{type}.shuffled_track(track).replay_events)
        %                 shuffle_type1{type}.shuffled_track(track).replay_events(event).path_score = ...
        %                     tempt1{type}.shuffled_track(track).replay_events(event).path_score;
        %                 shuffle_type2{type}.shuffled_track(track).replay_events(event).path_score = ...
        %                     tempt2{type}.shuffled_track(track).replay_events(event).path_score;
        %             end
        %         end
        %     end
        %     tempt1 = [];
        %     tempt2 = [];
    
        save shuffled_tracks_segments_path_2 shuffle_type1 shuffle_type2
    else  
        load(fullfile(pwd, 'scored_replay_segments_path_2.mat'),'scored_replay1_path', 'scored_replay2_path'); load(fullfile(pwd, 'shuffled_tracks_segments_path_2.mat'));
    end
        scored_replay1_path=replay_significance_new(scored_replay1_path, shuffle_type1);
        scored_replay2_path=replay_significance_new(scored_replay2_path, shuffle_type2);
        save scored_replay_segments_path_2 scored_replay1_path scored_replay2_path
    cd ..
    toc
end
end
