ignitionx
=========

Jump-start your nginx configuration. **ignitionx** is a quick generator for nginx configuration sections, simplifying the process of setting up multiple applications on a single machine.

## Configuration Types

### Reverse Proxy

`ignitionx proxy <name> <port> [options...]`

Configure a reverse proxy by defining a named `upstream` directive at the supplied port.

**Example:** `ignitionx proxy balancer 4999` generates the following:

```
upstream balancer {
    server 127.0.0.1:4999;
}
server {
    listen 80;
    server_name balancer.dev;

    location / {
        proxy_pass http://balancer;
        proxy_set_header Host $host;
    }
}
```

### Static

`ignitionx static <name> <root> [options...]`

Configure a static site serving files from the supplied root directory.

**Example:** `ignitionx static blog /var/www/blog` generates the following:


```
server {
    listen 80;
    server_name blog.dev;

    location / {
        root /var/www/blog;
    }
}
```

---

## Usage

```
ignitionx <type> <params...> [options...]

Types:
  proxy       NGINX reverse proxy at port <port>
  static      Static directory at <basedir>
  
Options:
  -o          Output to /etc/nginx/ignitionx/<name>.dev.conf
  -o <file>   Output to <file>
  -v          Verbose output
```