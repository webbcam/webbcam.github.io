# webbcam.github.io

Cameron Webb's personal blog — built with [Jekyll](https://jekyllrb.com/) using the [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) theme and deployed via GitHub Pages.

## Development

```sh
bundle install   # Ruby/Jekyll gems
npm install      # Node.js packages

bash tools/run.sh          # Serve locally with live reload
bash tools/run.sh --production  # Serve in production mode
bash tools/test.sh         # Build and run HTML proofer
```

JavaScript (only needed when modifying `_javascript/`):

```sh
npm run watch:js   # Watch and rebuild during development
npm run build:js   # Production build
```

## Creating a Post

```sh
bash tools/new-post.sh "Post Title" [-c "Cat1,Cat2"] [-t "tag1,tag2"] [-s "Series Name"]
```

Creates `_posts/YYYY-MM-DD-post-title.md` with today's date and front matter pre-filled.

## License

Posts and content are copyright Cameron Webb. The Chirpy theme is published under the [MIT License](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/LICENSE).
