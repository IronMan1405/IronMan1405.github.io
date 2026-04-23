---
layout: page
title: Blog
permalink: /blog/
---

## Blog

Posts and write-ups.

{% raw %}
{% for post in site.posts %}
- [{{ post.title }}]({{ post.url }}) — {{ post.date | date: "%b %d, %Y" }}
{% endfor %}
{% endraw %}
