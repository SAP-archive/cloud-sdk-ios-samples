# AAACardScanApp
This repository hosts an iOS application AAACardScanApp built using SAP Cloud Platform SDK for iOS.  I use the `SAPFiori` and `SAPML` frameworks to show the OCR scanner capabilities. This is a simple app to scan different objects from a AAA classic card.

## Getting Started

1. Download the [SAP Cloud Platform SDK for iOS](https://developers.sap.com/topics/cloud-platform-sdk-for-ios.html#details) to get necessary frameworks locally.

2. Clone the repository.

3. Add the `SAPFiori.framework`, `SAPCommon.framework`, `SAPML.framework`, and SAPML-Dependencies `GoogleMobileVision.framework`, `GoogleToolboxForMac.framework`, `GTMSessionFetcherIOS.framework`, and `Protobuf.framework` to the `Embedded Binaries` and `Linked Frameworks and Libraries`.

4. Build and Run 📸

5. Walkthrough the code implementation [blogpost](AAACardScanApp.md)

### Prerequisites

* Xcode 10.0+
* SAPFiori
* SAPCommon
* SAPML
* SAPML-Dependencies
  * GoogleMobileVision.framework
  * GoogleToolboxForMac.framework
  * GTMSessionFetcherIOS.framework
  * Protobuf.framework

## API References

* [SAPFiori Reference](https://help.sap.com/doc/978e4f6c968c4cc5a30f9d324aa4b1d7/Latest/en-US/Documents/Frameworks/SAPFiori/index.html)

## Authors

* **Sourabh Ketkale** - *Initial work* - [sourabhketkale](https://github.com/sourabhketkale)
* **Alex Takahashi** - *Reviewer* - [alextakahashi](https://github.com/alextakahashi)

## Acknowledgments

* [README-Template](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [SwiftLint](https://github.com/realm/SwiftLint)

## Disclaimer

<!--  Let's give a more technical description why this would not work for other card formats.  It's because we are doing some pattern matching I believe? -->

This app might not be able to scan all the AAA card formats and would only work with card images provided in the `AAACardScanAppImages` folder. As part of the demo, I have picked a standard AAA card in order to show how to scan objects from a card.
