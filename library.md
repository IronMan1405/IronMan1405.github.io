---
layout: default
title: Library
permalink: /library/
---

<div class="library">
    <div class="library-toolbar">
        <div class="library-search">
            <span class="library-search-icon">⌕</span>
            <input
                type="search"
                id="library-search-input"
                placeholder="Search library..."
                autocomplete="off"
                aria-label="Search library"
            >
        </div>
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
           href="{{ book.file | relative_url }}"
           data-search="
                {{ book.title }}
                {{ book.author }}
                {{ book.translator }}
                {{ book.edition }}
                {{ book.publisher }}
                {{ book.year }}
            ">
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


<script>
    const searchInput = document.getElementById("library-search-input");
    const books = document.querySelectorAll(".library-file");
    const count = document.querySelector(".library-count");

    searchInput.addEventListener("input", function () {
        const query = this.value.toLowerCase().trim();
        let visible = 0;

        books.forEach(book => {
            const searchableText =
                book.dataset.search.toLowerCase();

            const matches = searchableText.includes(query);

            book.style.display = matches ? "grid" : "none";

            if (matches) {
                visible++;
            }
        });

        count.textContent =
            query
                ? `${visible} / ${books.length} items`
                : `${books.length} items`;
    });
</script>