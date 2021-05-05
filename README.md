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

## Load and visualize EEG, EMG and Trigger signals
The panel in top-left corner is for loading the signal (EEG, EMG, or Trigger signals). You can set the sampling rate (Fs) and the boundary of time window for visualization.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_load_data.png" />
</p>

## Calculate the features
(1) Set parameters: time window length (default: 5s), time window overlaps (default: 2.5s), total signal time window calculated (defalt 0 - total length  of signals)
(2) Click "EEG Spectrogram", the features will be calculated and visualized.
(3) "Narrow Down" is used when you have already calculated the spectrogram and other parameters but want to narrow down to a shorter duration without recalculating the whole spectrogram and parameters (which may be time-consuming).

Bottom-left panel: EEG and EMG spectrogram, EEG delta power (1-4Hz), EEG theta power (6-12Hz), and EEG theta/delta power ratio, EMG power (summed power between 20-300Hz)
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_features1.png" />
</p>

Top-right panel: Distribution of EEG delta power, EEG theta/delta power ratio, EMG power
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_features.jpg" />
</p>
The number of bins, left and right limit for visualization can be modified in the editable text fields beside corresponding parameters.
The red vertical or horizontal lines show the interactively set threshold for scoring (default for automatic scoring is shown unless you manually drag and move it)

## Auto-Scoring or Manual Scoring
- Auto-Scoring: Click "Auto Score", the default thresholds for EEG delta power, EEG theta/delta power and EMG power in top-right panel are shown as red vertical or horizontal lines.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_features1_scoring.jpg" />
</p>

- Manual Scoring: Set threshold for EEG delta power, EEG theta/delta power and EMG power in top-right panel by dragging and moving the red vertical or horizontal bars.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_features1_threshold.jpg" />
</p>

## Display Time-dependent or Trigger-dependent percentage of sleep cycle
- Percentage of each sleep cycle
After scoring, the percentage of each sleep cycle (Awake, REM sleep, Non-REM sleep) is shown in gray, blue and red colors as shown below.
- Timestamps and transitions for each stage
The corresponding timestamps for each stage are also shown as mask shadows on time-dependent parameters in bottom-left panels.
The transitions for each stage are also shown in the most bottom-left panel. (R= REM sleep, N= Non-REM sleep, W= Wake)
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_timestamps.png" />
</p>

- Time-dependent percentage of each stage
The time-dependent change of percentage of each sleep stage during each specific time length (which can be set in bottom-right panel "Segment len(s)" editable text field), is shown in bottom-right panel.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_timepercent.png" />
</p>

- Trigger-dependent percentage of sleep cycle
If trigger signal is loaded (e.g. optogenetic stimulation or other treatment applied), the trigger ON and trgiger OFF can be automatically divided and percentage of each sleep cycle during the trigger transition (from OFF transit to ON) will be shown in the most bottom-right panel.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_trigger.png" />
</p>

## Save the data and generate figure
Just click "Export Data", you can save all the data to ".mat" files and meanwhile generate and save a ".fig" and a ".png" file to visualize the signals, features and results.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_save.jpg" />
</p>

## Load previously saved data
You can easily load previously processed data by clicking "Load preprocessed" button in the top-left panel.
<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/sleep_gui_load.jpg" />
</p>

# References
- Kohtoh S, Taguchi Y, Matsumoto N et al.(2008). Algorithm for sleep scoring in experimental animals based on fast Fourier transform power spectrum analysis of the electroencephalogram. _Sleep and Biological Rhythms_ 6: 163–171. 
- Zhong P, Zhang Z, Barger Z et al.(2019). Control of Non-REM Sleep by Midbrain Neurotensinergic Neurons. _Neuron_ 104, 1-15. 
