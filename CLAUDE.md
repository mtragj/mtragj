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
- Site URL: `https://mtragj.github.io/mtragj`
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

## Git Workflow

- **Main branch**: `gh-pages` (used for GitHub Pages deployment and PRs)
- **Current branch**: Feature branches typically prefixed with `minor/` (e.g., `minor/biks_coffee_event`)
- Site automatically deploys from `gh-pages` branch

## Key Customizations

- Site credits: Acknowledges creation by Ben using Jekyll and Feeling Responsive theme
- Organization: MTRA is a nonprofit with volunteer board representing Western Slope dirt bikers
- Funding: Through annual membership fees, donations, and grants
