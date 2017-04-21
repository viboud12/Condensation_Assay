// This troubleshooting plugin uses the selected image for quantification from the 
// Consensation_Assay_.ijm plugin and displays what the threshold of your choice is quantifying.


run("Set Measurements...", "area mean standard min perimeter integrated median stack display redirect=None decimal=4");

setBatchMode(true);

MAXviboud2 = getImageID();
t = getTitle();
t2= t +' processed';
DECONDviboud = getImageID();
rename(t2);

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
setBatchMode("exit & display");
   
