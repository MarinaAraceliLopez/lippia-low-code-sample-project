@clockify @Errors
Feature: Pruebas de manejo de errores en Clockify

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = "application/json"
    And header Accept = "application/json"

  @UnauthorizedAccess
  Scenario: Acceso no autorizado con API key inválida (401)
    And header X-Api-Key = "invalid_api_key"
    And endpoint /workspaces/$(env.workspace_id)/projects
    When execute method GET
    Then the status code should be 401
    * print response

  @get404NotFound
  Scenario: Intentar acceder a un endpoint mal escrito (404)
    Given call Workspaces.feature@getAllWorkspaces
    And endpoint /workspaces/$(env.workspace_id)/projectsss/invalid_project_id
    When execute method GET
    Then the status code should be 404
    * print response

  @BadRequest
  Scenario: Enviar solicitud inválida al crear proyecto (400)
    Given call Workspaces.feature@getAllWorkspaces
    And endpoint /workspaces/$(env.workspace_id)/projects
    And body jsons/bodies/badRequestProject.json
    When execute method POST
    Then the status code should be 400
    * print response
