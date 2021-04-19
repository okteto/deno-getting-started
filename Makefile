.PHONY: start debug lint format

start:
	deno run --allow-net app.ts

debug:
	deno run --inspect --allow-net app.ts