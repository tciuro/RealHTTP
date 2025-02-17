<p align="center">
<img src="./Documentation/realhttp_logo.png" alt="RealHTTP" width="900"/>
</p>

# RealHTTP

RealHTTP is a lightweight yet powerful client-side HTTP library.  
Our goal is make an easy to use and effortless http client for Swift.

<p align="center">
<a href="http://labs.immobiliare.it"><img src="./Documentation/immobiliarelabs_logo.png"  alt="ImmobiliareLabs" width="150"/></a>
</p>

## Feature Highlights

- Sync/Async & Queued Requests
- Elegant Request Builder with Chainable Response
- Combine Support *(soon Async/Await!)*
- Retry/timeout, Validators Control
- URI Template support for parameter's build
- URL/JSON, Multipart Form/File Upload
- JSON decoding via Codable
- Upload/Download progress tracker
- URL Metrics Tracker
- cURL Description
- SSL Pinning, Basic/Digest Authentication
- TSL Certificate and Public Key Pinning
- Advanced HTTP Stub

## Simple HTTP Client

Making an async http request is easier than ever:

```swift
HTTPRequest<Joke>("https://official-joke-api.appspot.com/random_joke").run().onResult { joke in
    // decoded Joke object instance
}
```

In this case you are executing a request inside the shared `HTTPClient`, a shared client which manage your requests.  
Sometimes you may need to a more fined grained control.  
Therefore you can create a custom `HTTPClient` to execute all your's webservice network calls sharing a common configuration (headers, cookies, authentication etc.) using the `run(in:)` method.


```swift
let jokeAPIClient = HTTPClient(baseURL: "https://official-joke-api.appspot.com")
let jokesReq = HTTPRequest<Joke>(.get, "/random_jokes")
               .json(["category": category, "count": countJokes]) // json parameter encoding!

// Instead of callbacks we can also use Combine RX publishers.
jokesReq.resultPublisher(in: jokeAPIClient).sink { joke in
    // decoded Joke object
}

// Get only the raw server response
jokesReq.responsePublisher(in: ).sink { raw in
    // raw response (with metrics, raw data...)
}
```

You can use it with regular callbacks, combine publishers and soon with async/await's Tasks.

## Simple HTTP Stubber

RealHTTP also offer a built-in http stubber useful to mock your network calls for unit testing.  
This is a simple URI matching stub:

```swift
var stubLogin = HTTPStubRequest()
                .match(URI: "https://github.com/malcommac/{repository}")
                .stub(for: .post, delay: 5, json: mockLoginJSON))

HTTPStubber.shared.add(stub: stubLogin)
HTTPStubber.shared.enable()
```

HTTPStubber also support different matchers (regex matcher for url/body, URI template matcher, JSON matcher and more).  
This is an example to match Codable entity for a stub:

```swift
var stubLogin = HTTPStubRequest()
               .match(object: User(userID: 34, fullName: "Mark"))
               .stub(for: .post, delay: 5, json: mockLoginJSON)
```

## ... and more!

But there's lots more features you can use with RealHTTP.  
Check out the Documentation section below to learn more!

## Documentation

- [Introduction](./Documentation/Introduction.md#introduction)
- [Architecture Components](./Documentation/Introduction.md#architecture-components)
- [HTTP Client](./Documentation/HTTPClient.md)
    - [Introduction](./Documentation/HTTPClient.md#introduction)
    - [Create a new client](./Documentation/HTTPClient.md#create-a-new-client)
    - [Create a queue client](./Documentation/HTTPClient.md#create-a-queue-client)
    - [Client Delegate](./Documentation/HTTPClient.md#client-delegate)
    - [Response Validators](./Documentation/HTTPClient.md#response-validators)
        - [Default Response Validator](./Documentation/HTTPClient.md#default-response-validator)
        - [Alt Request Validator](./Documentation/HTTPClient.md#alt-request-validator)
    - [Client Configuration](./Documentation/HTTPClient.md#client-configuration)
    - [Security](./Documentation/HTTPClient.md#security)
        - [Configure security via SSL/TSL](./Documentation/HTTPClient.md#configure-security-ssltsl)
        - [Allows all certificates](./Documentation/HTTPClient.md#allows-all-certificates)
- [HTTP Request](./Documentation/HTTPRequest.md)
    - [Configure a Request](./Documentation/HTTPRequest.md#configure-a-request)
    - [Decodable Request](./Documentation/HTTPRequest.md#decodable-request)
    - [Chainable Configuration](./Documentation/HTTPRequest.md#chainable-configuration)
    - [Set Content](./Documentation/HTTPRequest.md#set-content)
        - [Set Headers](./Documentation/HTTPRequest.md#set-headers)
        - [Set Query Parameters](./Documentation/HTTPRequest.md#set-query-parameters)
        - [Set JSON Body](./Documentation/HTTPRequest.md#set-json-body)
        - [Set Form URL Encoded](./Documentation/HTTPRequest.md#set-form-url-encoded)
        - [Set Multipart Form](./Documentation/HTTPRequest.md#set-multipart-form)
    - [Modify an URLRequest](./Documentation/HTTPRequest.md#modify-an-urlrequest)
    - [Execute Request](./Documentation/HTTPRequest.md#execute-request)
    - [Cancel Request](./Documentation/HTTPRequest.md#cancel-request)
    - [Handle Request Redirects](./Documentation/HTTPRequest.md#handle-request-redirects)
    - [Response Handling](./Documentation/HTTPRequest.md#response-handling)
    - [Response Validation](./Documentation/HTTPRequest.md#response-validation)
    - [Upload Large Data](./Documentation/HTTPRequest.md#upload-large-data)
        - [Upload Multi-part form with stream of file](./Documentation/HTTPRequest.md#upload-multi-part-form-with-stream-of-file)
        - [Upload File Stream](./Documentation/HTTPRequest.md#upload-file-stream)
    - [Download Large Data](./Documentation/HTTPRequest.md#download-large-data)
    - [Track Upload/Download Progress](./Documentation/HTTPRequest.md#track-uploaddownload-progress)
- [Tools](./Documentation/Tools.md)
    - [Gathering/Showing Statistical Metrics](./Documentation/Tools.md#gatheringshowing-statistical-metrics)
    - [cURL Command Output](./Documentation/Tools.md#curl-command-output)
- [Network Stubber](./Documentation/Stub.md)
    - [Introduction](./Documentation/Stub.md#introduction)
    - [Stub a Request](./Documentation/Stub.md#stub-a-request)
    - [Stub Matchers](./Documentation/Stub.md#stub-matchers)
        - [Custom Matcher](./Documentation/Stub.md#customer-matcher)
        - [URI Matcher](./Documentation/Stub.md#uri-matcher)
        - [JSON Matcher](./Documentation/Stub.md#json-matcher)
        - [Body Matcher](./Documentation/Stub.md#body-matcher)
        - [URL Matcher](./Documentation/Stub.md#url-matcher)
    - [Add Ignore Rule](./Documentation/Stub.md#add-ignore-rule)
    - [Unhandled Rules](./Documentation/Stub.md#unhandled-rules)

## Requirements

RealHTTP can be installed in any platform which supports Swift 5.4+ ON:

- iOS 13+  
- Xcode 12.5+  
- Swift 5.4+  

## Installation

To use RealHTTP in your project you can use Swift Package Manager (our primary choice) or CocoaPods.

### Swift Package Manager

Aadd it as a dependency in a Swift Package, add it to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/immobiliare/RealHTTP.git", from: "1.0.0")
]
```

And add it as a dependency of your target:

```swift
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "https://github.com/immobiliare/RealHTTP.git", package: "RealHTTP")
    ])
]
```

In Xcode 11+ you can also navigate to the File menu and choose Swift Packages -> Add Package Dependency..., then enter the repository URL and version details.

### CocoaPods

RealHTTP can be installed with CocoaPods by adding pod 'RealHTTP' to your Podfile.

```ruby
pod 'RealHTTP'
```
<a name="#powered"/>

## Powered Apps

RealHTTP was created by the amazing mobile team at ImmobiliareLabs, the Tech dept at Immobiliare.it, the first real estate site in Italy.  
We are currently using RealHTTP in all of our products.

**If you are using RealHTTP in your app [drop us a message](mailto:mobile@immobiliare.it), we'll add below**.

<a href="https://apps.apple.com/us/app/immobiiiare-it-indomio/id335948517"><img src="./Documentation/immobiliare-app.png" alt="Indomio" width="270"/></a>

## Support & Contribute

Made with ❤️ by [ImmobiliareLabs](https://github.com/orgs/immobiliare) & [Contributors](https://github.com/immobiliare/RealHTTP/graphs/contributors)

We'd love for you to contribute to RealHTTP!  
If you have any questions on how to use RealHTTP, bugs and enhancement please feel free to reach out by opening a [GitHub Issue](https://github.com/immobiliare/RealHTTP/issues).

### Todo List

If you want to contribuite to the project you can also work on these main topics.

- [ ] Async/Await support for observers
- [ ] Extended the Combine support
- [ ] Complete the test suite

<a name="#license"/>

## License

RealHTTP is licensed under the MIT license.  
See the [LICENSE](./LICENSE) file for more information.
