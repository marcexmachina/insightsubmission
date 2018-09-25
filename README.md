# insightsubmission

A simple Flickr browser. Built using the MVVM architecture and SwiftBond to perform the binding between the ViewModel and View layers.

## Getting Started

* Clone the repository to your environment. 
* Open the file insightsubmission.xcworkspace. 
* Select simulator or device in Xcode and press the run button.

### Prerequisites

Xcode is required.

### Functionality

On initial launch of the app you will be presented with a prompt to allow location services. 
On selecting allow, the main screen will be presented showing images related to your current location.
There is a search bar at the top of the screen, which will start searching Flickr for images related to the search text, once 
the text is > 3 characters
On selecting an image, you will be taken to the detail screen, showing a larger version of the image, some metadata and 
the tags associated with the image. 

Tags are clickable, and doing so will take you back to the main screen while performing a search for images that have the same tag
as the selected tag.

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Built With

* [SwiftBond](https://github.com/DeclarativeHub/Bond) - A Swift binding framework.
