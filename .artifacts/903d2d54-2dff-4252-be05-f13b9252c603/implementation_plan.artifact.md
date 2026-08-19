# Refactor `WorldTime#getTime()` for Reduced Complexity

The `getTime()` function currently handles two distinct responsibilities: fetching time data and looking up country codes for flags. This leads to high cyclomatic complexity and poor maintainability.

## Proposed Changes

### [Component] Services

#### [MODIFY] [world_time.dart](file:///E:/UDIN/Code/code-desktop/flutter/world_time/lib/services/world_time.dart)
- Split `getTime()` into smaller, focused methods:
    - `_fetchTimeData()`: Handles the HTTP request and parsing for time.
    - `_fetchCountryCode()`: Handles the flag CDN lookup and country code matching.
- Update `getTime()` to act as an orchestrator for these methods.
- Improve error handling and logging consistency.

## Verification Plan

### Manual Verification
- Verify that the app still loads time correctly on the Loading screen.
- Verify that flags in the `ChooseLocation` screen still resolve via `countryCode` if available.
- Check debug logs to ensure both time and country code lookups are functioning.
