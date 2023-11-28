# Getting Started with Okteto and Deno

This example shows how to use [Okteto](https://github.com/okteto/okteto) to develop a cloud-native app with [Deno](https://deno.land) and Kubernetes manifests.
 
## Step 1: Deploy a Simple Deno Application to Kubernetes

We are using a straightforward Deno app in this example. Before you start running your application locally, let's confirm that you can deploy it to Kubernetes. The repository comes with a manifest you can use to deploy the app to Kubernetes. Any Kubernetes cluster works; it doesn't matter if you're using a local cluster or a remote one running a cloud provider. However, if you don't have a Kubernetes cluster, you can give [Okteto Cloud](https://okteto.com/) a try

Deploy your application to Kubernetes running the following command

```console
$ kubectl apply -f k8s.yml
```

You can confirm that the application is running by getting the pod's status, which for now is enough.

## Step 2: Install the Okteto CLI Locally

To get started, you need to install the Okteto CLI on your local workstation, where you type your Deno code.

The [Okteto CLI](https://github.com/okteto/okteto) is an open-source project that accelerates the development of cloud-native apps. You write your code locally, and the  Okteto CLI detects the changes and instantly updates your Kubernetes applications.

If you're using Mac or Linux, run the following command to install the Okteto CLI:

```console
$ curl https://get.okteto.com -sSfL | sh
```

If you're using Windows, you need to [download the executable](https://downloads.okteto.com/cli/okteto.exe) and [include its location in your $PATH variable](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/). Or, you can also use [the Linux subsystem](https://docs.microsoft.com/en-us/windows/wsl/install-win10) and run the command from above.

To confirm that the Okteto CLI works on your machine, run the following command:

```console
okteto version
```

## Step 4: The Okteto Manifest

Okteto looks for a particular file called `okteto.yml` to define the development environment for an application.

This sample already contains an `okteto.yml` that looks like this:
```yaml
name: hello-world
autocreate: true
image: okteto/deno:1.9
command: bash
volumes:
  - /deno-dir/
sync:
  - .:/usr/src/app
forward:
  - 8080:8080
  - 9229:9229
```

Without explaining every line of the above manifest, let's highlight and explain a few of them:

- `name`: the name of the Kubernetes deployment you want to put on "development mode."
- `image`: the image used by the development container, with all the tools you need to build a deno app.
- `command`: the start command of the development container.
- `forward`: a list of ports to forward from your local machine to your development container.

You can get more details about the Okteto manifest at our [official documentation site](https://okteto.com/docs/reference/manifest/index.html).

## Step 5: Activate Your Development Container

Run the following command to enter Okteto's development mode:

```console
$ okteto up
```

You should see something like this:

```
✓  Development container activated
✓  Files synchronized
   Namespace: default
   Name:      hello-world
   Forward:   8080 -> 8080
              9229 -> 9229
Welcome to your development container. Happy coding!
default:hello-world app>
```

This becomes your new terminal to run your Deno application every time you change its code. All the commands you run in this terminal are running in Kubernetes. Okteto opens a terminal in a container that has all the tooling you need for developing in Deno. To give it a try, run the following command:

```console
$ deno run --allow-net app.ts
```

You should see an output like the following where you can see how the app is compiling and launching the webserver:

```
HTTP webserver running.  Access it at:  http://localhost:8080/
```

To confirm that the app works, launch a new terminal, and run the following command:

```console
$ curl localhost:8080
```

```
hello deno-world!
```

Did you notice that your application is available in port 8080? This is because the Okteto CLI automatically forwarding port 8080 to your remote development container. 

## Step 6: See Application Changes in Kubernetes

Don't close the Okteto terminal, and let's change something in the Deno sample app.

For instance, head over to the server.rs file, and in line #10 change the response text, like this:

```deno
for await (const request of server) {
   let bodyContent = "hello okteto-world!";
   request.respond({ status: 200, body: bodyContent });
 }
```

Go back to the Okteto terminal, cancel the command (Ctrl + C) and rerun the deno command (as you would typically do if you were testing your application locally):

```console
$ deno run --allow-net app.ts
```

Go back to the other terminal where you're testing your application, and rerun the curl command:

```console
$ curl localhost:8080
```

```
hello okteto-world!
```

See? You didn't need any additional steps to see the changes reflected in Kubernetes!

## Step 7: Remote Debugging

Okteto enables you to debug your applications directly from your favorite IDE. Let's look at how that works in VS Code, one of the most popular IDEs for Deno development. The Deno debugger is not yet available, but luckily, the Node one works just fine. If you haven't done it yet, install the Node extension available from Visual Studio marketplace.

Go back to the Okteto terminal, cancel the command (Ctrl + C) and run the following deno command:

```console
$ deno run --inspect --allow-net app.ts
```

```
Debugger listening on ws://127.0.0.1:9229/ws/b533aca6-8066-4055-9458-803d8d6fd78f
HTTP webserver running.  Access it at:  http://localhost:8080/
```

Open the **Debug extension** and run the **Remote Debugging** debug configuration (or press the F5 shortcut):

```json
{
  "version": "0.2.0",
  "configurations": [
      {
          "name": "Remote Debugger",
          "type": "node",
          "request": "attach",
          "address": "localhost",
          "port": 9229,
          "localRoot": "${workspaceFolder}",
          "remoteRoot": "/usr/src/app",
          "skipFiles": [
              "<node_internals>/**"
          ]
      },
  ]
}
```

Add a breakpoint on `app.ts`, line 10. Go back to the local terminal, and call the application again. This time, the execution will halt at your breakpoint. You can then inspect the request, the available variables, etc.

Your deno code runs in Kubernetes, but you can debug it from your local machine without any extra services or tools. Pretty cool, no? 😉
