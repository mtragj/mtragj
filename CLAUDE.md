# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the MTRA (Motorcycle Trail Riding Association) website - a Jekyll-based static site hosted on GitHub Pages. The site is built on the "Feeling Responsive" Jekyll theme and serves as the main web presence for the Western Slope dirt biking nonprofit organization.

## Build and Development Commands

### Local Development
```bash
# Serve the site locally with development config
bundle exec jekyll serve --config _config.yml,_config_dev.yml

# Build the site
bundle exec jekyll build

# Serve with future posts visible (useful for testing scheduled content)
bundle exec jekyll serve --future
```

### Dependencies
```bash
# Install Ruby dependencies
bundle install
```

## Site Architecture

### Configuration
- `_config.yml`: Main production configuration
- `_config_dev.yml`: Development overrides (merge with main config)
- Site URL: `https://mtragj.org` (custom apex domain via `CNAME`; served at root, so `baseurl` is empty)
- Images base URL is configured in `urlimg` variable

### Content Organization

The site uses Jekyll's category-based content system with custom layouts for different content types:

**Post Categories** (in `_posts/`):
- `events/`: MTRA meetings and events (uses `event` layout)
- `rides/`: Organized group rides (uses `ride` layout)
- `volunteers/`: Trail maintenance and volunteer opportunities (uses `volunteer` layout)
- `news/`: General announcements (uses `news_post` layout)
- `design/`: Theme demo posts (can ignore)

**Custom Layouts** (in `_layouts/`):
- `event.html`: For meetings/events with when/where/what/who fields
- `ride.html`: For group rides with leader/difficulty/distance/pace/terrain fields
- `volunteer.html`: For volunteer opportunities with work type/access/bring fields
- `frontpage.html`: Homepage with widget system and latest post display

**List Pages** (using includes):
- Events list uses `_includes/_events.html` (loops through `site.categories.events`)
- Rides list uses `_includes/_rides.html` (loops through `site.categories.rides`)
- Volunteers list uses `_includes/_volunteers.html` (loops through `site.categories.volunteers`)

### Front Matter Structure

**Events:**
```yaml
layout: event
subheadline: Meeting
title: "MTRA Summer Meeting"
teaser: "Brief description"
categories:
  - events
image:
  thumb: filename-300x225.jpg
  homepage: filename-1024x768.jpg
  title: filename-1024x768.jpg
event:
  when: 6pm July 31st, 2024
  where: Edgewater Brewery
  what: MTRA Meeting
  who: MTRA members, prospective members
  directions: https://maps.app.goo.gl/...
```

**Rides:**
```yaml
layout: ride
subheadline: Moto Meetup
title: "18 Road Ride"
teaser: "Ride description"
categories:
  - rides
ride:
  when: 10am May 25th, 2024
  where: 18 Rd OHV Parking Area
  leader: Dave Clapp
  difficulty: Intermediate
  distance: 30-40 Miles
  pace: Moderate
  terrain: Single-track, hills, gullies, varied
  directions: https://maps.app.goo.gl/...
```

**Volunteers:**
```yaml
layout: volunteer
subheadline: Volunteer Opportunity
title: "North Unc Trail Maintenance"
categories:
  - volunteers
volunteer:
  when: 9am Aug 10th, 2024
  where: Meeting location
  leader: Chris Vestal
  work: Building trail bridges
  access: Ride In
  bring: Hand saws, loppers, battery powered trimmer
  directions: https://maps.app.goo.gl/...
```

### Images

Images are stored in `/images/` and referenced via `{{ site.urlimg }}` in markdown:
```markdown
![Alt text]({{ site.urlimg }}filename.jpg)
```

Standard image sizes:
- Thumbnails: 300x225 or similar
- Homepage/full: 1024x768 or similar

### Navigation

Navigation is defined in `_data/navigation.yml` with support for:
- Left-side menu items (main navigation)
- Right-side menu items (contact, etc.)
- Dropdown menus (see Volunteer menu with "Log Hours" external link)

### Includes System

Two types of includes:
1. **Template includes** (prefixed with `_`): Used by layouts (e.g., `_head.html`, `_footer.html`)
2. **Content commands** (no prefix): Usable in posts/pages (e.g., `alert`, `gallery`)

## Changing the Date of an Existing Event/Ride/Volunteer Post

Post URLs are derived from the date in the filename (permalink is
`/:categories/:year/:month/:day/:title/`). If an event's date changes, simply
renaming the file moves the URL and **breaks any links already shared** (404s),
but leaving the old filename makes the post sort/display under the wrong date.

Do both cleanly with the theme's built-in `redirect` layout (no plugins, no
"ignore this file" hacks — a redirect stub is a *page*, not a post, so it never
appears in `site.categories.*` listings or the calendar):

1. **Rename the post file** to the new start date (e.g.
   `_posts/volunteers/2026-06-26-foo.md` → `2026-06-27-foo.md`) and update the
   `when:` field and body text to the new date(s). Use `git mv`.
2. **Create a redirect stub** at `pages/redirects/<slug>-<old-date>.md` pointing
   the old URL at the new one:
   ```yaml
   ---
   title: "<Title> (moved)"
   layout: redirect
   sitemap:
       exclude: true        # NOTE: the theme's sitemap include checks
                            # `sitemap.exclude`, NOT `sitemap: false`
   permalink: /volunteers/2026/06/26/foo/   # OLD url path (no baseurl)
   redirect_to: /volunteers/2026/06/27/foo/ # NEW url path (no baseurl)
   ---
   ```
   - `permalink` and `redirect_to` are root-relative paths **without** the
     baseurl. `_layouts/redirect.html` prepends `site.url` + `site.baseurl` to
     produce a full URL, matching how the rest of the site links to posts
     (`{{ site.url }}{{ site.baseurl }}{{ post.url }}`). The site is served at the
     apex domain root (`mtragj.org`) with an empty `baseurl`, so this yields a
     direct `https://mtragj.org/...` target. Absolute `http(s)://` URLs are
     passed through as-is.
   - Add one stub per old URL. If a post's date changes more than once, chain or
     repoint stubs so every previously-shared URL still resolves.
3. **Verify with a production build** (`bundle exec jekyll build --config _config.yml`):
   the old URL's `index.html` should `<meta refresh>` to the full
   `https://mtragj.org/.../` target (identical to how a listing links to the
   post — compare `_site/volunteer/index.html`). The new URL should appear in the
   volunteer/calendar/frontpage listings, and the old URL should appear in
   *neither* the listings nor `_site/sitemap.xml`. Optionally confirm the target
   resolves live with
   `curl -s -o /dev/null -w "%{http_code}\n" https://mtragj.org/...` (expect 200).

## Git Workflow

- **Main branch**: `gh-pages` (used for GitHub Pages deployment and PRs)
- **Current branch**: Feature branches typically prefixed with `minor/` (e.g., `minor/biks_coffee_event`)
- Site automatically deploys from `gh-pages` branch

## Key Customizations

- Site credits: Acknowledges creation by Ben using Jekyll and Feeling Responsive theme
- Organization: MTRA is a nonprofit with volunteer board representing Western Slope dirt bikers
- Funding: Through annual membership fees, donations, and grants
