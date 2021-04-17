.PHONY: start debug lint format

start:
	deno run --allow-net server.ts

debug:
	deno run --inspect --allow-net server.ts