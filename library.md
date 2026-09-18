---
layout: default
title: Library
permalink: /library/
---

<div class="library">
    <div class="library-toolbar">
        <div class="library-path">
            <span class="library-prompt">~/</span>library
        </div>
        <div class="library-count">
            {{ site.data.books | size }} items
        </div>
    </div>
    <div class="library-table">
        <div class="library-row library-header-row">
            <span></span>
            <span>Name</span>
            <span>Type</span>
        </div>
        {% for book in site.data.books %}
        <a class="library-row library-file"
           href="{{ book.file | relative_url }}">
            <!-- <span class="library-icon">▱</span> -->
            <span class="library-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <path d="M6 2.5H14L19 7.5V21.5H6V2.5Z"
                        stroke="currentColor"
                        stroke-width="1.5"
                        stroke-linejoin="round"/>
                    <path d="M14 2.5V7.5H19"
                        stroke="currentColor"
                        stroke-width="1.5"
                        stroke-linejoin="round"/>
                    <path d="M8.5 13H16.5M8.5 16H16.5"
                        stroke="currentColor"
                        stroke-width="1.5"
                        stroke-linecap="round"/>
                </svg>
            </span>
            <span class="library-name">
                <span class="library-title">
                    {{ book.title }}
                </span>
                <span class="library-meta">
                    {{ book.author }}
                    {% if book.edition %}
                    · {{ book.edition }}
                    {% endif %}
                </span>
            </span>
            <span class="library-size">
                {{ book.type }}
            </span>
        </a>
        {% endfor %}
    </div>
</div>
