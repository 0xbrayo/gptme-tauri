build: prebuild
	@# i need the nO_STRIP=true for some reason, otherwise:
	@# > Error failed to bundle project: `failed to run linuxdeploy`"
	NO_STRIP=true npm run tauri build

dev: prebuild
	npm run tauri dev

%/.git:
	git submodule update --init --recursive

src-tauri/icons/icon.png:
	npm run tauri icon "./public/logo.png"

gptme-webui/dist: gptme-webui/.git
	# TODO: probably a better way to do this
	npm i && cd gptme-webui && npm i && npm run build

gptme-server-build:
	# appends a platform-specific suffix, required by tauri
	mkdir -p bins
	cd gptme && make build-server-exe && mv dist/gptme-server ../bins/gptme-server-$$(rustc -Vv | grep host | cut -f2 -d' ')

prebuild: gptme-webui/dist src-tauri/icons/icon.png gptme-server-build

precommit: format check

format:
	cd src-tauri && cargo fmt

check:
	cd src-tauri && cargo check && cargo clippy
