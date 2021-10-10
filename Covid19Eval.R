library(tidyverse)
library(lubridate)
library(plotly)
library(plyr)
library(orca)


#setwd directory can be commented out before running this code. 
#setwd('/Users/zanubhassan/Documents/ME459FinalProjectData')

# First GOAL - Comparing covid cases before and after lockdown
#reading the csv file 

cases_counties <- read.csv(file = "us-counties.csv", header = TRUE)
str(cases_counties) #checks the structure of the data

#mutate adds new variables and preserves the existing ones.
#lubridate helps read dates properly in R and lets you arrange the order in which date are expressed.

#The code in the line below allows the date to be read in a chronological order as values
#and not characters. It is also orders the date in the month date year format.
cases_counties<-cases_counties %>% mutate(date= lubridate::mdy(date))

#The as.Date function right below this is another way of ordering dates chronologically.
#cases_counties$date<-as.Date(cases_counties$date, format ="%m/%d/%Y") 

# scattered plot of date vs cases using plotly pacakage.
#Plotly plots the data and shows the graph in an interactive form where you can hover on each point
#counties are represented by colors

#%>% is a pipe operator that can joint several arguments into one argument

#first goal in proposal plot
p<-plot_ly() %>%
add_trace(data = cases_counties,
           x = ~date,
           y = ~cases, 
           color = ~county,
           colors = "Dark2",
           type = "scatter",
           mode = "markers",
           marker = list(size = 10)) %>%
  layout(title = "Covid Cases Before and After Lockdown (Jan1 -Nov 21 2020)"
        )
#p is a plotly object. It is isolated below to reprint the graph each time we run control+shift+enter when we make changes
p

#orca is used for exporting static images into current directory. 72 that is multiplied by width and height is the DPI 
#for my macos. so this value could be different for windows.
#The width and height has been adjusted for each plot to be able to fully export the graph

orca(p, "Cases-Counties-plot.pdf", width = 25*72, height = 29*72)



#2nd Goal - Comparing google search interest of an item to the increase in covid cases

directory = "Goal2CSVFiles"
#the list.files will read all the files in the particular folder of directory
csvfiles = list.files(path = directory, pattern = "*.csv", full.names = TRUE)
#csv files shows all the files in the folder Goal2CSVFiles
csvfiles

#the ldply is what combines all the files into one data frame. In this case Goal2data_csv
Goal2data_csv<-ldply(csvfiles, read_csv)
Goal2data_csv<-Goal2data_csv%>%mutate(date = lubridate::mdy(date))
fig1<-plot_ly(Goal2data_csv)%>%
add_trace(x = ~date,
          y = ~lysol,
          name ="Lysol",
          type = "scatter",
          mode =  "line+ markers",
          yaxis ="y1")%>%
add_trace(x = ~date,
            y = ~facemask,
            name = "facemask",
            type = "scatter",
            mode =  "line+ markers")%>%
add_trace(x = ~date,
          y = ~covidtestingnearme,
          name = "covidtestingnearme",
          type = "scatter",
          mode =  "line+ markers")%>%
  
#The yaxis for this trace is set to y2 because it has a different yaxis compared to the other three
  add_trace(x = ~date,
            y = ~cases,
            name = "covidcasesinIllinois",
            type = "scatter",
            mode =  "markers",
            yaxis = "y2")%>% 
  layout(title = "Google Web Search Interest Count of Three Components,
                 and Covid Cases in Illinois",
         yaxis =list(side = 'left', title = 'Web Search Interest Count'),
         yaxis2 = list(side = 'right', overlaying = "y", title = 'Covid Cases Count in Illinois'))


#fig1 is the object for the plot for second goal
fig1

orca(fig1, "WebSearchCount-plot.pdf",width = 16*72, height = 20*72)

#3rd Goal - Comparing Covid Cases vs Population, and Checking if cases reported are higher in counties
#with higher population.

directory = "Goal3CSVFiles"
#the list.files will read all the files in the particular folder of directory
csvfiles = list.files(path = directory, pattern = "*.csv", full.names = TRUE)

#csv files shows all the files in the folder Goal3CSVFiles
csvfiles
#the ldply is what combines all the files into one data frame.
Goal3data_csv<-ldply(csvfiles, read_csv)
Goal3data_csv<-Goal3data_csv%>%mutate(date = lubridate::mdy(date))
#first plot
fig2<-plot_ly(Goal3data_csv)%>%
  add_trace(x = ~population,
            y = ~CountyName,
            colors ="Dark2",
            color = ~CountyName,
            type = "bar")%>%
  layout(showlegend = TRUE)


#2nd plot
fig3<-plot_ly(Goal3data_csv) %>%
  add_trace(x = ~date,
            y = ~cases, 
            color = ~county,
            colors = "Dark2",
            type = "scatter",
            mode = "markers",
            marker = list(size = 5))%>%
  layout(showlegend = FALSE,
         yaxis =list(title ="cases", side = 'left'),
         xaxis = list(title = "dates", side = 'left'))

#3rd plot
fig4<-plot_ly(Goal3data_csv) %>%
add_trace(x = ~Collegecovidcases,
          y = ~college, 
          color = ~county,
          colors = "Dark2",
          type = "bar")%>%
  layout(showlegend = FALSE,
         yaxis=list(title ="college", side ='left'),
         xaxis=list(title ="Collegecovidcases",side ='left' ))

#subplot. This plots all three graphs in one sheet. nrows = 3 specifies how many rows
#the graph should be arranged. In this case I have all 3 graphs above one another.

fig<-subplot(fig2, fig3, fig4, nrows = 3)
fig<-fig%>% layout(title = " Effect of Population on Covid cases in 
                            Colleges and Counties",
                   showlegend = TRUE, showlegend2 = FALSE)
#fig is the object for the plot for the 3rd goal
fig

orca(fig, "3rd goal.pdf", width = 25*72, height = 29*72)





    
  
  
  
  
  
  


 



  

