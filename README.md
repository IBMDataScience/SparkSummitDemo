### SparkSummitDemo
--- 

This repository contains a Python Notebook and R Shiny App created using IBM Data Science Experience.  Sign up or log-in on [Data Science Experience](http://datascience.ibm.com/) and follow along with the steps below.

--- 

###### 1. Data Science Experience Set up
- First [download the repository](https://github.com/IBMDataScience/SparkSummitDemo/archive/master.zip) to your local environment (you will upload files from the data directory to Object Storage)
- Log-in to Data Science Experience and click Start a Notebook
- If you have not started any Spark services, click the link to create a Spark instance
  - You will need to connect your BlueMix at this time
  - The first part is configuring the Spark instance
  
  - The second step is to add a Object Store
  
- Once the service is added, go back to your Spark instance and click Manage Object Storage

- There will be a card for your object store - click that to go to Bluemix to add your files
- In Bluemix you will see the container created when the Spark instance was created
- Click Actions then Add File - you need to add BlocPower_T, CDD-HDD_Features, and HDD_Features

- Now you are ready to run a notebook using these data sources


###### 2. Running Jupyter Notebook
- Click on New Notebook
- Click the tab for From URL, add a Name for the notebook 
- Copy the URL for the Jupyter notebook - https://raw.githubusercontent.com/IBMDataScience/SparkSummitDemo/master/BlocPower%20with%20Sparkling.ipynb
- For the Spark Service, select the service created in step 1 that has the Object Store associated with it, create the notebook
- To read the data from the right location, the container name chosen in step 1 needs to be inserted in the first three code cells
- For the code example below, my container was named myContainer:
  ```
    file1 = 'swift://myContainer.spark/BlocPower_T.csv'
 ```
  If you forgot your container name, click on Data Source on the right side bar and click "Insert to code" for one of the files, this will show the container name


- Now you can run each cell to recreate the analysis
- Follow along each of the following steps:
  - Data cleaning
  - Fitting a linear regression model
  - Conducting k-means clustering

###### 3. Running the Shiny App - Flex Dashboard
- Open RStudio in Data Science Experience from the left navigation bar 
- Create a new R Markdown Document
- Copy the raw [R Markdown from here](https://raw.githubusercontent.com/IBMDataScience/SparkSummitDemo/master/shinyDemo.Rmd)
- Paste this code in your new R Markdown document in Data Science Experience
- Select lines 21 - 65 and execute (This is a one time set up to install all necessary packages)
- Click the Knit button with the ball of yarn next to it
- Open the app in a browser to interact with it, share the link with anyone
