# Restaurant Clustering App
Creating an app that generates a map of restaurants in certain cities, and features a Latent Dirichlet allocation (LDA) model that uses spectral initialization in order to assess which restaurants are most similar to those that a business is currently supplying. 

### Link to App


### Statement of Work
Using data from allmenus.com, I will retrieve restaurant menu data, including general information pertaining to the restaurant, and develop a tool that is capable of displaying which restaurants are similar to one another. The tool will use topic modeling to classify the restaurants into different topics based on the contents of their menu.
Specifically, I will create an LDA model with an assigned number of topics (k) and evaluate the gamma values for each restaurant (document). The gamma values tell us how likely a document belongs to a topic. Following this, I will create a Euclidean distance matrix by performing k-means clustering on a matrix of the gamma values as a way of assessing how closely similar the restaurants are to one another.

### Problem Statement
Business owners want to reach out to potential customers of their product/service. This tool will help distinguish which restaurants are similar to those they already service, which can help improve sales efficiency.

### Technical Objectives
*Environment:* R via R Studio

*Data Sources:* Allmenus

*Workflow:* Agile

The final output will be an R Shiny application, which features a data frame consisting of each restaurant's most similar restaurants, as well as general information. It will feature various tools that allow the user to look at restaurants based on a variety of characteristics.

### Results
![alt text](www/dashboard.gif)
