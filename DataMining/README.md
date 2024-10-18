XYZ Sports Company is a well-established fitness facility that has been serving the community for several years. To enhance its marketing strategies, improve customer engagement, and tailor its services, the company aims to develop a comprehensive customer segmentation strategy. This project focused on dividing the customer base into distinct segments based on various characteristics and behaviors.

For **Data Preprocessing**, we did a coherence check, outlier removal, data normalization, dealt with missing values, feature engineering, encoding and feature selection. We created two segmentations to garantee the quality of cluster analysis.
 - _Service Usage_: Evaluates the usage of the gym’s services, by a certain customer. Usage means
the total value expended, the total number of visits and activities enrolled. For this
segmentation, we decided to use both categorical variables, binary and ordinal, and also metric variables.
 - _Engagement Level_: Evaluates the customer's engagement with the gym, taking in consideration its recently activity in the facilities. We used only numerical variables.

Given the types of variables in eacg segmentation, for _Service Usage_ we decided to use K-Prototypes - it combines K-Means and K-Modes - providing an algorithm for clustering data that contains both numerical and categorical features.
For _Engagement Level_ we used Hierarchical Clustering, K-Means, Mean-Shift, DBSCAN, GMM and SOM.

To merge both segmentations, we used Hierarchical Clustering method with fewer clusters with a significant number in them. 

After the analysis, we developted a marketing plan based on the results we got.
