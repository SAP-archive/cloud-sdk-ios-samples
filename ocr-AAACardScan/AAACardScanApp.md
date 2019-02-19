# AAACardScanApp

This blog describes a simple iOS application using SAP ML’s OCR scanning capabilities. For those who want to integrate OCR into their own application, this project serves as a guide to get started.  I use SAPML API to scan data from a sample card online and fill fields into a simple form. The app implements a ViewController which scans a AAA Insurance card and extracts `Membership id`, `Club code`, `Valid Thru` and `Member since` fields from a classic AAA card for the California Club.


  ![AAA classic example card ](./AAACardScanAppImages/AAACardExample.png?raw=true)


# Inspiration
Many apps ask users to enter their information from a physical card provided by a service provider (credit cards, insurance cards, etc.).  Entering these numbers from the card manually (membership number, expiry date, credit card number) lead to many human errors. As a consequence, the app developer validates the value of the fields and handles the errors until the user provides the correct information. This results into an unpleasant experience for both the developer and the user. Using OCR, we can reduce human input errors by scanning the required information from the card via their device camera. SAPML provides OCR features right out of the box.

# What is SAPFiori’s SAPML library?
SAPML is a general-purpose text recognition library based on top of Apple’s CoreML API. It provides features like the OCR Scanner which enables developers to locally execute ML models for different use cases.

# Approach
The `FUITextRecognitionView` performs text recognition using the device camera. I break down the implementation approach in the 5 points below:

1. Start the camera by calling `recognitionView.startSession()` on `viewDidAppear`

2. Capture the observation objects ‘Membership id’, ‘Club code’, ‘Valid Through’ and ‘Member since’ by sending the recorded frames to `SAPML`.

3. The `SAPML` framework returns an array of observations. Using the `observationHandler` we parse the observations array to find our desired objects.

4. End the camera session by calling `viewDidDisappear`.

5. Assign these object value in form of strings to different fields of a form.

![This is what we would achieve at the end of this blog](./AAACardScanAppImages/AAACardScanDemo.gif?raw=true)

# Implementation
Please refer to `AAACardScan.swift` in this code repository to follow along.

1. Declaring a `FUITextRecognitionView()` view:
  ```swift
  let recognitionView = FUITextRecognitionView()
  ```

  and add it as a subview of the controller.

  ```swift
  func viewDidLoad() {
      super.viewDidLoad()
      view.addSubview(recognitionView)
      ...
  }
  ```

  Here, `FUITextRecognitionView()` view shows the camera captured frames, runs the ML model, and also shows the text overlays which signify all the required objects as a confirmation to the user.

  ![overlays on the view](./AAACardScanAppImages/Overlay.png?raw=true)

2. We setup the `observationHandler` on the `recognitionView` so it to be called immediately called after the frames are recorded. These are then consumed by SAPML framework to provide an `observations` array to the observationHandler.
  ```swift
  recognitionView.observationHandler = self.observationhandler //Assigning the observationHandler
  ```

3. The `recognitionView.captureMaskPath` captures the portion of the video frames inside the `bezierPath`s bounds. Those are the only portions of the frame we use to detect the text.
  ```swift
  recognitionView.captureMaskPath = {

      // Set a custom `UIBezierPath`
      let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 350, height: 220), cornerRadius: 4)

      // Set a custom width of the line
      path.lineWidth = 1
      return path
  }()
  ```

4. Use `recognitionView.startSession()` to start capturing the video from device camera. However, the text detection model is not run on the captured frames until after camera stabilizes. After, the `observationHandler` will be called.
  ```swift
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      recognitionView.startSession()
  }
  ```

5. Let’s look at the implementation of `observationHandler`. The framework provides us with all the observations from the recorded frames. The `recognitionView.observationHandler` runs on each frame to extract the observation objects into a `[RecognizeTextObservation]` array. `RecognizeTextObservation` is the object which holds the observation string and the coordinates of an Observation object in the frame (`club code` on the card).

6. The function `nextStringInColumn()` finds the string just below a particular Observations in the card.

  ![Block diagram of the observations in the card](./AAACardScanAppImages/ObservationObjectsTopology.png?raw=true)

  Consider Observation A i.e find ‘club code’ number (071) marked in red. Please refer to above card block digram image, while going through the algorithm below:

7. To find the `club codenumber` we try to find the first occurrence of string ‘club’ (marked in yellow block of A in above card block digram image) in the `[RecognizeTextObservation]` array.
  ```swift        
  if let clubCodeObservation = observations.first(where: {$0.value.compare("club", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) == .orderedSame} ) {}
  ```

8. The actual club code number lies just below the String `Club`, considering the card as a topology of rows and columns. I can can now infer that the actual club code number is the next string found in the column. I use a traversing function `findNextObservationInColumn()` to find the next string.

9. If we look closely at the Observation A’s `bottomleft.x` of the yellow block and `bottomleft.x` of the red block, they are almost the same. So, I find the `rangeX` of the red block with respect to yellow blocks by adding and subtracting an uncertainty factor of 0.02. Similarly, I try to find the range of Y coordinate in `rangeY` i.e. the `bottomLeft.y` of the yellow block +- uncertainity factor of 0.02 will be `topLeft.y` of the red block. Once I have the possible ranges of X and Y coordinates of the desired red block (071) I check if the current observation object found while parsing the Observations array has the value of `topLeft.x` in `rangeX` and `topLeft.y` in `rangeY`. If that is true for any observation, we found our desired club id number observation object. Similary we find the observation objects found below Membership Id, Valid Thru and Member Since in the AAA Classic card shown in the block diagram of AAA card below

  Here, `tolerance factor` is a convinient value to find if point `A.x - tolerance factor <=~ B.x <=~ A.x + tolerance factor`. We will still consider the objects found within this tolerance factor. This factor can vary according to different card use cases and developer could make a intelligent choice of this factor depending on the use case.

  The function below implements this logic.
  ```swift
  func nextObservationInColumn(observations: [RecognizeTextObservation], for observation: RecognizeTextObservation)              -> RecognizeTextObservation?{

    let rangeX = (observation.bottomLeft.x - 0.02)...(observation.bottomLeft.x + 0.02)
    let rangeY = (observation.bottomLeft.y)...(observation.bottomLeft.y + 0.02)
    return observations.first(where: { rangeX.contains($0.topLeft.x) &&  rangeY.contains($0.topLeft.y)})
  }   
  ```
  So, from a AAA classic card I find the below observations:
    * memIdObv as member id (eg: 010600556)
    * clubIdObv as club id (eg: 071)
    * memberSinceObv as member since year (eg: 2000)
    * validThruObv as valid through date (eg: 11/30/20)

10. Once the recognitionView.observationHandler provides us with all the observations objects, we check after every iteration if all objects have been recognized.
  ```swift
  guard let memIdObv = memIdObv, let validThruObv = validThruObv, let memberSinceObv = memberSinceObv, let clubIdObv = clubIdObv else { return false }
  ```

11. We then pass them to recognitionView.showTexts() method which takes the array of found objects as an argument. The ` recognitionView.showTexts() ` methods shows the user on the camera screen that it has detected the following objects and is about to close the camera.
  ```swift
  let allObvs: [RecognizeTextObservation] = [memIdObv, clubIdObv, memberSinceObv, validThruObv]
  recognitionView.showTexts(for: allObvs, with: nil)
  ```

12. We push the `UITableViewController` and cause the controller to call `viewDidDisappear(_:)`.  The camera closes by calling self?.recognitionView.stopSession() method and then assign the cached values from the observation objects.
  ```swift
  DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
        self?.recognitionView.stopSession()
        let form = AAACardFormTableViewController()
        form.membershipId = memIdObv.value
        form.validThru = validThruObv.value
        form.memberSince = memberSinceObv.value
        form.clubId = clubIdObv.value
        self?.navigationController?.pushViewController(form, animated: true)
  }
  return true
  ```

# Conclusion

OCR scanner api’s of SAPML provide an easy way to integrate card scanning abilities into the app. The developer does not have to worry about image pre-processing and building a drop-in View for the scanner screen. Thus, helping the developer build a better user experience.
