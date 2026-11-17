# ToDo

## Explicit map location field for event/ride/volunteer posts

**Problem:** The sidebar map embeds (`_includes/_sidebar_event.html`,
`_sidebar_ride.html`, `_sidebar_volunteer.html`) only extract coordinates from
full Google Maps URLs containing `/@lat,lng` or `/search/`. Short
`maps.app.goo.gl` links fall back to geocoding the free-text `where:` field
(e.g. "27 1/4 road Motocross Track"), which Google resolves relative to the
*viewer's* location — so visitors outside Grand Junction can see a map of the
wrong place (e.g. Minnesota).

**Current workaround:** use the full `https://www.google.com/maps/place/.../@lat,lng,...`
URL in `directions:` instead of a short link.

**Longer-term fix:** add an optional front-matter field (e.g. `map:` under
`event:`/`ride:`/`volunteer:`) holding explicit coordinates or a full address.
The sidebars should use it first for the embed `q=` parameter, falling back to
the existing `directions`/`where` parsing. This lets posts keep tidy short
links for `directions:` without affecting the map preview.

- Update all three sidebar includes (ideally factor the shared map logic into
  one include).
- Document the new field in CLAUDE.md's front-matter examples.
- Backfill existing posts that use `maps.app.goo.gl` short links
  (`grep -l "maps.app.goo.gl" _posts/*/*`).
- Verify with a local production build since it touches includes.

## Move the site build from Ruby 3.1 to Ruby 3.3

**Problem:** Ruby 3.1 is end-of-life. The `ubuntu-latest` runners moved to
Ubuntu 26.04, and `ruby/ruby-builder` publishes 26.04 builds for 3.1.7 and
3.3.x but *not* 3.2.x, so 3.3 is the next supported step. Eventually 3.1 builds
will stop appearing for new runner images and the nightly rebuild will break
again.

**To do:**

- Change `ruby-version` in `.github/workflows/jekyll.yml` and
  `.github/workflows/pr-build-test.yml` from `'3.1'` to `'3.3'`.
- Update `.ruby-version` (currently `3.1.4`) to a 3.3.x release.
- Run `bundle update` as needed and commit the refreshed `Gemfile.lock`
  (check the pinned `asciidoctor ~> 1.5.4` and `coderay 1.1.1` still work).
- Verify with a local production build (`bundle exec jekyll build`) and the
  PR "Test Jekyll Build" check, then trigger the nightly workflow once via
  `workflow_dispatch` to confirm the deploy.
