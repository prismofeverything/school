/* Created by Language version: 6.2.0 */
/* VECTORIZED */
#include <stdio.h>
#include <math.h>
#include "scoplib.h"
#undef PI
 
#include "md1redef.h"
#include "section.h"
#include "md2redef.h"

#if METHOD3
extern int _method3;
#endif

#undef exp
#define exp hoc_Exp
extern double hoc_Exp();
 
#define _threadargscomma_ _p, _ppvar, _thread, _nt,
#define _threadargs_ _p, _ppvar, _thread, _nt
 	/*SUPPRESS 761*/
	/*SUPPRESS 762*/
	/*SUPPRESS 763*/
	/*SUPPRESS 765*/
	 extern double *getarg();
 /* Thread safe. No static _p or _ppvar. */
 
#define t _nt->_t
#define dt _nt->_dt
#define gnabar _p[0]
#define gkbar _p[1]
#define gl _p[2]
#define el _p[3]
#define ina _p[4]
#define ik _p[5]
#define il _p[6]
#define m_inf _p[7]
#define h_inf _p[8]
#define n_inf _p[9]
#define tau_m _p[10]
#define tau_h _p[11]
#define tau_n _p[12]
#define m _p[13]
#define h _p[14]
#define n _p[15]
#define ena _p[16]
#define ek _p[17]
#define Dm _p[18]
#define Dh _p[19]
#define Dn _p[20]
#define tadj _p[21]
#define v _p[22]
#define _g _p[23]
#define _ion_ena	*_ppvar[0]._pval
#define _ion_ina	*_ppvar[1]._pval
#define _ion_dinadv	*_ppvar[2]._pval
#define _ion_ek	*_ppvar[3]._pval
#define _ion_ik	*_ppvar[4]._pval
#define _ion_dikdv	*_ppvar[5]._pval
 
#if MAC
#if !defined(v)
#define v _mlhv
#endif
#if !defined(h)
#define h _mlhh
#endif
#endif
 static int hoc_nrnpointerindex =  -1;
 static Datum* _extcall_thread;
 static Prop* _extcall_prop;
 /* external NEURON variables */
 extern double celsius;
 /* declaration of user functions */
 static int _hoc_rates();
 static int _hoc_states();
 static int _hoc_vtrap();
 static int _mechtype;
extern int nrn_get_mechtype();
 static _hoc_setdata() {
 Prop *_prop, *hoc_getdata_range();
 _prop = hoc_getdata_range(_mechtype);
 _extcall_prop = _prop;
 ret(1.);
}
 /* connect user functions to hoc names */
 static IntFunc hoc_intfunc[] = {
 "setdata_HH", _hoc_setdata,
 "rates_HH", _hoc_rates,
 "states_HH", _hoc_states,
 "vtrap_HH", _hoc_vtrap,
 0, 0
};
#define vtrap vtrap_HH
 extern double vtrap();
 
static void _check_rates(double*, Datum*, Datum*, _NrnThread*); 
static void _check_table_thread(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt, int _type) {
   _check_rates(_p, _ppvar, _thread, _nt);
 }
 /* declare global and static user variables */
#define usetable usetable_HH
 double usetable = 1;
 /* some parameters have upper and lower limits */
 static HocParmLimits _hoc_parm_limits[] = {
 "usetable_HH", 0, 1,
 0,0,0
};
 static HocParmUnits _hoc_parm_units[] = {
 "gnabar_HH", "mho/cm2",
 "gkbar_HH", "mho/cm2",
 "gl_HH", "mho/cm2",
 "el_HH", "mV",
 "ina_HH", "mA/cm2",
 "ik_HH", "mA/cm2",
 "il_HH", "mA/cm2",
 0,0
};
 static double delta_t = 1;
 static double h0 = 0;
 static double m0 = 0;
 static double n0 = 0;
 /* connect global user variables to hoc */
 static DoubScal hoc_scdoub[] = {
 "usetable_HH", &usetable_HH,
 0,0
};
 static DoubVec hoc_vdoub[] = {
 0,0,0
};
 static double _sav_indep;
 static void nrn_alloc(), nrn_init(), nrn_state();
 static void nrn_cur(), nrn_jacob();
 
static int _ode_count();
 /* connect range variables in _p that hoc is supposed to know about */
 static char *_mechanism[] = {
 "6.2.0",
"HH",
 "gnabar_HH",
 "gkbar_HH",
 "gl_HH",
 "el_HH",
 0,
 "ina_HH",
 "ik_HH",
 "il_HH",
 "m_inf_HH",
 "h_inf_HH",
 "n_inf_HH",
 "tau_m_HH",
 "tau_h_HH",
 "tau_n_HH",
 0,
 "m_HH",
 "h_HH",
 "n_HH",
 0,
 0};
 static Symbol* _na_sym;
 static Symbol* _k_sym;
 
static void nrn_alloc(_prop)
	Prop *_prop;
{
	Prop *prop_ion, *need_memb();
	double *_p; Datum *_ppvar;
 	_p = nrn_prop_data_alloc(_mechtype, 24, _prop);
 	/*initialize range parameters*/
 	gnabar = 0.1;
 	gkbar = 0.01;
 	gl = 0;
 	el = 0;
 	_prop->param = _p;
 	_prop->param_size = 24;
 	_ppvar = nrn_prop_datum_alloc(_mechtype, 6, _prop);
 	_prop->dparam = _ppvar;
 	/*connect ionic variables to this model*/
 prop_ion = need_memb(_na_sym);
 nrn_promote(prop_ion, 0, 1);
 	_ppvar[0]._pval = &prop_ion->param[0]; /* ena */
 	_ppvar[1]._pval = &prop_ion->param[3]; /* ina */
 	_ppvar[2]._pval = &prop_ion->param[4]; /* _ion_dinadv */
 prop_ion = need_memb(_k_sym);
 nrn_promote(prop_ion, 0, 1);
 	_ppvar[3]._pval = &prop_ion->param[0]; /* ek */
 	_ppvar[4]._pval = &prop_ion->param[3]; /* ik */
 	_ppvar[5]._pval = &prop_ion->param[4]; /* _ion_dikdv */
 
}
 static _initlists();
 static void _update_ion_pointer(Datum*);
 _HH1_reg() {
	int _vectorized = 1;
  _initlists();
 	ion_reg("na", -10000.);
 	ion_reg("k", -10000.);
 	_na_sym = hoc_lookup("na_ion");
 	_k_sym = hoc_lookup("k_ion");
 	register_mech(_mechanism, nrn_alloc,nrn_cur, nrn_jacob, nrn_state, nrn_init, hoc_nrnpointerindex, 1);
 _mechtype = nrn_get_mechtype(_mechanism[1]);
     _nrn_thread_reg(_mechtype, 2, _update_ion_pointer);
     _nrn_thread_table_reg(_mechtype, _check_table_thread);
  hoc_register_dparam_size(_mechtype, 6);
 	hoc_register_cvode(_mechtype, _ode_count, 0, 0, 0);
 	hoc_register_var(hoc_scdoub, hoc_vdoub, hoc_intfunc);
 	ivoc_help("help ?1 HH /Users/rspangler/school/computationalneuroscience/neuron/hh_zoo/x86_64/HH1.mod\n");
 hoc_register_limits(_mechtype, _hoc_parm_limits);
 hoc_register_units(_mechtype, _hoc_parm_units);
 }
 static double *_t_m_inf;
 static double *_t_tau_m;
 static double *_t_h_inf;
 static double *_t_tau_h;
 static double *_t_n_inf;
 static double *_t_tau_n;
static int _reset;
static char *modelname = "Hodgkin-Huxley like sodium, potassium, and leak channels";

static int error;
static int _ninits = 0;
static int _match_recurse=1;
static _modl_cleanup(){ _match_recurse=1;}
static _f_rates();
static rates();
static states();
 static _n_rates();
 
static int  states ( _p, _ppvar, _thread, _nt ) double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt; {
   rates ( _threadargscomma_ v ) ;
   m = m + ( 1.0 - exp ( - dt / tau_m ) ) * ( m_inf - m ) ;
   h = h + ( 1.0 - exp ( - dt / tau_h ) ) * ( h_inf - h ) ;
   n = n + ( 1.0 - exp ( - dt / tau_n ) ) * ( n_inf - n ) ;
    return 0; }
 
static int _hoc_states() {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r = 1.;
 states ( _p, _ppvar, _thread, _nt ) ;
 ret(_r);
}
 static double _mfac_rates, _tmin_rates;
  static void _check_rates(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) {
  static int _maktable=1; int _i, _j, _ix = 0;
  double _xi, _tmax;
  static double _sav_dt;
  static double _sav_celsius;
  if (!usetable) {return;}
  if (_sav_dt != dt) { _maktable = 1;}
  if (_sav_celsius != celsius) { _maktable = 1;}
  if (_maktable) { double _x, _dx; _maktable=0;
   _tmin_rates =  - 100.0 ;
   _tmax =  100.0 ;
   _dx = (_tmax - _tmin_rates)/200.; _mfac_rates = 1./_dx;
   for (_i=0, _x=_tmin_rates; _i < 201; _x += _dx, _i++) {
    _f_rates(_p, _ppvar, _thread, _nt, _x);
    _t_m_inf[_i] = m_inf;
    _t_tau_m[_i] = tau_m;
    _t_h_inf[_i] = h_inf;
    _t_tau_h[_i] = tau_h;
    _t_n_inf[_i] = n_inf;
    _t_tau_n[_i] = tau_n;
   }
   _sav_dt = dt;
   _sav_celsius = celsius;
  }
 }

 static rates(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt, double _lv) { 
#if 0
_check_rates(_p, _ppvar, _thread, _nt);
#endif
 _n_rates(_p, _ppvar, _thread, _nt, _lv);
 return;
 }

 static _n_rates(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt, double _lv){ int _i, _j;
 double _xi, _theta;
 if (!usetable) {
 _f_rates(_p, _ppvar, _thread, _nt, _lv); return; 
}
 _xi = _mfac_rates * (_lv - _tmin_rates);
 _i = (int) _xi;
 if (_xi <= 0.) {
 m_inf = _t_m_inf[0];
 tau_m = _t_tau_m[0];
 h_inf = _t_h_inf[0];
 tau_h = _t_tau_h[0];
 n_inf = _t_n_inf[0];
 tau_n = _t_tau_n[0];
 return; }
 if (_i >= 200) {
 m_inf = _t_m_inf[200];
 tau_m = _t_tau_m[200];
 h_inf = _t_h_inf[200];
 tau_h = _t_tau_h[200];
 n_inf = _t_n_inf[200];
 tau_n = _t_tau_n[200];
 return; }
 _theta = _xi - (double)_i;
 m_inf = _t_m_inf[_i] + _theta*(_t_m_inf[_i+1] - _t_m_inf[_i]);
 tau_m = _t_tau_m[_i] + _theta*(_t_tau_m[_i+1] - _t_tau_m[_i]);
 h_inf = _t_h_inf[_i] + _theta*(_t_h_inf[_i+1] - _t_h_inf[_i]);
 tau_h = _t_tau_h[_i] + _theta*(_t_tau_h[_i+1] - _t_tau_h[_i]);
 n_inf = _t_n_inf[_i] + _theta*(_t_n_inf[_i+1] - _t_n_inf[_i]);
 tau_n = _t_tau_n[_i] + _theta*(_t_tau_n[_i+1] - _t_tau_n[_i]);
 }

 
static int  _f_rates ( _p, _ppvar, _thread, _nt, _lv ) double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt; 
	double _lv ;
 {
   double _lalpha , _lbeta , _lq10 , _ltinc ;
 _lalpha = .091 * vtrap ( _threadargscomma_ _lv + 38.0 , 5.0 ) ;
   _lbeta = .062 * vtrap ( _threadargscomma_ - ( _lv + 38.0 ) , 5.0 ) ;
   tau_m = 1.0 / ( _lalpha + _lbeta ) / tadj ;
   m_inf = _lalpha / ( _lalpha + _lbeta ) ;
   _lalpha = .016 * exp ( - ( _lv + 55.0 ) / 15.0 ) ;
   _lbeta = 2.07 / ( 1.0 + exp ( ( 17.0 - _lv ) / 21.0 ) ) ;
   tau_h = 1.0 / ( _lalpha + _lbeta ) / tadj ;
   h_inf = _lalpha / ( _lalpha + _lbeta ) ;
   _lalpha = .01 * vtrap ( _threadargscomma_ _lv + 45.0 , 5.0 ) ;
   _lbeta = .17 * exp ( - ( _lv + 50.0 ) / 40.0 ) ;
   tau_n = 1.0 / ( _lalpha + _lbeta ) / tadj ;
   n_inf = _lalpha / ( _lalpha + _lbeta ) ;
    return 0; }
 
static int _hoc_rates() {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 
#if 1
 _check_rates(_p, _ppvar, _thread, _nt);
#endif
 _r = 1.;
 rates ( _p, _ppvar, _thread, _nt, *getarg(1) ) ;
 ret(_r);
}
 
double vtrap ( _p, _ppvar, _thread, _nt, _lx , _lb ) double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt; 
	double _lx , _lb ;
 {
   double _lvtrap;
 if ( fabs ( _lx / _lb ) < 1e-6 ) {
     _lvtrap = _lb + _lx / 2.0 ;
     }
   else {
     _lvtrap = _lx / ( 1.0 - exp ( - _lx / _lb ) ) ;
     }
   
return _lvtrap;
 }
 
static int _hoc_vtrap() {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  vtrap ( _p, _ppvar, _thread, _nt, *getarg(1) , *getarg(2) ) ;
 ret(_r);
}
 
static int _ode_count(_type)int _type; { hoc_execerror("HH", "cannot be used with CVODE");}
 extern void nrn_update_ion_pointer(Symbol*, Datum*, int, int);
 static void _update_ion_pointer(Datum* _ppvar) {
   nrn_update_ion_pointer(_na_sym, _ppvar, 0, 0);
   nrn_update_ion_pointer(_na_sym, _ppvar, 1, 3);
   nrn_update_ion_pointer(_na_sym, _ppvar, 2, 4);
   nrn_update_ion_pointer(_k_sym, _ppvar, 3, 0);
   nrn_update_ion_pointer(_k_sym, _ppvar, 4, 3);
   nrn_update_ion_pointer(_k_sym, _ppvar, 5, 4);
 }

static void initmodel(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) {
  int _i; double _save;{
  h = h0;
  m = m0;
  n = n0;
 {
   tadj = pow( 3.0 , ( ( celsius - 23.5 ) / 10.0 ) ) ;
   rates ( _threadargscomma_ v ) ;
   m = m_inf ;
   h = h_inf ;
   n = n_inf ;
   }
 
}
}

static void nrn_init(_NrnThread* _nt, _Memb_list* _ml, int _type){
double* _p; Datum* _ppvar; Datum* _thread;
Node *_nd; double _v; int* _ni; int _iml, _cntml;
#if CACHEVEC
    _ni = _ml->_nodeindices;
#endif
_cntml = _ml->_nodecount;
_thread = _ml->_thread;
for (_iml = 0; _iml < _cntml; ++_iml) {
 _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];

#if 0
 _check_rates(_p, _ppvar, _thread, _nt);
#endif
#if CACHEVEC
  if (use_cachevec) {
    _v = VEC_V(_ni[_iml]);
  }else
#endif
  {
    _nd = _ml->_nodelist[_iml];
    _v = NODEV(_nd);
  }
 v = _v;
  ena = _ion_ena;
  ek = _ion_ek;
 initmodel(_p, _ppvar, _thread, _nt);
  }}

static double _nrn_current(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt, double _v){double _current=0.;v=_v;{ {
   ina = gnabar * m * m * m * h * ( v - ena ) ;
   ik = gkbar * n * n * n * n * ( v - ek ) ;
   il = gl * ( v - el ) ;
   }
 _current += ina;
 _current += ik;
 _current += il;

} return _current;
}

static void nrn_cur(_NrnThread* _nt, _Memb_list* _ml, int _type) {
double* _p; Datum* _ppvar; Datum* _thread;
Node *_nd; int* _ni; double _rhs, _v; int _iml, _cntml;
#if CACHEVEC
    _ni = _ml->_nodeindices;
#endif
_cntml = _ml->_nodecount;
_thread = _ml->_thread;
for (_iml = 0; _iml < _cntml; ++_iml) {
 _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];
#if CACHEVEC
  if (use_cachevec) {
    _v = VEC_V(_ni[_iml]);
  }else
#endif
  {
    _nd = _ml->_nodelist[_iml];
    _v = NODEV(_nd);
  }
  ena = _ion_ena;
  ek = _ion_ek;
 _g = _nrn_current(_p, _ppvar, _thread, _nt, _v + .001);
 	{ double _dik;
 double _dina;
  _dina = ina;
  _dik = ik;
 _rhs = _nrn_current(_p, _ppvar, _thread, _nt, _v);
  _ion_dinadv += (_dina - ina)/.001 ;
  _ion_dikdv += (_dik - ik)/.001 ;
 	}
 _g = (_g - _rhs)/.001;
  _ion_ina += ina ;
  _ion_ik += ik ;
#if CACHEVEC
  if (use_cachevec) {
	VEC_RHS(_ni[_iml]) -= _rhs;
  }else
#endif
  {
	NODERHS(_nd) -= _rhs;
  }
 
}}

static void nrn_jacob(_NrnThread* _nt, _Memb_list* _ml, int _type) {
double* _p; Datum* _ppvar; Datum* _thread;
Node *_nd; int* _ni; int _iml, _cntml;
#if CACHEVEC
    _ni = _ml->_nodeindices;
#endif
_cntml = _ml->_nodecount;
_thread = _ml->_thread;
for (_iml = 0; _iml < _cntml; ++_iml) {
 _p = _ml->_data[_iml];
#if CACHEVEC
  if (use_cachevec) {
	VEC_D(_ni[_iml]) += _g;
  }else
#endif
  {
     _nd = _ml->_nodelist[_iml];
	NODED(_nd) += _g;
  }
 
}}

static void nrn_state(_NrnThread* _nt, _Memb_list* _ml, int _type) {
 double _break, _save;
double* _p; Datum* _ppvar; Datum* _thread;
Node *_nd; double _v; int* _ni; int _iml, _cntml;
#if CACHEVEC
    _ni = _ml->_nodeindices;
#endif
_cntml = _ml->_nodecount;
_thread = _ml->_thread;
for (_iml = 0; _iml < _cntml; ++_iml) {
 _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];
 _nd = _ml->_nodelist[_iml];
#if CACHEVEC
  if (use_cachevec) {
    _v = VEC_V(_ni[_iml]);
  }else
#endif
  {
    _nd = _ml->_nodelist[_iml];
    _v = NODEV(_nd);
  }
 _break = t + .5*dt; _save = t;
 v=_v;
{
  ena = _ion_ena;
  ek = _ion_ek;
 { {
 for (; t < _break; t += dt) {
  { states(_p, _ppvar, _thread, _nt); }
  
}}
 t = _save;
 }  }}

}

static terminal(){}

static _initlists(){
 double _x; double* _p = &_x;
 int _i; static int _first = 1;
  if (!_first) return;
   _t_m_inf = makevector(201*sizeof(double));
   _t_tau_m = makevector(201*sizeof(double));
   _t_h_inf = makevector(201*sizeof(double));
   _t_tau_h = makevector(201*sizeof(double));
   _t_n_inf = makevector(201*sizeof(double));
   _t_tau_n = makevector(201*sizeof(double));
_first = 0;
}
