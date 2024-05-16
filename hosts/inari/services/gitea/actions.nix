{config, ...}: {
  sops.secrets.gitea-actions-runner = {};

  services.gitea-actions-runner.instances.runner_1 = {
    enable = true;
    name = "runner_1";
    url = "https://git.iatze.cc";
    tokenFile = config.sops.secrets.gitea-actions-runner.path;
    labels = [
      "ubuntu-latest"
      "ubuntu-22.04"
      "ubuntu-20.04"
    ];
    settings = {
      log.level = "info";
      cache = {
        enabled = true;
      };

      runner = {
        # Execute how many tasks concurrently at the same time.
        capacity = 2;
        # Extra environment variables to run jobs.
        envs = {};
        # The timeout for a job to be finished.
        # Please note that the Gitea instance also has a timeout (3h by default) for the job.
        # So the job could be stopped by the Gitea instance if it's timeout is shorter than this.
        timeout = "3h";
      };

      container = {
        # Specifies the network to which the container will connect.
        # Could be host, bridge or the name of a custom network.
        # If it's empty, act_runner will create a network automatically.
        network = "bridge";

        # Whether to use privileged mode or not when launching task containers (privileged mode is required for Docker-in-Docker).
        privileged = false;

        # overrides the docker client host with the specified one.
        # If it's empty, act_runner will find an available docker host automatically.
        # If it's "-", act_runner will find an available docker host automatically, but the docker
        # host won't be mounted to the job containers and service containers.
        # If it's not empty or "-", the specified docker host will be used. An error will be returned if it doesn't work.
        docker_host = "";
      };
    };
  };
}
