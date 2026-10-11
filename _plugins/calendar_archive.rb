# Generates /calendar/<year>/ archive pages for every year before the current
# one that has event, ride, or volunteer posts, and exposes the year list to
# Liquid as site.calendar_archive_years (newest first).
#
# "Current year" is the build date's year; the nightly rebuild rolls the
# calendar over to the new year and moves last year's entries into the archive.
module MTRA
  CALENDAR_CATEGORIES = %w[events rides volunteers].freeze

  class CalendarArchivePage < Jekyll::PageWithoutAFile
    def initialize(site, year)
      super(site, site.source, File.join('calendar', year.to_s), 'index.html')
      self.content = ''
      self.data = {
        'layout' => 'calendar',
        'title' => "#{year} Calendar Archive",
        'teaser' => "Events, rides, and volunteer opportunities from #{year}",
        'header' => { 'image_fullwidth' => 'singletrack_plains_header.png' },
        'breadcrumb' => true,
        'archive_year' => year
      }
    end
  end

  class CalendarArchiveGenerator < Jekyll::Generator
    safe true

    def generate(site)
      current_year = Time.now.year
      years = site.posts.docs
                  .select { |post| (post.data['categories'] & CALENDAR_CATEGORIES).any? }
                  .map { |post| post.date.year }
                  .uniq
                  .select { |year| year < current_year }
                  .sort
                  .reverse

      site.config['calendar_archive_years'] = years
      years.each { |year| site.pages << CalendarArchivePage.new(site, year) }
    end
  end
end
