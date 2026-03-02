# Integral Action and Reduced-Order Observer-Based Control for a Magnetic Levitation System
### **Manuscript ID: IEEE Latin America Transactions. Submission 10363**

## **Authors:**
- Cuauhtémoc Guerrero
- Marcos A. González Olvera
- Carlos M. Ortiz Cervantes

*Affiliation:*
Universidad Autónoma de la Ciudad de México

## ✏️ **Description.**
This repository contains the files necessary to run the experiments in the IEEE Latin America paper "Integral Action and Reduced-Order Observer-Based Control for a Magnetic Levitation System", Submission ID 10363, as well as the obtained data sets from the experiment.

## ⏹️ **Requirements**
- Hardware
   - PC with Intel or AMD 64-bit processor with eight logical cores
   - RAM: 16 GB (minimum)
   - HDD: 10 GB free (minimum)
   - QUANSER Q8-USB Data Acquisition Card (check [official site](https://www.quanser.com/products/q8-usb-data-acquisition-device/) for details)
   - QUANSER Quarc 2022 SP1 with active license (check [official site](https://download.quanser.com/doc/2022/QUARC_Software_Compatibility_Chart.pdf) for details)
   - QUANSER Maglev Experiment (check [official site](https://www.quanser.com/products/magnetic-levitation/) for technical details)
   - QUANSER VoltPAQ x1 (check [official site](https://www.quanser.com/products/voltpaq-x1-amplifier/) for technical details)
- Software
   - Windows 10 or 11
   - MATLAB 2022b with:
      - Simulink
      - Simulink Coder
      - MATLAB Coder (with compatible C++ compiler)
      - Control System Toolbox (optional)
        
## 🗃️ Included Scripts
| Script                                  | Description                                   |
|-----------------------------------------|-----------------------------------------------|
| `MagLevInit2.m`                         | MATLAB Initialization file for the experiment. It calculates, based on the system parameters and desired equilibrium point for $Z_{eq}$, the required linearization matrices, transformation matrices, controller and observer gains. |
| `QuarcQ8MaglevControlObservadorv02.slx` | Simulink file for running the experiment      |

## 📁 Included Data files
| File         | Description           |
|--------------|-----------------------|
|`MagLevExpmat2.mat` | Single MAT file that contains all signals from the experiments for the changing step reference
|`MagLevExpSinmat.mat` | Single MAT file that contains all signals from the experiments for the sinusoidal reference

#### 📋 Description of the MAT files
  Both MAT files contain a single matrix called `maglevexp`, where each row is a different variable, and each column corresponds with each time-sample of the variable  in the following order:
  1. Row 1. Time (sampled by $T_s$=0.001 s)
  2. Row 2. Obtained position
  3. Row 3. Reference signal vector
  4. Row 4. Measured current
  5. Row 5. Observed current
  6. Row 6. Reconstructed velocity
  7. Row 7. Observed velocity
  8. Row 8. Control signal (voltage) applied to the MagLev

## ➡️ Execution of the experiments
1. Start MATLAB and check that QUARC is running in the background
2. With the QUANSER Q8-USB Data Acquisition Card connected via USB to the PC, check that it is detected in the Device Administrator in Windows
3. Connect the VoltPaq x1 Amplifier Command to Analog Output 0 in the Q8-USB Data Acquisition Card
4. Check that the Amplifier Gain in VoltPaq is in x3 position
5. Connect the VoltPaq x1 "To Load" to the "Coil" input in the MagLev System
6. Connect the "Current Sense" output in the MagLev System to S3 input in VoltPaq x1
7. Connect the "Sensor" output in the MagLev System to S1&S2 input in VoltPaq x1
8. Connect the S1 output in VoltPaq x1 to "Analog Input" 0 in Q8-USB
9. Connect the S3 output in VoltPaq x1 to "Analog Input" 1 in Q8-USB
10. Make sure all equipments are powered on (Q8, MagLev, VoltPaq x1)
11. Open the files `MagLevInit2.m` and QuarcQ8MaglevControlOvservadorv02.slx
12. In file `MagLevInit2.m` , change line 25 (Zeq=0.009;) to desired value for equilibrium. Default is 0.009 m (9 mm).
13. LQR control weights can be changed in line 41 of `MagLevInit2.m`
14. Observer pole position can be changed in line 60 of `MagLevInit2.m` (a Kalman Filter can be designed by uncommenting line 59 and commenting line 60).
15. Run `MagLevInit2.m`
16. Depending on desired reference signal, in `QuarcQ8MaglevControlObservadorv02.slx` change:
   - Step references.
       - *From File* block: Use `MagLevExpmat2.mat` as input file
       - *To File* block: Use `MagLevExpmatResults.mat` as output file, or choose any other name
       - Stop time: Change to 283.28
   - Sin reference
       - *From File* block: Use `MagLevExpSin.mat` as input file
       - *To File* block: Use `MagLevExpSinResults.mat` as output file, or choose any other name to save the signals from the experiment
       - Stop time: Change to 95.184
17. In `QuarcQ8MaglevControlObservadorv02.slx`, push "Build, Deploy & Start" to compile and run the experiment.

### ✏️ Comment on the *From File* block
   A user-defined file can be used in this block, that loads a single matrix with N columns, but it must contain at least three rows:
   1. Row 1. Time vector (sampled by $T_s$=0.001 s)
   2. Row 2. *Don't care* data row
   3. Row 3. Reference signal vector
  
## 📁 Obtained data
Once the experiment has ended, the produced file in *To File* block saves a MAT file that, when loaded in MATLAB, generates a single matrix called `maglevexp`, where each row is a different variable, and each column corresponds to each time sample of different experiment variables in the following order:
  1. Row 1. Time vector (sampled by $T_s$=0.001 s)
  2. Row 2. Obtained position
  3. Row 3. Reference signal vector
  4. Row 4. Measured current
  5. Row 5. Observed current
  6. Row 6. Reconstructed velocity
  7. Row 7. Observed velocity
  8. Row 8. Control signal (voltage) applied to the MagLev

⚠️NOTE: The plots in the aforementioned paper were obtained by manually choosing each row and plotting using the `plot` command in MATLAB and files `MagLevExpmat2.mat` and  `MagLevExpSin.mat` for the step reference and sine reference, respectively. Colors, titles, plot limits, subplots, zoom, legend and editions were done manually in the MATLAB command line.
