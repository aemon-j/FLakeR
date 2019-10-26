FLakeR
====


R package for basic [FLake](http://www.flake.igb-berlin.de/) model running. `FLakeR` holds the version downloaded from the [website](http://www.flake.igb-berlin.de/site/download) on 2019-10-25 and should run virtually on any 32-bit Windows system.  This package does not contain the source code for the model, only the executable. This package was inspired by [GLMr](https://github.com/GLEON/GLMr).

## Installation

You can install FLakeR from Github with:

```{r gh-installation, eval = FALSE}
# install.packages("devtools")
devtools::install_github("aemon-j/FLakeR")
```
## Usage

### Run

```{r example, eval=FALSE}
library(FLakeR)
sim_folder <- system.file('extdata', package = 'FLakeR')
run_flake(sim_folder, nml_file = 'Heiligensee80-96.nml')
```

### Output
Suite of tools for working with FLake output coming soon...
