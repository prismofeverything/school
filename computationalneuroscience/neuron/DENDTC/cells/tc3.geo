/*----------------------------------------------------------------

  Geometry file for thalamocortical neuron

  - 3 compartments
  - 1 soma, 1 proximal dendrite, 1 distal dendrite

  Obtained from merging the cell from rat vb, stained by Huguenard & Prince, 
  Stanford.  The cell was traced in the Salk Institute by A. Destexhe.
  Starting from a 200 compartment cell, the geometry was reduced into an 
  equivalent geometry of 3 compartments, by a method developed by Mike Neubig
  and inspired from Bush & Sejnowski theme for axial resistance conservation
  (J Neurosci Methods 46: 159-166, 1993).  

  Structure of the reduced compartmental model:


	1--0 1--0   1--0
         (dend1)   (soma)

  Length and diameters:
  ---------------------

	Soma :		L=38.42		diam=26		S=2624.6
	dend1[0] : 	L=12.49		diam=10.28	S=403.37
	dend1[1] : 	L=84.67		diam=8.5	S=2260.99

	=> total dendritic surface = 5288.96 (2664.36 for dendrites)
	   Reconstructed cell was of 23980.547 um2 (21355.8 for dendrites)

	=> avg reduction factor for dendrites is CorrD = 8.02
	   SimFit of experimental voltage-clamp trace gives CorrD = 7.954


The construction of this cell from dendritic morphology of the TC cells, the
evaluation of its passive parameters, its cable properties and how this neuron
matches the physiology of thalamic relay cells are described in:

      Destexhe A, Neubig M, Ulrich D and Huguenard JR.  Dendritic
      low-threshold calcium currents in thalamic relay cells.  
      J. Neurosci. 18: 3574-3588, 1998.
      http://cns.iaf.cnrs-gif.fr

Please cite this reference if you use this model

Alain Destexhe and Mike Neubig, Laval University, 1997

----------------------------------------------------------------*/

print "----------------------------------------------"
print "   Simplified TC cell with 3 compartments"
print "----------------------------------------------"



/* create compartments (sections) */

create soma[1], \
       dend1[2]

/* connect compartments */

soma connect dend1[0](0),1
dend1[0] connect dend1[1](0),1



/* setup 3d geometry : */

soma {			/* define soma first */
  nseg = 1
  pt3dclear()
  pt3dadd(0, 0, 0, 26)	 	/* x,y,z,diam */
  pt3dadd(0, 38.42, 0, 26)
}



dend1[0] {		/* dendrites */
  nseg = 1
  pt3dclear()
  pt3dadd(0, 38.42, 0, 10.28)
  pt3dadd(0, 50.91, 0, 10.28)
}

dend1[1] {
  nseg = 1
  pt3dclear()
  pt3dadd(0, 50.91, 0, 8.5)
  pt3dadd(0, 135.58, 0, 8.5)
}




