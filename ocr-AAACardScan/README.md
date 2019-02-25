# AAACardScanApp
This repository hosts an iOS application AAACardScanApp built using SAP Cloud Platform SDK for iOS.  I use the `SAPFiori` and `SAPML` frameworks to show the OCR scanner capabilities. This is a simple app to scan different objects from a AAA classic card.

## API References

* [SAPFiori Reference](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/Latest/en-US/Documents/Frameworks/SAPFiori/index.html)

# Requirements

* Xcode 10.1+
* SAP Cloud Platform SDK for iOS 3.0 SP01+
  * SAPFiori
  * SAPCommon
  * SAPML
  * SAPML-Dependencies
    * GoogleMobileVision.framework
    * GoogleToolboxForMac.framework
    * GTMSessionFetcherIOS.framework
    * Protobuf.framework

# Configuration

1. Add the `SAPFiori.framework`, `SAPCommon.framework`, `SAPML.framework`, and SAPML-Dependencies `GoogleToolboxForMac.framework`, `GTMSessionFetcherIOS.framework`, and `Protobuf.framework` to the `Embedded Binaries` and `Linked Frameworks and Libraries`. 
Make sure that `GoogleMobileVision.framework` is *not* added.

2. Build and Run 📸

3. Walkthrough the code implementation [blogpost](AAACardScanApp.md)


# Limitations

This app might not be able to scan all the AAA card formats and works best with card images provided in the `AAACardScanAppImages` folder. 
As part of the demo, I have picked a standard AAA card in order to show how to scan objects from a card.
This is because we rely on knowledge about the structure of the card and how information is arranged on the card.
Different types of cards with different layout may not be recognized by this existing sample.

# Authors

* **Sourabh Ketkale** - *Initial work* - [sourabhketkale](https://github.com/sourabhketkale)
* **Alex Takahashi** - *Reviewer* - [alextakahashi](https://github.com/alextakahashi)

# Acknowledgments

* [README-Template](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [SwiftLint](https://github.com/realm/SwiftLint)

# License
Copyright (c) 2019 SAP SE or an SAP affiliate company. 
All rights reserved.

This project is licensed under the SAP Sample Code License except as noted otherwise in the [LICENSE](../LICENSE) file.
