all:

.PHONY: image
image:
	docker build -t ghcr.io/daskol/typst-templates .

.PHONY: test
test:
	docker run --rm -ti \
		-e PREFIX=$(PWD)/build \
		-v $(PWD):$(PWD) \
		-w $(PWD) \
		ghcr.io/daskol/typst-templates \
		.github/scripts/render-templates.sh
