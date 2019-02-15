# SAPFioriBikes: Visualization of GoBike Stations Built with the SAP Cloud Platform SDK for iOS
This blog describes a Ford GoBike app built with SAPFiori components that allows users to quickly and easily utilize the GoBike service by providing visualization of GoBike stations.
The Ford GoBike map below clusters the stations into groups for easy accessibility:

![SAPFioriBikes iPhone](./ReadMeImages/No_Legend_iPhone.png?raw=true)

> Check out the Ford GoBike map implementation [HERE](https://github.com/alextakahashi/SAPFioriBikes/tree/master)

# Inspiration

San Francisco Bay Area residents are familiar with [Ford GoBike](https://www.fordgobike.com/) Stations.  Members of the service pick up a bike from one station then ride to and redock at another station.  This service provides a cost effective alternative to driving a car and ride-share options, and can be more convenient than waiting for public transit.  Additionally, since bikes must be docked, our streets are cleaner, more accessible, and less clutered compared to other bike and scooter options ([Lime and Bike pushed out of SF](https://www.sfchronicle.com/business/article/Shut-out-of-San-Francisco-Lime-and-Bird-look-13242319.php)).  Commuters are going to need as many options as possible to get from one place to the other,  especially during the [BART Transbay Tube Retrofit](https://www.bart.gov/about/projects/eqs/retrofit) starting February 2019.

Looking at the Ford GoBike map below, I noticed that it was cluttered with stations that were indistinguishable:  

![Ford GoBike Map Cluttered Station](./ReadMeImages/Ford_Bikes_Unclustered.PNG?raw=true)

Fortunately during the Apple Worldwide Developers Confrence (WWDC 2017), MapKit introduced [`MKClusterAnnotation`](https://developer.apple.com/documentation/mapkit/mkclusterannotation) which consolidates annotations.

The [TANDm](https://developer.apple.com/documentation/mapkit/mkannotationview/decluttering_a_map_with_mapkit_annotation_clustering) app showed clusters of annotations (bicycle, tricycle, and unicycle) annotations that translated nicely to the Ford GoBike bikes and eBikes:

![TANDm Cluster Annotation Screen shot](./ReadMeImages/Tandm.png?raw=true)



# Implementation

I used features from:
- [SAP Fiori iOS SDK](https://developer.apple.com/sap/) [Map Floorplan](https://experience.sap.com/fiori-design-ios/article/map/) to provide the foundation of the application
-  `FUIMapToolbar` and `FUIMapLegend` to display annotations and describe what they mean

Follow along using the code [HERE](https://github.com/alextakahashi/SAPFioriBikes/tree/post1).  

## Map View Controller

```swift
class ViewController: FUIMKMapFloorplanViewController, MKMapViewDelegate {

    override func viewDidLoad() { ... }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { ... }
}
```

Subclassing the `FUIMKMapFloorplanViewController` gives the `MKMapView`, `FUIMapToolbar` (Vertical stack on the right), and `FUIMapDetailPanel` (Bottom panel) for free.  We implement the `MKMapViewDelegate` to show the custom `BikeStationAnnotationView`.  Nothing should look out of the ordinary until we reach the `FUIMKMapViewDataSource` and `FUIMapLegend` implementations.

## Layers & Geometries

Annotations in the `FUIMKMapFloorplanViewController` are shown in the map as geometries (`FUIAnnotation`) in geometry layers (`FUIGeometryLayer`).  Geometries include `MKAnnotation`s, `MKPolyline`s, and `MKPolygon`s. Organizing geometries by layer is a convenient way to filter and organize data.

For the purpose of this example, we work with a simple model with a single layer.  We set the delegate in `viewDidLoad()` by setting:

```swift
self.dataSource = self
```

and extend the `ViewController` by implementing the `FUIMKMapViewDataSource`.  

```swift
extension ViewController: FUIMKMapViewDataSource {

    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [FUIAnnotation] {
        return mapModel.stationModel
    }

    func numberOfLayers(in mapView: MKMapView) -> Int {
        return mapModel.layerModel.count
    }

    func mapView(_ mapView: MKMapView, layerAtIndex index: Int) -> FUIGeometryLayer {
        return mapModel.layerModel[index]
    }
}
```

## Map Model

The `FioriBikeMapModel` owns map business objects used in the `ViewController`.  The standard map business objects `title`, `region`, and `mapType` are set at the top.  In the `layerModel` there is a single layer, the `"Bikes"` layer.  The `stationModel` will contain all Ford GoBike Stations once it is populated by calling `loadData()`.  Optionally we can query real-time data by setting the `isLiveData` to true within the function.  Private functions are located at the bottom, but the most important part is the call to the delegate at the very end.

```swift
self.delegate?.reloadData()
```

This function call reloads the geometries and layers on the map.  At this point all the station information is loaded.

## BikeStationAnnotation

`BikeStationAnnotation`s are constructed while loading the `stationModel`.  Use in the `FUIMKMapFloorplanViewController` requires the annotation to implement the `FUIAnnotation` protocol which requires a `state`, `layer`, and `indexPath`.  For simplicity's sake, we set them to default values.  We also store information we want to display on the map including the `coordinate`, `title`, `numBikes`, `numEBikes`, and `numDocsAvailable`.

## BikeStationAnnotationView

![Annotation Image](./ReadMeImages/BikeAnnotationView.png?raw=true)

The `BikeStationAnnotationView` takes inspiration from TANDm with their cluster annotation.  With a few minor changes to the original source code, I am able to display the number of bikes and eBikes at each station.  Tap the legend button to show the meaning of each color.  

![Clustered Annotations](./ReadMeImages/Zoom_Extent_Cluster.png?raw=true)

Optionally, we can also get the total number of bikes and eBikes from all the clusters under this view by getting the `memberAnnotations`.  Tap the [Zoom Extent Button](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Classes/FUIMapToolbar/ZoomExtentButton.html) to show all the annotations in the map.  Looks like there are not any eBikes outside of San Francisco.  

## iPad Support

The floorplan also supports an iPad layout.

![No Legend iPad](./ReadMeImages/No_Legend_iPad.png?raw=true)

![Show_Legend_iPad](./ReadMeImages/Show_Legend_iPad.png?raw=true)

## Next Steps

This project implements a few features of the Map Floorplan including:
* Adding map annotations and cluster annotations
* Zooming to show all annotations
* Implementing the map legend

In the next post I will extend this project to implement:
* [Search Results View Controller](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Classes/FUIMapDetailPanelSearchResultsViewController.html) to filter annotations
* [Content View Controller](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/3.0/en-US/Documents/Frameworks/SAPFiori/Classes/FUIMapDetailPanelContentViewController.html) to show additional details of an annotation

Read the next blog post [HERE](https://blogs.sap.com/2019/01/31/sapfioribikes-searching-and-displaying-gobike-stations/)

The completed project can be found [HERE](https://github.com/alextakahashi/SAPFioriBikes)

## Conclusion

At first glance maps can feel quite overwhelming since they can display an extensive amount of information. It is important to keep the user focus on the most relevant information.  The Map Floorplan provides the foundation for a robust map with a minimal amount of code on the developer's end.   
