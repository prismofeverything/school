This directory contains the NEURON files (.hoc and .ses) for the class simulations that demonstrate the effects of currents on spiking behavior of neurons. In addition, the directory contains files that code for the new currents (.mod) that must be compiled to run the .hoc files. Your installation of NEURON includes a program called "mknrndll" that you run in the directory containing the .mod files. Detailed instructions can be found in the documentation on the NEURON site <http://www.neuron.yale.edu/>, and links found there. The following is a short description for each operating system:

Instructions from <http://www.anc.ed.ac.uk/school/neuron/tutorial/tutD.html>
A membrane mechanism description using NMODL is laid out in a text file. The NEURON interpreter cannot read this file directly as it can with hoc files. Instead, the NMODL file has to be compiled into a form that NEURON can use. Suppose that we have created a file CaT.mod containing our description of the T-type calcium channel in NMODL. How you incorporate this new mechanism into NEURON depends on what operating system you are using.

MSWin users should just launch
 Start / Programs / Neuron / mknrndll
This brings up a directory browser that can be used to navigate to the directory that contains the CaT.mod file. When you get to the proper directory, click on the button labelled "Make nrnmech.dll". This compiles all the mod files in this directory and creates a file called nrnmech.dll that contains the new compiled mechanisms. nrnmech.dll will be automatically loaded when you double click on a hoc file in this directory.

MacOS users only need to drag the directory that contains CaT.mod and drop it onto the mknrndll icon. This produces a nrnmech.dll file that is automatically loaded when you double click on any hoc file in the same directory.

UNIX and LINUX users should just change to the directory that contains the CaT.mod file, and there type the command
nrnivmodl
at the operating system prompt. Under Linux on a PC with an Intel-compatible CPU, this creates a new NEURON executable called i386/special (the i386 subdirectory will be created automatically if it does not already exist) whose library of mechanisms includes our T current. To launch this new executable and have it load your model file, just type
nrngui sthD.hoc 
at the OS prompt in the directory that contains i386. sthD.hoc is the file that contains our model specification, and it is nearly identical to sthC3.hoc from tutorial part C.
-----------------------------------
Parameters for the class demonstrations:

Persistent sodium current (01_NaP.hoc)
a) Boost repetitive spiking:
   gkbar_iNaP = 0.0 --> 0.005
b) Increase sensitivity to input:
   Set IClamp(delay) = 10, IClamp(duration) = 30, IClamp(amplitude) = 0.05, 
   gkbar_iNaP = 0.0 --> 0.002

Transient potassium current (02_IA.hoc)
a) Delayed response
   Set gkbar_iA = 0.0, then several spikes during stimulation
   gkbar_iA -> 0.007  latency to first spike increases
b) Slow spike rate
   Set  IClamp(amplitude) = 0.0, 
   Set el_HH = 0.0
   Set Tstop = 1500
   gkbar_iA = 0.007 -> 0.021,  slows spike rate to 2 Hz.

Slowly activating (03_IM.hoc)
gkbar_iM = 0.0 -> 0.0003, reduces # of spikes until only 1st spike remains.

Calcium Dynamics (04_Ca.hoc)
Ca bursting
a) IClamp(amplitude) = 200-> 50 ms; burst outlasts stim
b) gcabar_iT = 0.0001 -> 0; no Ca burst
   gcabar_iL = 0.0003 -> 0 (gcabar_iT = 0.0001); not enough Ca to repolarize
      gkbar_HH --> 0.02 : repolarize neuron to terminate burst
c) gkbar_iC = 0.007 -> 0.07; reduce # of spikes in burst
   gkbar_iAHP 0 --> 0.001; reduce burst duration

d) Ca oscillation
   Set gcabar_iL = 0.0006
       gcabar_iT = 0.0006
       gkbar_iC = 0.007
       gkbar_iAHP = 0.0005


I_h oscillation (insert ih current into 04_Ca.hoc) (not shown in class)
  Tstop = 3000
  gkbar_iC = 0
  gkbar_iAHP = 0.0001
ghbar_ih = 0.0003