FROM okteto/deno:1.9 as build
WORKDIR /usr/src/app
COPY . . 
RUN deno compile --unstable --allow-net server.ts -p 8080

FROM debian:stable-slim
WORKDIR /app
EXPOSE 8080
COPY --from=build /usr/src/app/server /app/server
CMD [ "/app/server" ]