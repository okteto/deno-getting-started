/**
 * webserver.ts
 */
 import { serve } from "https://deno.land/std@0.93.0/http/server.ts";

 const server = serve({ hostname: "0.0.0.0", port: 8080 });
 console.log(`HTTP webserver running.  Access it at:  http://localhost:8080/`);
 
 for await (const request of server) {
   let bodyContent = "hello deno-world!";
   request.respond({ status: 200, body: bodyContent });
 }