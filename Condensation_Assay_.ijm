// This version of the area assay works for timelapses that have the one channel you
// are interested in. It will prompt you to choose the number of frames you want to
// use. Duplicate the image with those frames and click OK.
// It will automatically save the data and image you have selected for quantification
// in the folder of your choice.
// It will also run on a maximum intensity projection.


run("Set Measurements...", "area mean standard min perimeter integrated median stack display redirect=None decimal=4");

// Get image info, select destination folder
viboud = getImageID();
t = getTitle();
t2= t +' processed';
dir2 = getDirectory("Choose Destination Directory ");

// Make maximum intensity projections
getDimensions(width, height, channels, slices, frames);
for (j = 0; j < slices; j++);
run("Z Project...", "start=1 stop=[j] projection=[Max Intensity] all");
MAXviboud = getImageID();

// Choose frames to be analyzed by duplicating the image with correct frames
title = "Duplicate with correct frames, then click OK";
  	waitForUser(title);
MAXviboud2 = getImageID();

// Select region in which the feature is from frame to frame
// The box size can be modified (where noted below), as can the number
// of pixels that will be thresholded (box size does affect thresholding)
selectImage(MAXviboud2);
getDimensions(width, height, channels, slices, frames);
// Modify two last values (number of pixels) to modify box size
makeRectangle(282, 267, 147, 147);
for (i = 0; i < frames; i++) {
  	title = "Select the area you want to quantify and click OK";
  	waitForUser(title);
	Roi.getBounds(x,y,width,height);
	run("Duplicate...", "getTitle(viboud)");
	selectImage(MAXviboud2);
	run("Next Slice [>]");
	makeRectangle(x, y, 147, 147);
}
selectImage(viboud);
close();
selectImage(MAXviboud);
close();
run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use");
DECONDviboud = getImageID();

//// Batch mode through the analysis and file saving to above-defined directory ////
setBatchMode(true);

// Save raw timelapse to be quantiifed as TIFF
rename(t2);
saveAs("Tiff", dir2 + t2 + ".tif"); 

// Thresholding on timelapse frame by frame
// Modify thresholding value to your dataset's needs or for a different box size
selectImage(DECONDviboud);
resetThreshold();
getDimensions(width, height, channelCount, sliceCount, frameCount);
run("Clear Results");
for (m = 0; m < sliceCount; m++) {
	n = m + 1;
	selectImage(DECONDviboud);
	Stack.setPosition(1,n,1);
	run("Duplicate...", "title=CroppedImage");
	getStatistics(area, mean, min, max, std, histogram);
	// The 0.42 below is the value that should be adjusted if modifications are to be made
	// for use with different data sets
	favThresh = min + 0.42*(max-min);
	setThreshold(favThresh, max);
	run("Convert to Mask");
	rename(t);
	run("Measure");
}
run("Images to Stack", "name=thresholdedCroppedStack title=[] use");
AREAviboud = getImageID();

// Save thresholding data as .xls in above-defined directory
if (nResults==0) exit("Results table is empty");
   saveAs("Measurements", dir2 + t2 + ".xls");
selectImage(DECONDviboud);
close();
selectImage(AREAviboud);
close();







