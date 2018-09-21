# JRCLUST: Janelia Rocket Cluster
[Scalable, cross-validated and drift-resistant](https://github.com/JaneliaSciComp/JRCLUST/wiki/Performance-benchmark) spike sorting pipeline for [high-density silicon probes](https://www.nature.com/articles/nature24636)  
Developed by [J. James Jun, PhD](https://sites.google.com/view/rocketephys)

[Click here to download latest releases](https://github.com/JaneliaSciComp/JRCLUST/releases)

[Click here to view JRCLUST GitHub Wiki](https://github.com/JaneliaSciComp/JRCLUST/wiki)

[Click here to read the BioRxiv paper](https://www.biorxiv.org/content/early/2017/01/30/101030)

[Click here to view video tutorials](https://www.youtube.com/playlist?list=PLbvLpg5J7t9FC4s0umOB--2ZYcrmNRyZ_)

This is a customized version of JRCLUST by jup36.
- auto_split_wav_.m has been modified not to skip the cluster # selection, and the cluster-by-cluster view. 
- maxCor_drift_.m has been rolled back to use the pearson waveform correlation, not the distance metric added by Svoboda lab. 
