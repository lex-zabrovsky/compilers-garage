VERSION=$(shell jq -r .version package.json)
DATE=$(shell date +%F)

# Build all pages
all: index.html blog-index.html $(patsubst demo/_posts/%.md,%.html,$(wildcard demo/_posts/*.md))

# Home page
index.html: demo/index.md demo/template.html
	pandoc --toc -s --css src/reset.css --css src/index.css \
		-Vversion=v$(VERSION) -Vdate=$(DATE) -i $< -o $@ \
		--template=demo/template.html

# Blog index
blog-index.html: demo/blog-index.md demo/template.html
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