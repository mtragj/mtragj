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
