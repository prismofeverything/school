TITLE persistent sodium current 

COMMENT Equations from 
   Golomb D, Amitai Y (1997) Propagating neuronal discharges in
   neocortical slices: computational and experimental study. J Neurophys
   78: 1199-1211.

>< Time constants given at 36 degC.
>< Written by Arthur Houweling.
ENDCOMMENT

NEURON {
        SUFFIX iNaP
        USEION na READ ena WRITE ina 
        RANGE g, ina
}

UNITS {
	(S)  = (siemens)
        (mA) = (milliamp)
        (mV) = (millivolt)
}

PARAMETER {
        g= 7e-5	(S/cm2)
}

ASSIGNED {
        v	(mV)
	ena	(mV)
        ina	(mA/cm2)
	minf
}

BREAKPOINT { 
	rates()
	ina= g* minf* (v- ena) 
}

INITIAL { 
	rates() 
}

PROCEDURE rates() { UNITSOFF
	minf= 1/ (1+ exp(-(v+ 40)/ 5))
} UNITSON

