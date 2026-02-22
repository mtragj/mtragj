---
description: Process open GitHub Issues labeled as content into Jekyll posts (events, rides, volunteers, news) and open a PR.
user_invocable: true
---

# Process Calendar Items

Process open GitHub Issues with the `content` label into Jekyll posts for the MTRA website. Each issue is created from a GitHub Issue Template and contains structured fields that map to Jekyll front matter.

## Steps

### 1. Fetch Open Content Issues

Run:
```bash
gh issue list --label content --state open --json number,title,labels,body
```

If there are no open content issues, inform the user and stop.

### 2. Determine Issue Type by Label

Each issue has a type label in addition to `content`:
- `event` → Event post (`_posts/events/`, layout: `event`)
- `ride` → Ride post (`_posts/rides/`, layout: `ride`)
- `volunteer` → Volunteer post (`_posts/volunteers/`, layout: `volunteer`)
- `news` → News post (`_posts/news/`, layout: `news_post`)

If an issue has `content` but none of the type labels above, skip it and warn the user.

### 3. Create a New Branch

Create a branch from `gh-pages`:
```bash
git checkout gh-pages
git pull origin gh-pages
git checkout -b content/process-calendar-items-YYYY-MM-DD
```
Use today's date in the branch name.

### 4. Parse Issue Bodies and Create Posts

The issue body uses `### Field Name` as headers with the value on the next non-empty line. Parse each field from the body text.

#### File Naming Convention

Post files follow: `YYYY-MM-DD-slugified-title.md`

- For issues with a `when` field, extract the date from it for the filename date
- For news posts (no `when` field), use today's date
- Slugify the title: lowercase, replace spaces with hyphens, remove special characters

#### Image Handling

The image field contains a GitHub-hosted image in markdown format like:
```
![Image](https://github.com/user-attachments/assets/UUID)
```

Download the image, save it to `/images/` with two sizes:
- Full size (1024x768): `slugified-title-1024x768.jpg`
- Thumbnail (300x225): `slugified-title-300x225.jpg`

Use ImageMagick (`convert` or `magick`) to resize. If ImageMagick is not available, warn the user and use a placeholder image name in the front matter. Check if a suitable fallback image exists in `/images/` if needed.

#### Front Matter Templates

**Event posts:**
```yaml
---
layout: event
sidebar: right
subheadline: "{subheadline}"
title: "{title}"
teaser: "{teaser}"
breadcrumb: true
tags:
    - event
categories:
    - events
show_meta: false
image:
    thumb: {slug}-300x225.jpg
    homepage: {slug}-1024x768.jpg
    title: {slug}-1024x768.jpg
event:
    when: {when}
    where: {where}
    what: {what}
    who: {who}
    directions: {directions}
---
{body_content}
```

**Ride posts:**
```yaml
---
layout: ride
sidebar: right
subheadline: "{subheadline}"
title: "{title}"
teaser: "{teaser}"
breadcrumb: true
tags:
    - ride
categories:
    - rides
show_meta: false
image:
    thumb: {slug}-300x225.jpg
    homepage: {slug}-1024x768.jpg
    title: {slug}-1024x768.jpg
ride:
    when: {when}
    where: {where}
    leader: {leader}
    difficulty: {difficulty}
    distance: {distance}
    pace: {pace}
    terrain: {terrain}
    directions: {directions}
---
{body_content}
```

**Volunteer posts:**
```yaml
---
layout: volunteer
sidebar: right
subheadline: "{subheadline}"
title: "{title}"
teaser: "{teaser}"
breadcrumb: true
tags:
    - volunteer
categories:
    - volunteers
show_meta: false
image:
    thumb: {slug}-300x225.jpg
    homepage: {slug}-1024x768.jpg
    title: {slug}-1024x768.jpg
volunteer:
    when: {when}
    where: {where}
    leader: {leader}
    work: {work}
    access: {access}
    bring: {bring}
    directions: {directions}
---
{body_content}
```

**News posts:**
```yaml
---
layout: news_post
sidebar: right
subheadline: "{subheadline}"
title: "{title}"
teaser: "{teaser}"
breadcrumb: true
tags:
    - news
categories:
    - news
show_meta: false
image:
    thumb: {slug}-300x225.jpg
    homepage: {slug}-1024x768.jpg
    title: {slug}-1024x768.jpg
---
{body_content}
```

### 5. Commit and Push

Stage all new files (posts and images), commit with a message listing which issues were processed:
```
Add posts from GitHub Issues #X, #Y, #Z

- Issue #X: {type} - {title}
- Issue #Y: {type} - {title}
```

Push the branch and create a PR:
```bash
git push -u origin content/process-calendar-items-YYYY-MM-DD
gh pr create --title "Add content posts from GitHub Issues" --body "$(cat <<'EOF'
## Summary
Processed open GitHub Issues with the `content` label into Jekyll posts.

### Posts Created
- [ ] Issue #X: {type} - {title}
- [ ] Issue #Y: {type} - {title}

### Checklist
- [ ] Review post content and front matter
- [ ] Verify images display correctly

### Closes
Closes #X, Closes #Y, Closes #Z

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### 6. Report Results

Summarize what was done:
- How many issues were processed
- Which posts were created (with filenames)
- The PR URL
- Any issues that were skipped and why

## Important Notes

- Issues are auto-closed by GitHub when the PR is merged via `Closes #X` keywords in the PR body
- If a post file already exists for an issue (matching title/date), warn the user and skip it
- Omit optional front matter fields that are empty (e.g., `directions` if not provided)
- Preserve the exact text from issue fields - do not reformat or rewrite content
- The `body_content` field becomes the post body below the front matter `---`
- If `body_content` is empty or says `_No response_`, use the teaser as the post body
