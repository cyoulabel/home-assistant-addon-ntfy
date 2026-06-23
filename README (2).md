# Home Assistant Add-on: ntfy (Hardened Fork)

Local Home Assistant add-on that runs a self-hosted [ntfy](https://ntfy.sh/) notification server from the official Docker image.

This is a hardened fork of [lonsdaleite/home-assistant-addon-ntfy](https://github.com/lonsdaleite/home-assistant-addon-ntfy) with authentication enforcement, role-based access control, and Cloudflare Tunnel support.

## Changes from upstream

- **Authentication hardened** — anonymous access disabled by default; all clients must authenticate
- **Role-based access control** — separate admin, read-write, and read-only user tiers
- **Cloudflare Tunnel support** — expose your ntfy server publicly without opening ports

## Features

- Builds on `binwiederhier/ntfy:latest`
- Configurable `base-url` for reverse proxy / public HTTPS access
- Optional `upstream-base-url` for instant iOS push via ntfy.sh
- Persists cache and config on the Home Assistant `share` folder

## Installation

### Add-on repository

1. **Settings → Apps → Add-on store → Repositories**
2. Add: `https://github.com/cyoulabel/home-assistant-addon-ntfy`
3. Install **ntfy** from the store

### Local folder (Home Assistant OS / Supervised)

Copy the `ntfy` directory to `/addons/local/ntfy`, then reload the add-on store and install **ntfy**.

## Configuration

| Option | Description |
|--------|-------------|
| `base_url` | Public URL of your ntfy server, e.g. `https://ntfy.yourdomain.com` |
| `upstream_base_url` | Optional. Set to `https://ntfy.sh` for iOS instant notifications |

Default host port mapping: container `80/tcp` → host `8080`.

## User management

ntfy user management is done via the CLI inside the add-on container. Access it through the **Terminal** tab of the add-on or via SSH:

```bash
# Create an admin user
ntfy user add --role=admin your_admin_user

# Create a read-write user (can publish and subscribe)
ntfy user add your_readwrite_user

# Create a read-only user (can only subscribe)
ntfy user add your_readonly_user
```

Set passwords interactively when prompted, or pipe them in:

```bash
echo "your_password" | ntfy user add --role=admin your_admin_user
```

### Access control

Grant topic-level permissions per user:

```bash
# Allow read-write user to publish and subscribe to a topic
ntfy access your_readwrite_user your-topic rw

# Allow read-only user to subscribe only
ntfy access your_readonly_user your-topic ro

# Deny anonymous access to all topics (recommended)
ntfy access everyone "*" deny-all
```

### List users and permissions

```bash
# List all users
ntfy user list

# List all access control entries
ntfy access
```

### Change or remove a user

```bash
# Change password
ntfy user change-pass your_user

# Remove a user
ntfy user del your_user
```

## Send a test notification

```bash
# Authenticated request
curl \
  -u "your_user:your_password" \
  -H "Title: Test" \
  -d "Hello from ntfy" \
  "http://192.168.1.x:8080/your-topic"
```

## Cloudflare Tunnel

To expose ntfy publicly without opening firewall ports:

1. Install the **Cloudflare Tunnel** add-on in Home Assistant
2. Create a tunnel in the [Cloudflare Zero Trust dashboard](https://one.dash.cloudflare.com)
3. Point the tunnel to `http://localhost:8080`
4. Set `base_url` in this add-on to your Cloudflare public hostname

This allows subscribers outside your network to receive notifications without exposing your home IP.

## License

Apache-2.0 (ntfy server). Add-on wrapper scripts are provided as-is.
