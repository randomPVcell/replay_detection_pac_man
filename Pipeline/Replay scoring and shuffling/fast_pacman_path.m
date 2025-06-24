function score=fast_pacman_path(decoded_event)

%https://blog.usejournal.com/dynamic-programming-finding-optimal-paths-2cf89f3d1437

[score1, maxsum1]=maxsum_algorithm_with_path(decoded_event); %start from top and go to bottom right
[score2, maxsum2]=maxsum_algorithm_with_path(flipud(decoded_event)); %start from bottom and go to top right


if score1>score2;
    score=score1;
    maxsum=maxsum1;
   
else
    score=score2;
    maxsum=maxsum2;

end  

score=score/size(decoded_event,2);  %normalise by number of time bins

% score=score/(size(decoded_event,2)+sum(sum(decoded_event)));  
% normalise by the sum of all posterior probabilities
 
% score=score/sum(sum(decoded_event));  
% normalise by the sum of all posterior probabilities
 
end

function [normalised_score, maxsum]=maxsum_algorithm_with_path(matrix)
    [rows, cols] = size(matrix);
    maxsum=zeros(rows, cols);

    % Cumulative sum of first column and row
    maxsum(1,:)=cumsum(matrix(1,:));
    maxsum(:,1)=cumsum(matrix(:,1)); % Note: maxsum(1,1) is set by first row, then by first col. It's fine.

    % Calculate maxsum matrix
    for i=2:rows
        for j=2:cols
            maxsum(i,j)=matrix(i,j)+max(maxsum(i-1,j), maxsum(i,j-1));
        end
    end

    score=maxsum(rows,cols);

    % Path Reconstruction
    selected_grid_mask = zeros(rows, cols); % Initialize a grid to mark the path
    optimal_path_indices = []; % To store [row, col] of path cells

    r = rows; % Start from the bottom-right corner
    c = cols;

    while r >= 1 && c >= 1
        selected_grid_mask(r,c) = 1; % Mark this cell as part of the path
        optimal_path_indices = [[r, c]; optimal_path_indices]; % Prepend to list (builds path in correct order)

        if r == 1 && c == 1 % Reached the top-left start cell
            break;
        end

        % Decide where to move next (up or left)
        if r == 1 % If in the first row, must have come from the left
            c = c - 1;
        elseif c == 1 % If in the first column, must have come from above
            r = r - 1;
        else
            if maxsum(r-1,c) >= maxsum(r,c-1) 
                r = r - 1; 
            else
                c = c - 1;
            end
        end
    end
    unselected_score = sum(matrix(selected_grid_mask == 0));
    normalised_score = score / unselected_score;

end