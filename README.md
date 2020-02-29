<h1 align = center> Monster Shop </h1> 

Contributers: 
[Sebastian Sloan](https://github.com/sasloan) 

#### Welcome to Monster Shop 

  In this app you will be able to see merchants and items as well as add items to your cart and complete orders to be 
  submitted to the merchant for fufillment. Visitors can also register and become perminant users of the app! In order to see
  our app at its full functionality please visit us at [Monster Shop](https://monster-shop-final-ss.herokuapp.com/).
  
#### How do download app to your local device

  For those who would like to inspect this code more closley and offer suggestions for improvment or give complaments for some
  good code please follow these instructions. 
  
  At the top of the page click on the `Fork` button.
  
  <img width="1384" alt="Screen Shot 2020-02-19 at 7 04 32 PM" src="https://user-images.githubusercontent.com/51456013/74894061-1d73c380-534b-11ea-8e30-8e1e5f700c75.png">
  
  This will make a copy of the app. so that you can mess with everything however you want to! Again feedback is welcome. Next
  lets copy this down to your local device. Please make sure you have a directory ready in your `CLI` once you do then you 
  will click on the `Clone or Download` button and click on the copy button the arrow is pointing to. 
  
  <img width="1339" alt="Screen Shot 2020-02-19 at 7 15 02 PM" src="https://user-images.githubusercontent.com/51456013/74894448-3fba1100-534c-11ea-9885-bb8f8ef7b0ad.png">
  
  once you are in your prefered dircetory type in these commands `git clone` , `space bar` , `command + V` , `return`.
  
  Great!! Now you have the app in your local device!!! But we are not done yet!! Now We have to set up the enviornment!! 
  
#### Setting up your local enviornment 

  now that we have your new Monster Shop app on your local device lets get it ready for you to use!! 
  
  fist type `cd monster_shop_final` 
  
  Next we are going to type in `bundle install` , `return`
  
  After you have waited for a while for everything you install, we are still not done, now we have to make a database
  We are going to run the following commands hitting `return` after each command. 
  
  `rake db:create`
  
  `rake db:migrate`
  
  `rake db:seed`
  
  Assuming that you did not get any errors your database is now set up!!! But let us make sure we don't have any testing 
  issues. So lets run 
  
  `bundle exec rspec` 
  
  you should have all passing tests!!! If for some reason you do not please message one of the contributers above. 
  
  Congragulations!!! your app is ready!!! now we can see the code and every test passes, all that is left is to see if the app
  looks locally. 
  
#### Seeing your app live 

  Next we are going to run `rails s` if you did it right (which lets face it, if you didn't then you probably shouldn't be coding) either way this is what your `CLI` should look like. 
  
  <img width="1424" alt="Screen Shot 2020-02-19 at 7 37 36 PM" src="https://user-images.githubusercontent.com/51456013/74895604-5150e800-534f-11ea-815c-1e6126aa294a.png">
  
  next lets see this bad boy on the browser, So we are going to open a new tab in our browser and in your URL bar and type in
  `localhost:3000` and if you did this right then this is what you should be looking at. 
  
  
<img width="1291" alt="Screen Shot 2020-02-19 at 7 41 01 PM" src="https://user-images.githubusercontent.com/51456013/74895763-c6bcb880-534f-11ea-9aa6-248daa22adbf.png">

#### Wrap up 

  Our code is clean and follows C.R.U.D. functionality and is very Restful. However we could have better options in our app 
  and much better C.S.S. 
  
  We hope that you enjoy our app as much as we enjoyed making it!!! As always feedback is welcome. Thank you! 
  

  
  
