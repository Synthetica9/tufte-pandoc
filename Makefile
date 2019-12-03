.PHONY: clean all FORCE SETUP DONE

BUILD_DIR=.build
BRAID_OUT_DIR=$(BUILD_DIR)/braided
MARKDOWN=$(wildcard md-src/*.md)
BRAIDED=$(patsubst md-src/%.md,$(BUILD_DIR)/braided/%.md,$(MARKDOWN))

all: SETUP $(BUILD_DIR)/out.pdf DONE

$(BUILD_DIR)/out.pdf: $(BUILD_DIR)/combined.md filters/after.lua
	pandoc --from markdown $< -o $@ \
		--lua-filter filters/after.lua \
		--pdf-engine xelatex

SETUP:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BRAID_OUT_DIR)

$(BUILD_DIR)/combined.md: $(BUILD_DIR)/header.yaml $(BRAIDED)
	ls $^ | sort | xargs cat > $@

$(BRAID_OUT_DIR)/%.md: md-src/%.md filters/before.lua
	codebraid pandoc $< -o $@ --overwrite \
		--lua-filter filters/before.lua \
		--cache-dir $(BUILD_DIR)/codebraid

	# Add an extra trailing newline, because otherwise pandoc could get confused
	echo >> $@

$(BUILD_DIR)/header.yaml: header.yaml
	touch $@
	echo "---" > $@
	cat $^ | yq . >> $@
	echo "---" >> $@
	echo >> $@

clean:
	-@rm -r $(BUILD_DIR)

DONE:
	@echo Done.
