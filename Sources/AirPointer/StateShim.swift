import SwiftUI

/// SwiftUI's `@ViewState` is now a compiler macro whose plugin only ships with full
/// Xcode. This alias points at the underlying property wrapper so the app also
/// builds with just the Command Line Tools. Behaviour is identical.
typealias ViewState<Value> = SwiftUICore.State<Value>
