{
  flake.modules.homeManager.cli-crush = {
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
          api_key = "$(cat /run/agenix/jyeno-api)";
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
