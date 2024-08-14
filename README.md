# BookHive

Your personalised book library, Where every book finds Its Place 📚📖.

## Reviewer Notes:

### Architecture

The codebase follows the [Composable Architecture](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture) making use of the REDUX design pattern.
It utilises the `The Swift Composable Architecture` open sourced [library](https://github.com/pointfreeco/swift-composable-architecture) to efficiently manage state & actions for feature implementations and unit tests.

### Dependency Management

The codebase relies on a light weight external library called [RESOLVER](https://github.com/hmlongco/Resolver) to properly handle the registration & resolution of all dependencies using `DIP` with the help of protocols.

### Mocking Dependencies

Since dependecies are implemented using protocol oriented programming, the mocks for these dependencies are constructed manually in code. This approach for sure is not so efficient when compared to using an external frameworks for automatically generating mocks, but it does spares some time & space; in terms of complexity overhead which is associated while using external mocking libraries for generating mocks. Also it's more flexiable & straight forward to generate mocks manually. In the end it just boils down to personal chocies and coding practices 😌.

### Video

The video quality is not so optimal due to 10 MB file size limit in Github 🙄.

https://github.com/user-attachments/assets/a38c3038-073a-40bf-bc47-8a21ab00a03b

