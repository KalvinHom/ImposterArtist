build-server:
	cd server; \
	mix deps.get --only prod; \
	MIX_ENV=prod mix compile; \
	MIX_ENV=prod mix release --overwrite;

build-client:
	cd client/imposter_artist; \
	yarn; \
	yarn build;
