/*----------------------------------------------------------------

  Geometry file for thalamocortical neuron

  - 1 compartment (soma)

  Length and diameters:
  ---------------------

	Soma :		L=100		diam=76.58

	=> total dendritic surface = 24058 um2
	   Reconstructed cell was of 23980.547 um2

The determination of the size of this single-compartment neuron, the
evaluation of its passive parameters, its cable properties and how this neuron
matches the physiology of thalamic relay cells are described in:

      Destexhe A, Neubig M, Ulrich D and Huguenard JR.  Dendritic
      low-threshold calcium currents in thalamic relay cells.  
      J. Neurosci. 18: 3574-3588, 1998.
      http://cns.iaf.cnrs-gif.fr

----------------------------------------------------------------*/

print "----------------------------------------------"
print "   Single-compartment TC cell model"
print "----------------------------------------------"


/* create compartments (sections) */

create soma[1]

soma {
  nseg = 1
  diam = 76.58			// obtained by fitting passive responses
  L = 100
  cm = 1
}

