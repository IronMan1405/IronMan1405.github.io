# Dakshesh

I build robots because I refuse to do something manually twice.
Not your typical polymath ;)

---
{% assign raw_projects = site.projects %}

{% if raw_projects %}
  {% assign projects = raw_projects | sort: "date" | reverse %}
{% else %}
  {% assign projects = "" | split: "" %}
{% endif %}

## Projects

{% for project in projects limit:3 %}
### [{{ project.title }}]({{ project.url }})
{{ project.date | date: "%b %Y" }}

{% endfor %}
{% else %}
_No projects yet. Coming soon._
{% endif %}

---

## Writing

{% for post in site.posts limit:5 %}
### [{{ post.title }}]({{ post.url }})
{{ post.date | date: "%b %d, %Y" }}

{% endfor %}