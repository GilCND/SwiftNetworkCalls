# SwiftNetworkCalls

Network calls are used when we need to download something from the server to use it on the application.

When working with data from REST API we are going to have something called: 
JSON ( JavaScript Object Notation )

Example of a simple JSON:
{     username: “GilSouza”,
    bio: “Swift Developer creating this tutorial”,
    avatarIUrl: “https://avatars.githubusercontent.com/u/69941457?v=4”
} 

We can also have arrays on JSON files [ ]. 
Each array will have its format and content and will require to be decoded by a specific model. 

## Models

Models are structs or classes that represent the structure of your JSON data. It defines properties that map to the keys in the JSON, allowing Swift’s ‘JSONDecoder’ to parse the JSON into an instance of that model, making it easier to work with structured data in your code. 

## Basic network call cycle

Download JSON —-> Convert JSON into Model  —-> Use Models to build the UI

## Steps to build a basic network call

Build Dummy UI
Create Model
Write Networking Code
Connect it
