/*----------------------------------------------------------------

  Geometry file for thalamocortical neuron

  - 9 compartments
  - 2 dendrites

  Cell from rat VB, stained by Huguenard & Prince, Stanford [1], and
  traced at the Salk Institute by A. Destexhe.  Starting from a 200 
  compartment cell, the geometry was reduced into a simpler geometry 
  equivalent to dissociated cells.  The full and dissociated cells are 
  depicted in [1]. 

  The dissociated cell was obtained by the following method [2]:

  - the full cell has an input capacitance of 113 pF, whereas 
    dissociated cells have 16.7 pF on average [1].

  - if one assumes that the input capacitance is proportional to the
    area of the cell, then a typical dissociated cell must have an area of:
    23980.547 um2 * 16.7 / 113 = 3544 um2

  - this area was obtained from the full geometry by keeping the thickest
    and most proximal dendrites in order to match this area.  The aspect
    of the dissociated cell was consistent with the shape of dissociated 
    TC cells [2]

  In the dissociated cell, the soma, dend3[0,1,8] and dend7[0,1,4,5,8] were
  kept from the original and renamed soma, dend1[0,1,2], and dend2[0,1,2,3,4],
  repectively.  The total membrane area is of 3427.67 um2 (PI*diam*L) and 
  3974.32 um2 (using area function)

  Structure of the reduced compartmental model:


 (dend1)        1--0 1--0
                1--0

 (dend2)        1--0
                1--0 1--0 1--0
                     1--0

 (soma)                       1--0

  Alain Destexhe, Laval University, March 1996


  [1] Huguenard, JR and Prince, DA. A novel T-type current undelies prolonged
      calcium-dependent burst firing in GABAergic neurons of rat thalamic
      reticular nucleus.  J. Neurosci. 12: 3804-3817, 1992.

  [2] Destexhe A, Neubig M, Ulrich D and Huguenard JR.  Dendritic
      low-threshold calcium currents in thalamic relay cells.  
      J. Neurosci. 18: 3574-3588, 1998.

      http://cns.iaf.cnrs-gif.fr

The morphology, passive cable properties and modeling of this neuron are
described in ref [2].  Please cite this reference if you use that geometry


----------------------------------------------------------------*/

create soma, dend1[3], dend2[5]

double sections_cell[2]
sections_cell[0] = 3
sections_cell[1] = 5


/*----------------------------------------------------------------*/
proc geometry() { local i, j

						/* soma geometry */
    soma {
        nseg = 1
        pt3dclear()
        for j = 1, fscan() {
            pt3dadd(fscan(),fscan(),fscan(),fscan())
        }
    }

					/* connect primary neurites */
    soma connect dend1[0] (0), 0.5
    soma connect dend2[0] (0), 0.5

					/* neurite geometry*/
    for i = 0,2 {
        dend1[i] {
            nseg = fscan()
            pt3dclear()
            for j = 1, fscan() {
                pt3dadd(fscan(),fscan(),fscan(),fscan())
            }
        }
    }

    for i = 0,4 {
        dend2[i] {
            nseg = fscan()
            pt3dclear()
            for j = 1, fscan() {
                pt3dadd(fscan(),fscan(),fscan(),fscan())
            }
        }
    }

					/* branching topology*/
    for i = 1,2 {
        dend1[fscan()] connect dend1[i] (0), fscan()
    }

    for i = 1,4 {
        dend2[fscan()] connect dend2[i] (0), fscan()
    }

}

geometry()


SOMA COORDINATES AND DIAMETERS:

        13
        -23.25  -7.35   -34.2   0
        -21.9   -6.18   -31.05  14.959
        -21     -5.8875 -30.4875        21.439
        -20.1   -5.03862        -28.6974        24.974
        -16.95  -4.48638        -27.5526        25.363
        -16.05  -4.26426        -26.5824        26.719
        -13.8   -3.05889        -24.0111        28.865
        -9.75   -1.51125        -21.6675        28.311
        -4.8    1.0875  -17.5662        25.297
        -3.45   0.795   -15.435 23.776
        -0.75   1.875   -11.4192        15.383
        0.15    1.56    -10.53  10.826
        1.5     3       -9      0


NEURITE COORDINATES AND DIAMETERS:

	1 4
	7	-3	-5	4.8
	7.5	-4	2.5	3.9
	9	-6	7.5	2.5
	11	-8	10.5	2.5

	1 6
	11	-8	10.5	2.5
	14	-8	11	2
	17	-7.5	12.5	2
	20.5	-6.5	14	2
	23.5	-4.5	13.5	2
	27	-2.5	13	3

	1 7
	11	-8	10.5	2.5
	12	-10	10.5	2
	15	-11	14	2
	17.5	-12	19.5	2
	18.5	-14	23.5	2
	18	-16.5	26.5	2
	17	-19	30.5	2

	1 2
	-13.5	0	-38.5	2.2
	-22.5	0.5	-33.5	2.2

	1 9
	-22.5	0.5	-33.5	2.2
	-30	-1.5	-33.5	1.2
	-36.5	-2	-33.5	1.2
	-41	-2	-33.5	1.2
	-47	-2	-28	1.2
	-53	-1	-21	1.2
	-60.5	1.5	-14.5	1.5
	-66.5	2.5	-13	1.5
	-72.5	1	-13.5	1.2

	1 2
	-22.5	0.5	-33.5	2.2
	-26	2.5	-36	1.6

	1 6
	-26	2.5	-36	1.6
	-31.5	2	-35.5	1.2
	-38.5	2.5	-34.5	1.2
	-45.5	4	-29	1.2
	-53.5	5	-24.5	1.2
	-61.5	5.5	-20	1.2

	1 8
	-26	2.5	-36	1.6
	-32	8.5	-29	1.2
	-38	15	-24.5	1.2
	-45.5	22	-22.5	1.2
	-52	27.5	-20	1.2
	-58.5	33.5	-17	1.2
	-63	40	-15	1.2
	-68.5	47.5	-13.5	1.2


CONNECTIONS:


        0    1
        0    1

        0    1
        0    1
        2    1
        2    1

/*----------------------------------------------------------------*/
proc geometry() { 

	/* NULL geometry procedure: keeps the user from
	calling the geometry procedure in isolation. */

    printf("\nYou must re-read the entire geometry\n")
    printf("file to execute geometry().\n\n")
}


//-----------------------------------------------------------------
//  Correction of diameters
//
//  Alain Destexhe, 05 Mar 96
//-----------------------------------------------------------------
//
//  Procedure of renormalization of diameters using a sigmoid
//  transformation function:
//  newdiam = oldiam * 1/( 1 + exp(-(diam-diam_hlf)/diam_stp) )
//-----------------------------------------------------------------

diam_min = 0.8		// minimal diameter
diam_hlf = 1.5     	// half-value of the sigmoid
diam_stp = 1.5		// steepness of sigmoid

proc rescale_diameters() {

   print " "
   print " "
   print ">>> RESCALING DENDRITIC DIAMETERS"
   init()		// first call init to set the diameters

   cell_area = 0	// calculate cell area before rescaling
   print " "
   forall { cell_area = cell_area + area(0.5) }
   print ">>> Total membrane area before rescaling (in um2): ",cell_area


   forsec "dend" { 	// rescale
	diam = diam / ( 1 + exp(-(diam-diam_hlf)/diam_stp) )
	if(diam < diam_min) diam = diam_min
   }
   print ">>> Dendrites rescaled."

   cell_area = 0	// calculate cell area after rescaling
   forall { cell_area = cell_area + area(0.5) }
   print ">>> Total membrane area in um2: ",cell_area
   print " "
}

rescale_diameters()
