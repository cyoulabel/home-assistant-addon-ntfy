# Home Assistant Add-on: ntfy

Local Home Assistant add-on that runs a self-hosted [ntfy](https://ntfy.sh/) notification server from the official Docker image.

## Features

- Builds on `binwiederhier/ntfy:latest`
- Configurable `base-url` for reverse proxy / public HTTPS access
- Optional `upstream-base-url` for instant iOS push via ntfy.sh
- Persists cache and config on the Home Assistant `share` folder

## Installation

### Local folder (Home Assistant OS / Supervised)

Copy the `ntfy` directory to `/addons/local/ntfy`, then reload the add-on store and install **ntfy**.

### Add-on repository

1. **Settings → Apps → Add-on store → Repositories**
2. Add: `https://github.com/lonsdaleite/home-assistant-addon-ntfy`
3. Install **ntfy** from the store

## Configuration

| Option | Description |
|--------|-------------|
| `base_url` | Public URL of your ntfy server, e.g. `https://ntfy.example.com` |
| `upstream_base_url` | Optional. Set to `https://ntfy.sh` for iOS instant notifications |

Default host port mapping: container `80/tcp` → host `8080`.

## Send a test notification

```bash
curl -H "Title: Test" -d "Hello" "http://192.168.1.11:8080/my-topic"
```

## License

Apache-2.0 (ntfy server). Add-on wrapper scripts are provided as-is.
