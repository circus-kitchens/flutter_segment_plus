# Why are Git submodules here?

[Segment Swift SDK](https://segment.com/docs/connections/sources/catalog/libraries/mobile/swift-ios/) is not, and [won't be](https://github.com/segmentio/analytics-swift/issues/166#issuecomment-1295304917), distributed via CocoaPods, which is the only iOS/macOS dependency system Flutter supports to date. Segment Swift SDK opted for SPM, for which Flutter support [is worked on, but not ready yet](https://github.com/flutter/flutter/issues/33850).

To combat this, we opted for a manual creation of local pods sourced from the public Segment Swift SDK repositories via git submodules.

## Usage

// TODO: how to pull submodules
