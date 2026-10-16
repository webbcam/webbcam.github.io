---
layout: reading
title: Blog
permalink: /blog/
---
<p class="eyebrow">Writing</p>
<h1>Blog</h1>
<p class="lead">⚠️ Thoughts and words are my own and do not reflect those of my employer!</p>
{% for post in site.posts %}
<article class="post">
  <time>{{ post.date | date: "%b %-d, %Y" }}</time>
  <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
</article>
{% endfor %}
