# frozen_string_literal: true

# Generates individual pages for each post series at /series/{slug}/

module Jekyll
  class SeriesPageGenerator < Generator
    safe true

    def generate(site)
      series_map = {}

      site.posts.docs.each do |post|
        name = post.data['series']
        next unless name

        series_map[name] ||= []
        series_map[name] << post
      end

      series_map.each do |name, posts|
        site.pages << SeriesPage.new(site, name, posts.sort_by(&:date))
      end
    end
  end

  class SeriesPage < Page
    def initialize(site, series_name, posts)
      @site = site
      @base = site.source
      @dir  = "series/#{Utils.slugify(series_name)}"
      @name = 'index.html'

      process(@name)
      read_yaml(File.join(@base, '_layouts'), 'series-page.html')

      data['title']        = series_name
      data['series_posts'] = posts
    end
  end
end
