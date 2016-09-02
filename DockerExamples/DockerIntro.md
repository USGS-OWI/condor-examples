# Example of using Docker with R and Python

This is documentation for 2 basic examples of using Docker with R and Python. I created the examples as I was learning how to use Docker. They examples will also be used in the Docker/HTCondor examples. My biggest problem was figuring out how to run docker interactively and access files/data on my local machine. Several factors likely led to my problems. First, I was impatient and didn't read the tutorials well. Second, most of the tutorials are written for non-scientific computing. Third, most of the R tutorials are designed for a GUI/RStudio application whereas I was interested in using the command line. 

## Background/other useful references

This article _ACM SIGOPS Operating Systems Review - Special Issue on Repeatability and Sharing of Experimental Artifacts archive_, (Volume 49 Issue 1, January 2015, Pages 71-79) ([arxive here](http://arxiv.org/pdf/1410.0846.pdf)) provides a nice overview of why a scientists should use docker. 

The Docker [getting started](https://docs.docker.com/engine/getstarted/) file was also helpful.

## Examples of how to run docker.

To run a docker interactively (i.e., as a bash shell):

    docker run -i -t -v /home/rerickson/:/opt/rerickson -w /opt/rerickson /bin/bash`

Flags:
  - `-i` is the interactive flag
  - `-t` is the pseudo-tty terminal flag
  - `-v` is the volume mounted, i.e., `/home/rerickson/` is the directory on your computer and `/opt/rerickson/` is the directory in the container
  - `-w` is the working directory i.e., `/opt/rerickson` within the container
  - `/bin/bash` runs the bash shell

The [Docker volumes help page](https://docs.docker.com/engine/tutorials/dockervolumes/) documents this further.

To run a script file with docker, use similar settings, but specify the program you with to run and the script file to run. For example:

    docker run -i -t -v /home/rerickson:/opt/rerickson -w /opt/rerickson python python test.py

or 

    docker run -i -t -v /home/rerickson:/opt/rerickson -w /opt/rerickson r-base R CMD BATCH test.R

Both of my test files are "Hello World!" type files (the Python example is literally a "Hello World!" text file, whereas the R files creates a `data.frame` and saves it to a csv file. 

A couple of other notes on flags. `-d` runs docker in the background. `-P` will map docker to ports on our machines (I have not used this, but it seems more important for web settings). `-v` may also be used to mount multiple volumes. 
