TITLE transient potassium current (A-current)

COMMENT
	*********************************************
	reference:	Huguenard & McCormick (1992) 
			J.Neurophysiology 68(4), 1373-1383
	found in:	thalamic relay neurons		 	
	*********************************************
	Original by Alain Destexhe
	Rewritten for MyFirstNEURON by Arthur Houweling
ENDCOMMENT

INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

NEURON {
	SUFFIX iA
	USEION k READ ek WRITE ik 
        RANGE gkbar, m_inf1, tau_m, h_inf, tau_h1, ik
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	v		(mV)
	celsius		(degC)
	dt		(ms)
	ek		(mV)
	gkbar= 0.00345	(mho/cm2)
}

STATE {
	m1 h1
}

ASSIGNED {
	ik		(mA/cm2)
	m_inf1
	tau_m		(ms)
	h_inf
	tau_h1		(ms)
	tadj
}

BREAKPOINT { 
	SOLVE states :METHOD euler
 	ik = gkbar * m1^4*h1 * (v-ek)
}

:DERIVATIVE states { 
:	evaluate_fct(v)
:
:	m1'= (m_inf1-m1) / tau_m
:	h1'= (h_inf-h1) / tau_h1
:}

PROCEDURE states() {
        evaluate_fct(v)

	m1= m1 + (1-exp(-dt/tau_m))*(m_inf1-m1)
	h1= h1 + (1-exp(-dt/tau_h1))*(h_inf-h1)
}

UNITSOFF
INITIAL {
	tadj = 3^((celsius-23.5)/10)
	evaluate_fct(v)
	m1 = m_inf1
        h1 = h_inf
}

PROCEDURE evaluate_fct(v(mV)) {  LOCAL a,b
	tau_m = 1.0/((exp((v+35.82)/19.69)+exp(-(v+79.69)/12.7))+0.37) / tadj
	m_inf1 = 1.0 / (1+exp(-(v+60)/8.5))
	a = 1.0/((exp((v+46.05)/5)+exp(-(v+238.4)/37.45))) / tadj
	if (v<-63) {
		tau_h1 = a
		}
	else {
		tau_h1 = 19.0/tadj
		}
	h_inf = 1.0/(1+exp((v+78)/6))
}
UNITSON
