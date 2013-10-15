# gCampImaging

This code features several main points of entry:

* pxp_analysis.m: Analyzes an input image for stimulus preference, pixel by pixel. Outputs image mapping each pixel to its preferred stimulus variant.
* dlr_analyse_visStim_singleton.m: Allows user selection of cells in an image to analyze, and then pulls out characteristics about selected cells. Will output graphs depicting stimulus onsets, raw delta fluorescence responses by stimulus and then ordered response by stimulus.
* dlr_analyse_visStim.m: As above, but concatenates four trial runs together, pulls out mean responses.
* plot_multiple_contrasts.m: Produces an informative 'card' for a cell, using 4 trials each at 5 different contrasts. Uses the above function for analysis, then concatenates into a single image.