# MVVM-IOS
MVVM-IOS POC

# MVVM architecture
MVVM (Model-View-ViewModel) is derived from MVC(Model-View-Controller). It is introduced to solve existing problems of Cocoa's MVC architecture in iOS world. One of its feature is to make a better seperation of concerns so that it is easier to maintain and extend.

![alt text](https://cdn-images-1.medium.com/max/1600/1*Tb8dnc4-CN8ht1Sk72-Avg.png)

Markup : 1. Model: It is simillar to model layer in MVC (contains data business logic)
         2. View: UIViews + UIViewControllers (We treat both layout view and controllers as View)
         3. ViewModel: A mediator to glue two above layer together.
          
An important point in MVVM is that it uses a binder as communication tool between View and ViewModel layers. A technique named Data Binding is used.

