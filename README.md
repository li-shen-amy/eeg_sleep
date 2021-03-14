# Sleep State Auto-Scoring based on EEG and EMG signals
This is a MATLAB App for visualization and automatically sleep cycle analysis based on animal's EEG and EMG signals.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_eeg.jpg" />
</p>

# Decision-Tree Algorithm based on EEG and EMG signals
## Basic setup:
EEG and EMG electrodes were connected to flexible recording cables via a mini-connector. Recordings started after 20-30 min of habituation. The signals were recorded with an OpenEphys data acquisiton module (sampling rate, 1,000 Hz). You can also record the trigger signal (as reference for treatment or photo-stimulation) and EEG state can be analyzed aligned with the onset of trigger.
## Feature extraction
- EEG and EMG spectral analysis was carried out using fast Fourier transform (FFT). The power spectrum was calculated using 5 s sliding windows, sequentially shifted by 2.5 s increments. 
- We summed the EEG power in the range from 1 to 4 Hz and from 6 to 12 Hz, yielding time-dependent delta and theta power, respectively. For further analysis, we computed the theta/delta power ratio and summed the EMG power in the range of 20-300 Hz. 
## Auto-scoring
- According to the distribution of the EEG delta power (with 24h continuously recording), we determined a threshold for the delta power (delta threshold), separating the typically bimodal distribution of the delta power into a lower and higher range.
- A state was assigned as NREM sleep if the delta power was larger than the delta threshold and if the EMG power was one standard deviation lower than its mean. 
- A state was classified as REM if (1) the delta power was lower than the delta threshold, (2) the theta/delta ratio was higher than one standard
deviation above the mean, and (3) the EMG power was lower than its mean plus one standard deviation. 
- All remaining states were classified as wake. The wake state thus encompassed states with high EMG power (active awake) or low delta power but without elevated EMGactivity or theta/delta ratio (quiet awake). 
- Finally, we manually verified the automatic classification to evaluate the results.
## Interactively visual scoring
During the whole processing, the GUI provide visualization and allow easily and interactively manual thresholding and scoring.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_decision_tree.png" />
</p>

# Get-started
GUI for visualization and automatic differentiation of sleep cycles
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui.png" />
</p>

## Load EEG, EMG and Trigger signals
The panel in top-left corner is for loading the signal (EEG, EMG, or Trigger signals). You can set the sampling rate (Fs) and the boundary of time window for visualization.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_load_data.png" />
</p>
## Set time window to display the signal
## Calculate the features
## Auto-Scoring or Manual Scoring
## Display Time-dependent or Trigger-dependent percentage of sleep cycle
## Save the data and generate figure
## Load previously saved data

# References
- Kohtoh S, Taguchi Y, Matsumoto N et al.(2008). Algorithm for sleep scoring in experimental animals based on fast Fourier transform power spectrum analysis of the electroencephalogram. _Sleep and Biological Rhythms_ 6: 163–171. 
- Zhong P, Zhang Z, Barger Z et al.(2019). Control of Non-REM Sleep by Midbrain Neurotensinergic Neurons. _Neuron_ 104, 1-15. 
