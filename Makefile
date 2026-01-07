all:

.PHONY: image
image:
	docker build -t ghcr.io/daskol/typst-templates .
