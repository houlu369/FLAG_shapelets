# FLAG_shapelets
The results in Table 2 and 3 for paper [EfficientLearning of Timeseries Shapelets](http://www.aaai.org/ocs/index.php/AAAI/AAAI16/paper/view/12382/11724) can be reproduced by running FLAG.m. Several instructions are:
 
1. One needs to download the data sets from UCR and UEA repository himself and save them to the folder named data. The link to these two data bases are:
[UCR](http://www.cs.ucr.edu/~eamonn/time_series_data/), 
[UEA](https://www.uea.ac.uk/computing/machine-learning/shapelets/shapelet-data).
2. One might need the libsvm library to do the classification. The library can be downloaded from
https://www.csie.ntu.edu.tw/~cjlin/libsvm/.
3. The parameters a1 and a2 for each dataset are tuned by cross validation and  are already given in FLAG.m.
4. Binary class data sets Gun_point and MoteStrain use shapelets from one dominant class, all the other data sets use shapelets generated from all dominant classes.
5. The final output accuracy results should be the same as that in results.txt. Note that some datasets may have better acc results than that in the paper due to our further improvement on the code.
