

download_dependencies = function(package=NULL, destdir='.', repos=getOption("repos"), write_packages=TRUE){
  
  if(is.null(package) || length(package) > 1){
    stop('please supply a package name, one at a time')
  }
  
  
  deps = package_dependencies(package, 
                              db=available.packages(
                                  type='source', 
                                  contriburl=contrib.url(repos, type='source')),
                              recursive=TRUE)

  download.packages(deps[[1]], destdir = destdir, type='source', repos=repos)
  
  download.packages(package, destdir = destdir, type='source', repos=repos)
  
  if(write_packages){
    write_PACKAGES(dir = '.', type='source')
  }
  
}
