# Extra Caddy Sites

Add one `*.caddy` file per extra local stack you want to expose through the shared Caddy instance.

Example:

```caddyfile
api.localhost {
	reverse_proxy my-other-stack-api:8080
}
```

Notes:

- The target service must be reachable on the Docker network named by `LOCAL_DOCKER_NETWORK`.
- Use `*.localhost` hostnames to avoid editing the hosts file on a typical local machine.
- After adding or changing a site file, restart or recreate the `caddy` service.
