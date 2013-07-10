CitySDK iOS Client is a client for the CitySDK API for iOS.

This client should have the same functionalities as the Javascript viewer at this address: http://dev.citysdk.waag.org/map

The client is at an early stage, but here is what is currently available:
* A CSDKHTTPClient that is subclass of AFHTTPClient for handling requests
* Some model class obtained by auto-generating files using JSON Accelerator(http://www.nerdery.com/json-accelerator), and then making changes where needed
* Some layers have their model well defined (ArtsHolland, OSM), although CitySDK Api has not a proper structure
defined for the `data` key of the `osm` layer, as it varies depending on the query (the keys in `data` of the "highways" 
query are different from those when querying the Museums).
* Parsing of the results and displaying on a native map as overlays
* Self-centering of the map
* An example project that deals with querying

Upcoming features
-------
* Managing GeometryCollections
* Adding annotations to the map (thus making the results selectable)
