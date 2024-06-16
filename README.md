#Swift Thirty Two

An implementation of RC4648(https://datatracker.ietf.org/doc/html/rfc4648) encoding and decoding for Swift.



**Installation:**

In your Xcode project, select **File** → Add Package Dependencies and enter the URL of this repository.



**Supported platforms:**

It should work on all platforms that support Swift. However, the tests are done primarily on iOS, macOS and watchOS.



**Example**
```

import ThirtyTwo

func example() {
        let orgStr = "node"
        let orgData = orgStr.data(using: .utf8)!
        let encodedString = "NZXWIZI="
        let encodedData = encodedString.data(using: .utf8)!
        print("Encoded \(orgStr):", String(data: ThirtyTwo.thirtyTwoEncode(orgData), encoding: .utf8)!) // "NZXWIZI="
        print("Decoded \(encodedString):", String(data: ThirtyTwo.thirtyTwoDecode(encodedData)!, encoding: .utf8)!) // "node"
}

```
