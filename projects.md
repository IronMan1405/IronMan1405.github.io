---
layout: default
title: Projects
permalink: /projects/
---

## My Projects

This is where I document the systems I build.

{% assign raw_projects = site.projects %}

{% if raw_projects %}
    {% assign projects = raw_projects | sort: "date" | reverse %}
{% else %}
    {% assign projects = "" | split: "" %}
{% endif %}

{% if projects.size > 0 %}
{% for project in projects limit:3 %}
### [{{ project.title }}]({{ project.url }})
{{ project.date | date: "%b %Y" }}
{% endfor %}
{% else %}
*No projects yet. Coming soon.*
{% endif %}