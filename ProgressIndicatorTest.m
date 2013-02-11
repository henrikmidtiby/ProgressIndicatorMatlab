progress = ProgressIndicator();

for k = 1:100
    pause(0.2)
    progress.update(k, 100);
end