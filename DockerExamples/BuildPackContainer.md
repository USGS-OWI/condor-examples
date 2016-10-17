# Building Images

Building images allows up to create your own image that has the
packages you need to complete your job. 

The [Docker Image](https://docs.docker.com/engine/tutorials/dockerimages/)
is where I got most of this information I adapted for this example. 

This file includes example of building images that are used by Docker.

## Useful commands before starting

Here are useful commands that I will review before going through the
tutorial:

    docker images 
	
shows what images are currently locally installed. The images can also
be removed: 

	docker rmi -f hello-world
	
The force flag `-f` is necessary because this image is still running
in the background. To stop all currently running docker images:

    docker stop $(docker ps -a -q)

To remove all images: 

    docker rm $(docker ps -a -q)

I found these [here](https://coderwall.com/p/ewk0mq/stop-remove-all-docker-containers).

## Creating new images

There are two methods for creating images. Update existing images
through the terminal _or_ use a `Dockerfile` to create an image.

## Updating an existing image through the terminal

One can create an image by updating an existing package in the
terminal and then committing the updates.
This methods is easier, but not preferred because it does not
reproducible. 

As an example, perhaps I want to install an R package. Here the steps
to commit to an existing Dockerfile:

 - Run the Docker Image interactively

        docker run -t -i r-base /bin/bash
	
 - launch R, install the package, and quit R:
  
         R
	     install.packages("MARSS", repos='http://cran.us.r-project.org')
	     q()
	 
 - Exit the Docker image (with `exit`)
 - Commit the image

	     docker commit -m "Added in MARSS" -a "Richard Erickson"
         674cff43dbfd rerickson/r-base:marss
	
 - We may then run the image:
  
        docker run -t -i rerickson/r-base:marss
	 
### Build a docker images from a Dockerfile

We may also build an image from a Dockerfile. This methods is
 preferred because it is reproducible. 
 However, it is difficult and I have not been able to reproduce it.
 I tried to Jessie
 Frazelle's Block [post](https://blog.jessfraz.com/post/r-containers-for-data-science/)
 on the topic to be helpful, but have not been able to replicate it
 yet.
 Here is my best try:
 
 - We need a docker file with this information (this is placed in an
   Dockerfile, but my example doesn't yet work):

        # our R base image
	
	    FROM r-base
	    # install MARSS packages
	    RUN echo 'install.packages(c("MARSS"), repos="http://cran.us.r-project.org", dependencies=TRUE)' > /tmp/packages.R \
	    && Rscript /tmp/packages.R
        # create an R user
		ENV HOME /home/user
	    RUN useradd --create-home --home-dir $HOME user \
	    && chown -R user:user $HOME
	    WORKDIR $HOME
	    USER user
	    # set the command
	    CMD ["R"]

 - We then build the image (make sure to include the period at the
     end).
	 
	     docker build --rm --force-rm -t rerickson/r-custom .

 - This may be run and used:
   
        docker run -it -v /home/rerickson:/opt/rerickson -w /opt/rerickson rerickson/r-custom 
