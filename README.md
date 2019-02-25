# virtual-Tourist
udacity's virtual-Tourist

Virtual Tourist is an iOS app that allows users to visit virtual locations by adding pins to a `MKMapView`. Once a user taps a pin the app fetches photos from `Flickr` for the desired location.

virtual-Tourist allows users to drop pins on a map, as if they were stops on a tour. If the user tap on one of the selected pins, the app will download and store images of the picked location from Flickr.

The user will be able to view the images in a collection view and can download new images by clicking on a **New Collection** button located on the collection view window.

## Implementation

The app has two view controller :

- **LocationsMap** - shows the map and allows user to drop pins any where in the map. As soon as a pin is dropped images of the choosen locaction will be fetched from Flickr. The actual photo
  downloads occur in the CollectionView.

- **CollectionView** - allow users to view images and delete the unwanted ones. Users can create new
  collections and delete photos from existing albums.

Application uses CoreData to store Pins (`NSManagedObjectContext.executeFetchRequest`) and Photos 
(`NSFetchedResultsController`) objects. All API calls run in background (`NSURLSession.dataTaskWithRequest`).
Preloaded files saved in memory cache (`NSCache`) and file system (`NSFileManager`) and removed as soon as Photo object 
removed from CoreData.
**Prerequisites**

It was built using Xcode Version 10.0 (10A255)along with Swift 4.



