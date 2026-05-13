## Test environments

* local: macOS 26.3.1 (aarch64-apple-darwin20), R 4.5.0
* [github-actions][gh_act]:
    * windows-latest
    * macOS-latest
    * ubuntu-22.04 (release)
    * ubuntu-22.04 (devel)
* win-builder: windows-x86_64-devel

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a major release (1.0.0) with breaking changes documented in NEWS.md.

## Notes for reviewer

This is a data package with no novel statistical methods; there are no
published references describing the methods. Data sources are documented
in the `@source` field of each dataset's help page.

<!-- links: start -->
[gh_act]: https://github.com/k5cents/usa/actions
<!-- links: end -->
