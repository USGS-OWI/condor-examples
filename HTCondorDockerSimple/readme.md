# make sure docker is installed 

    condor_config_val docker

# get files

  - run local repository
  - tar ball up file you can export to a tgz file
    
	    ID=$(docker run -d mnfienen/amplicon_pipeline2 /bin/bash)
        (docker export $ID | gzip -c > tmp.tgz

then import

    gzip -dc tmp.tgz | docker import - mnfienen/amplicon_pipeline3
