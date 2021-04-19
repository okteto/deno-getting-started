FROM okteto/deno:1.9 as build
WORKDIR /usr/src/app
COPY . . 
RUN deno compile --unstable --allow-net app.ts -p 8080

FROM debian:stable-slim
WORKDIR /app
EXPOSE 8080
COPY --from=build /usr/src/app/server /app/app
CMD [ "/app/app" ]