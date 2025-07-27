# Welcome to HomeFleet 🚀 

This is my main stack that I run at home everyday. You'll see a wide range of container configurations.

My thought process behind creating these is for education, automation, efficiency, and conveniency. The best way to learn for me is by doing.

I have the containers grouped by category (core, media, monitoring).

```
services/
├── core
│   ├── frigate
│   ├── homeassistant
│   ├── portainer
│   └── zwave
├── monitoring
│   ├── dozzle
│   └── speedtest
└── utilities
    ├── bookstack
    ├── changedetection
    ├── duplicati
    ├── heimdall
    ├── mosquitto
    └── watchtower
```

## Automation

I use HomeAssistant (HA) for anything automation when it comes to my house (i.e. lights on/off when motion is/not detected). 

Add in Frigate (get a [Coral TPU](https://coral.ai/products/), trust me) to detect people, animals, or objects to the mix. Use the integration with HA and you'll get notified whenever someone is outside on your font porch or if a racoon is eating your garbage 😡.

Use the watchtower container to ensure you're running the latest release for all containers.

Duplicati for backing up my configurations to online storage on a schedule. 
> ⚠️ You don't want your configs to be in a Git repo.

## Efficiency + Convenience

Combining a `Makefile` with a properly structured repo is the best move I've made. It's incredibly convenient.

For example, if I want to restart all my core services. Instead of doing multiple `Docker compose down` calls I do a simple `Make restart core` and bam all my core containers restart!

## To-do List

- [ ] Add dashboard for metrics
    - [ ] Promethius
    - [ ] Grafana
- [ ] Add SSO
    - [ ] Traefik
    - [ ] Authentik