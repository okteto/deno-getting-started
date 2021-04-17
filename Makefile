.PHONY: start
start:
	deno run --allow-net server.ts

.PHONY: debug
debug:
	deno run --inspect --allow-net server.ts 