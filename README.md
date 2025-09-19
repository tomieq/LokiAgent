# Setup scheduled log upload

```swift
import Combine
import LogiAgent

Task {
    let publisher = Timer.publish(every: 10, on: .main, in: .default)
        .autoconnect()
    for await _ in publisher.values {
        try? await lokiAgent.upload()
    }
}
```
