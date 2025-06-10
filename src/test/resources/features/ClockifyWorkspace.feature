@clockify @Workspaces
Feature: Pruebas para /workspaces en Clockify

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = "application/json"
    And header Accept = "application/json"
    And header X-Api-Key = "$(env.api_key)"

  @getAllWorkspaces
  Scenario: Obtener exitosamente todos los workspaces
    Given endpoint /workspaces
    When execute method GET
    Then the status code should be 200
    * define workspace_id = $[0].id

  @getWorkspaceFromWithCall
  Scenario: Obtener exitosamente información del workspace con llamada
    Given call Workspaces.feature@getAllWorkspaces
    And endpoint /workspaces/$(env.workspace_id)
    When execute method GET
    Then the status code should be 200
    * print response

  @getClientsFromWorkspace
  Scenario: Obtener exitosamente todos los clientes de un workspace
    Given call Workspaces.feature@getAllWorkspaces
    And endpoint /workspaces/$(env.workspace_id)/clients
    When execute method GET
    Then the status code should be 200
    * print response
