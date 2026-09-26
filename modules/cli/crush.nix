{ inputs, ... }: {
  flake.modules.homeManager.cli-crush = { config, ... }: {
    imports = [
      inputs.self.modules.homeManager.secrets
    ];
    programs.crush = {
      enable = true;
      settings = {
        models.large = {
          model = "glm-5.2";
          provider = "zai";
        };
        providers.zai = {
          # type = "";
          # base_url = "";
          api_key = "$(cat ${config.age.secrets.jyeno-api.path})";
          models = [
            {
              id = "glm-5.2";
              name = "GLM 5.2";
            }
          ];
        };
      };
      skills = { };
    };
  };
}
