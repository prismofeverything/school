#include <stdio.h>
#include "hocdec.h"
extern int nrnmpi_myid;
extern int nrn_nobanner_;
modl_reg(){
  if (!nrn_nobanner_) if (nrnmpi_myid < 1) {
    fprintf(stderr, "Additional mechanisms from files\n");

    fprintf(stderr," HH1.mod");
    fprintf(stderr," cadyn.mod");
    fprintf(stderr," ia.mod");
    fprintf(stderr," iahp.mod");
    fprintf(stderr," ic.mod");
    fprintf(stderr," ih.mod");
    fprintf(stderr," il.mod");
    fprintf(stderr," im.mod");
    fprintf(stderr," inap.mod");
    fprintf(stderr," it.mod");
    fprintf(stderr, "\n");
  }
  _HH1_reg();
  _cadyn_reg();
  _ia_reg();
  _iahp_reg();
  _ic_reg();
  _ih_reg();
  _il_reg();
  _im_reg();
  _inap_reg();
  _it_reg();
}
