@clockify @Workspaces
Feature: Pruebas para /workspaces en Clockify

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = "application/json"
    And header Accept = "application/json"
    And header X-Api-Key = "$(env.api_key)"

  @getAllWorkspaces
  Scenario: Obtener todos los workspaces
    Given endpoint /workspaces
    When execute method GET
    Then the status code should be 200
    * define env.workspace_id = $[0].id


  @getUsersId
  Scenario: Obtener todos los usuarios de un workspace
    Given endpoint /workspaces/$(env.workspace_id)/users
    When execute method GET
    Then the status code should be 200
    * print response
    * define UsersId = $[0].id


  @getWorkspaceFromWithCall
  Scenario: Obtener información del workspace con llamada
    And endpoint /workspaces/$(env.workspace_id)
    When execute method GET
    Then the status code should be 200
    * print response

  @getClientsFromWorkspace
  Scenario: Obtener todos los clientes de un workspace
    And endpoint /workspaces/$(env.workspace_id)/clients
    When execute method GET
    Then the status code should be 200
    * print response




