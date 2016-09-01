# condor-examples

This file contains several examples for using [HTCondor](https://research.cs.wisc.edu/htcondor/) to scale scientific
processing to a computer cluster. 

The examples include:

  - _QuickStart_, which is HTCondor's quick start example for Windows.
  - _LearnR_, which is a very simple R example if R is installed on
    the local Widnows machine.
  - _R-Rtools-sandbox_, which demonstrates how to sandbox R and Rtools
    on Windows.
  - _R-snow_, which demonstrates how to use HTCondor with R and the
    snow parallel package on Linux.
  - _RStanExample_, which demonstrates how to use RStan on HTCondor on
    Windows where R is locally installed.
	

The "sandbox" examples do not require R to be installed on the
machines in the HTCondor flock. Conversely, the "sandboxed" examples
are stand alone and do not require the local installation of R.

Some examples are written for Windows. Others for Linux. The biggest
difference is that the Windows examples have
[batch](https://en.wikipedia.org/wiki/Batch_file) files that end with
`.bat`  whereas Linux
examples have
[shell scripts](https://en.wikipedia.org/wiki/Shell_script) that end
with `.sh`.

These examples may eventually be expanded to include tutorials that
better document the tutorials.
