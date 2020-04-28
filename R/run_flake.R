#'@title Run the FLake model
#'
#'@description
#'This runs the FLake model on the specific simulation stored in \code{sim_folder}.
#'The specified \code{sim_folder} must contain valid NML files.
#'
#'@param sim_folder the directory where simulation files are contained
#'@param nml_file filepath; to file with FLake setup. Defaults to 'flake.nml'
#'@param verbose Save output as character vector. Defaults to FALSE
#'
#'@keywords methods
#'@author
#'Tadhg Moore
#'@examples
#'sim_folder <- system.file('extdata', package = 'FLakeR')
#'run_flake(sim_folder, nml_file = 'Heiligensee80-96.nml')
#'@export
#'@importFrom utils packageName
run_flake <- function (sim_folder = ".", nml_file = NULL, verbose = FALSE)
{
  if (is.null(nml_file)) {
    files <- list.files(sim_folder)[grep('nml', list.files(sim_folder))]
    if(length(files) > 1){
      stop("You must select one FLake namelist file in your sim_folder: ",
           sim_folder)
    }else if(length(files) < 1){
      stop("You must have a valid FLake namelist file in your sim_folder: ",
           sim_folder)
    }else{
      nml = files
    }
  }else{
    nml = nml_file
  }
  if (.Platform$pkgType == "win.binary") {
    return(run_flakeWin(sim_folder, nml_file = nml, verbose = verbose))
  }

  ### macOS ###
  if (grepl('mac.binary',.Platform$pkgType)) {
    # stop('No FLake executable available for your machine yet...')
    maj_v_number <- as.numeric(strsplit(
      Sys.info()["release"][[1]],'.', fixed = TRUE)[[1]][1])

    if (maj_v_number < 13.0) {
      stop('pre-mavericks mac OSX is not supported. Consider upgrading')
    }

    return(run_flakeOSx(sim_folder, nml_file = nml, verbose = verbose))

  }

  if (.Platform$pkgType == "source") {
    #stop('No FLake executable available for your machine yet...')
    return(run_flakeNIX(sim_folder, nml_file = nml, verbose = verbose))
  }
}

run_flakeWin <- function(sim_folder, nml_file, verbose = FALSE){

  if(.Platform$r_arch == 'x64'){
    flake_path <- system.file('extbin/win/flake.exe', package = packageName()) 
  }else{
    stop('No FLake executable available for your machine yet...')
  }

  origin <- getwd()
  setwd(sim_folder)

  tryCatch({
    if (verbose){
      out <- system2(flake_path, wait = TRUE, stdout = TRUE,
                     stderr = "", args=nml_file)
    } else {
      out <- system2(flake_path, args=nml_file)
    }
    setwd(origin)
    return(out)
  }, error = function(err) {
    print(paste("FLake_ERROR:  ",err))
    setwd(origin)
  })
}



# run_flakeOSx <- function(sim_folder, nml = TRUE, nml_file = 'flake.nml', verbose = TRUE, args){
#   #lib_path <- system.file('extbin/macFLake/bin', package=packageName()) #Not sure if libraries needed for FLake
#
#   flake_path <- system.file('exec/macflake', package=packageName())
#
#   # ship flake and libs to sim_folder
#   #Sys.setenv(DYLD_FALLBACK_LIBRARY_PATH=lib_path) #Libraries?
#
#   if(nml){
#     args <- c(args, nml_file)
#   }else{
#     args <- c(args,'--read_nml')
#   }
#
#   origin <- getwd()
#   setwd(sim_folder)
#
#   tryCatch({
#     if (verbose){
#       out <- system2(flake_path, wait = TRUE, stdout = "",
#                      stderr = "", args = args)
#
#     } else {
#       out <- system2(flake_path, wait = TRUE, stdout = NULL,
#                      stderr = NULL, args=args)
#     }
#
#     setwd(origin)
# 	return(out)
#   }, error = function(err) {
#     print(paste("FLake_ERROR:  ",err))
#
#     setwd(origin)
#   })
# }

run_flakeOSx <- function(sim_folder, nml_file = 'flake.nml', verbose=FALSE){
  flake_path <- system.file('exec/macflake', package='FLakeR')


  origin <- getwd()
  setwd(sim_folder)
  Sys.setenv(LD_LIBRARY_PATH = paste(system.file('extbin/nix',
                                                 package = packageName()),
                                     Sys.getenv('LD_LIBRARY_PATH'),
                                     sep = ":")))
  tryCatch({
    if (verbose){
      out <- system2(flake_path, wait = TRUE, stdout = TRUE,
                     stderr = "", args=par_file)
    } else {
      out <- system2(flake_path, args=nml_file)
    }
    setwd(origin)
    return(out)
  }, error = function(err) {
    print(paste("FLake_ERROR:  ",err))
    setwd(origin)
  })

}

run_flakeNIX <- function(sim_folder, nml_file = 'flake.nml', verbose=FALSE){
  flake_path <- system.file('exec/nixflake', package=packageName())


  origin <- getwd()
  setwd(sim_folder)
  Sys.setenv(LD_LIBRARY_PATH = paste(system.file('extbin/nix',
                                                 package = packageName()),
                                     Sys.getenv('LD_LIBRARY_PATH'), 
                                     sep = ":"))
  tryCatch({
    if (verbose){
      out <- system2(flake_path, wait = TRUE, stdout = TRUE,
                     stderr = "", args=par_file)
    } else {
      out <- system2(flake_path, args=nml_file)
    }
    setwd(origin)
    return(out)
  }, error = function(err) {
    print(paste("FLake_ERROR:  ",err))
    setwd(origin)
  })

}
