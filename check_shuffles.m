% Assuming global_remapped_original_probability_ratio is already loaded
original_data = global_remapped_original_probability_ratio{1}{1};
shuffled_data_cell = global_remapped_original_probability_ratio{1}{2};

figure;

% Left Plot: Histogram of Original Data Values
subplot(1, 2, 1);
histogram(original_data(:), 'BinWidth', 0.05);
title('Histogram of Original Data Values (X-axis: 0-3, BinWidth: 0.05)');
xlabel('Value');
ylabel('Count');
xlim([0 3]); % <--- CHANGED: Set X-axis limits to 0 to 3

% Right Plot: Histogram of Shuffled Data Values (Overlayed)
subplot(1, 2, 2);
hold on;
% Overlay histograms of a few shuffled datasets
num_shuffles_to_plot_hist = 5; % Plot histograms for the first 5 shuffles
for n = 1:num_shuffles_to_plot_hist
    histogram(shuffled_data_cell{n}(:), 'Normalization', 'probability', 'BinWidth', 0.05, 'FaceAlpha', 0.2);
end
% Add original for comparison (make sure this is plotted last to be on top)
histogram(original_data(:), 'Normalization', 'probability', 'BinWidth', 0.05, 'EdgeColor', 'k', 'LineWidth', 1.5);
title('Histogram of Shuffled Data Values (Overlayed, X-axis: 0-3, BinWidth: 0.05)');
xlabel('Value');
ylabel('Probability');
xlim([0 3]); % <--- CHANGED: Set X-axis limits to 0 to 3
hold off;