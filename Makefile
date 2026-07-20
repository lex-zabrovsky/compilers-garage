VERSION=$(shell jq -r .version package.json)
DATE=$(shell date +%F)
POSTS=$(wildcard demo/_posts/*.md)

# Build all pages
all: index.html blog-index.html $(patsubst demo/_posts/%.md,%.html,$(wildcard demo/_posts/*.md))

# Home page
# Depends on all posts so a new/edited post regenerates the "Latest Posts" list.
index.html: demo/index.md demo/template.html $(POSTS) scripts/generate-index.sh
	bash scripts/generate-index.sh
	pandoc --toc -s --css src/reset.css --css src/index.css \
		-Vversion=v$(VERSION) -Vdate=$(DATE) -i $< -o $@ \
		--template=demo/template.html

# Blog index
# Depends on all posts so the full archive stays in sync with the posts dir.
blog-index.html: demo/blog-index.md demo/template.html $(POSTS) scripts/generate-index.sh
	bash scripts/generate-index.sh
	pandoc -s --css src/reset.css --css src/index.css \
		-Vversion=v$(VERSION) -Vdate=$(DATE) -i $< -o $@ \
		--template=demo/template.html

# Individual blog posts
%.html: demo/_posts/%.md demo/template.html
	pandoc -s --css src/reset.css --css src/index.css \
		-Vversion=v$(VERSION) -Vdate=$(DATE) -i $< -o $@ \
		--template=demo/template.html

clean:
	rm -f *.html

.PHONY: all clean