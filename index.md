# Dakshesh

I build robots because I refuse to do something manually twice.
Not your typical polymath ;)

---

## Projects

{% assign projects = site.projects | sort: "date" | reverse %}

{% for project in projects limit:3 %}
### [{{ project.title }}]({{ project.url }})
{{ project.date | date: "%b %Y" }}

{% endfor %}

---

## Writing

{% for post in site.posts limit:5 %}
### [{{ post.title }}]({{ post.url }})
{{ post.date | date: "%b %d, %Y" }}

{% endfor %}