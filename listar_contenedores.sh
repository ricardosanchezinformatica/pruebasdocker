docker ps -q | xargs -n 1 docker inspect --format='{{.Config.Hostname}} {{.HostConfig.NetworkMode}} {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

