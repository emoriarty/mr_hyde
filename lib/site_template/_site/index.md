---
layout: page
title: Home
permalink: /
id: home
---

Welcome to your first Mr. Hyde site. This page is a sample created by default when you make a new Mr. Hyde site, you can use it as a scaffold for your site or create a blank one (look options). You can find this file in `root-folder/site/index.html` but if you like to modify this file then open `root-folder/_site/index.md`. 
Below you can see a list of sample subsites, click on them to know more about subsites. 
All sites are created using [Jekyll](http://jekyllrb.com) including the main site. You can read more about Mr. Hyde usage documentation at [Mr. Hyde wiki](https://github.com/emoriarty/mr_hyde/wiki).

You can find the source code for the Mr. Hyde at: <a href="https://github.com/emoriarty/mr_hyde/">https://github.com/emoriarty/mr_hyde</a>.

{% if site.sites %}
## Sites
{% for subsite in site.sites %}
* [{{ subsite.name }}]({{ subsite.baseurl}})
{% endfor %}
{% endif %}
