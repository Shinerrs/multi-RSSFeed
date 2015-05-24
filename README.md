
Introduction	2
Application	2
Home Screen	2
Add a Feed	3
Edit Feed	3
Completion of Edit	4
Selecting a Feed	4
Detailed RSS Feed	5
Showing the RSS	5
Side Note – Failure to connect	6
Conclusion	6


Introduction
============

I decided to develop an iOS application that allows me to have access to all my RSS Feeds that I access on a daily bases or even weekly centralized within one application. To give the application the potential of consistency across multiple devices I implemented the use of an AWS Instance and AWS Rational Database (RDB) to provide the application a cloud application.
To store the client information I used a MySQL database to store the information. That Swift does not have any direct library I used the processing language of PHP5 that provide processing logic to tasks. To allow the two separate languages to collaborate on certain tasks, I used the common language that is on a massive rise over XML which is JSON. I first store the data into an array with a format to provide ValueForKey referance to easy access the data I need from within the JSON communication.

The application has a User Login screen. This main purpose is to provide an index for user active to provide CRUD functionality that just would not be available without the user indexing. The Application allows you to add an RSS Feed, There is no limitation on how many you can add. 

In this project I used an Async approach with the use of dispatching output to the main tread. With an aSync approach it handles a lot of issues like the application freezing or terminating unexpectly.
Application

Home Screen
-----------


![enter image description here](https://c2.staticflickr.com/6/5337/17857007519_39bdb10aed_b.jpg)

![enter image description here](https://c1.staticflickr.com/9/8815/17422719013_3bb73f0f17_z.jpg)

After you login to the application you are displayed a table of all RSS feeds that the user has added. When you swipe the table, you get two options edit and delete. In the top left you have add and in the top right you have logout.

![enter image description here](https://c1.staticflickr.com/9/8814/17857007279_e0f5df3fa9_z.jpg)

Add Feed collects the data from the user. A HTTP request is made and the post data is sent with what the user has inputted. Extra information like Username is also sent to fulfill the indexing of the entry to the user. 

![enter image description here](https://c2.staticflickr.com/6/5336/17420670884_81280e7b36_z.jpg)

When the user clicks edit, they are brought to a View Controller (VC) that segues the data from the HomeVC to the EditVC. This is Name and URL. On both Edit and add there is a check to make sure that the URL is NSURL compatible. If a user types google.com it will fail, it requires the Http:// and the TLD domain prefix at the end.

![enter image description here](https://c1.staticflickr.com/9/8814/17857007279_e0f5df3fa9_z.jpg)

When the task is completed, the app reads the JSON from the HTTP session and if success = 1, then it has passed and show alert to tell the user. This also Segues at the end to bring the user back to the home screen.

![enter image description here](https://c2.staticflickr.com/6/5448/17420670794_aa5aaceaa5_b.jpg)

When you select a feed, you are then presented with the top 10 articles. 

![enter image description here](https://c2.staticflickr.com/6/5333/18044102931_dea4123289_b.jpg)

For Efficiency, the data is sent from the previous RSS feed to the current VC and then displayed. With that data a URL to that article is sent. When a user clicks read me the user is redirected to a webview and the article is displayed. 

![enter image description here](https://c1.staticflickr.com/9/8856/17857007259_7a98b84fab_z.jpg)

When the user clicks the Read More, the URL is sent to the webview with the user and the url variable that was segued is loaded.

Conclusion
==========

The main limitation to this application is that if the end provider to the RSS does not format the RSS format and use some generic format, this could result in a return of an alert saying failure to connect but the issue could be larger like the format is not working. I have tried a few RSS feeds to check the integrity of the system and the results were better then expected. That this application was built with my own personal demand, I attempted a few RSS feeds that I use personally and expanded out to some sites that I only use once every half a year. I tried CNN, EA, RTE and the Local. 

While they did work I did notice that I was getting HTML tags back from within the XML. This was due to, what I expected, automatic generation of the XML resulting in bad Parsing. The main one that interested me was The Local. The local provides multiple country news in English. First founded in Sweden they have expanded to Germany, France, Spain, Switzerland, Norway, Demark, Austria and Italy. All these expansions have their own independent site from each other which means that their RSS feeds are all separated. This is what led me to develop this app. After trying The Local SE, The Local FR, the Local DE and a few more, I was happy with the result.

The only problem which is a non-functional element is in the case the the RSS source is not mobile friendly. I have found that some RSS WebViews are not optimised for mobile use and so the user is requires the scroll all over to try get information. 
