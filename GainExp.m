function FinalImageGained = GainExp(I,g)

total_log = log(I+1e-6);
total_key = sum(total_log(:))./(numel(I));
gain =g./total_key;
total_log = total_log * gain;
total_contrast = exp(total_log);
FinalImageGained = total_contrast;%./max(total_contrast(:));