# upsstats

## Overview

This docker image contains [NUT](https://networkupstools.org/).

## Example Configuration
This is an example dynamic configuration connecting to upsd as a slave.

```yaml
---
version: "3.9"

services:
  upsd:
    ...
    environment:
      UPSSTATS_HOSTS: |
        MONITOR ups0@myupsdhost "UPS0"
        MONITOR ups1@myupsdhost "UPS1"
    ...
```

## Entrypoint Scripts

### upsstats

The embedded entrypoint script is located at `/etc/entrypoint.d/upsstats` and performs the following actions:

1. A new upsstats configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | UPSSTATS_HOSTS | | The contents to be appended to `<nut_confpath>/hosts.conf`. |
 | UPSSTATS_USERS | admin | The list of users to be allowed access. This is not the same as the `userd.users` credentials used to access `upsset.cgi`. |

2. Volume permissions are normalized.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  └─ entrypoint.d/
│     ├─ nginx
│     └─ upsstats
├─ run/
│  └─ secrets/
│     └─ <user>_password
└─ usr/
   └─ share/
      └─ nut/
         └─ www/
```

### Exposed Ports

None.

### Volumes

* `/etc/nut` - The upsstats configuration directory.

## Development

[Source Control](https://github.com/crashvb/upsstats-docker)

