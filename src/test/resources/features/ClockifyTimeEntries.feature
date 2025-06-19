@clockify @TimeEntries
Feature: CRUD de registros de hora en Clockify

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = "application/json"
    And header Accept = "application/json"
    And header X-Api-Key = "$(env.api_key)"

  @getUserId
  Scenario: Obtener el ID del usuario actual
    Given endpoint /user
    When execute method GET
    Then the status code should be 200
    * define env.user_id = $.id

  @Projects
  Scenario: Obtener el ID del proyecto
    And endpoint /workspaces/$(env.workspace_id)/projects
    When execute method GET
    Then the status code should be 200
    * print response
    * define projectId = $[0].id

  @GetAllTimeEntries
  Scenario: Consultar todas las entradas de tiempo
    Given call ClockifyTimeEntries.feature@getUserId
    And endpoint /workspaces/66dcc0fcd2ef02363c07c5d4/user/$(env.user_id)/time-entries
    When execute method GET
    Then the status code should be 200
    * print response
    * define env.workspace_id = $[0].id

  @AddNewTimeEntry
  Scenario: Agregar una nueva entrada de tiempo
    Given call ClockifyTimeEntries.feature@projects
    And endpoint /workspaces/$(env.workspace_id)/time-entries
    And body jsons/bodies/AddNewTimeEntry.json
    When execute method POST
    Then the status code should be 201
    * define timeEntryId = $.id
    * define userId = $.userId

  @GetTimeEntryWorkSpace
  Scenario: Consultar una entrada de tiempo específica
    Given endpoint /workspaces/$(env.workspace_id)/time-entries/6852714e7e359d43b58c7287?hydrated=true
    When execute method GET
    * print response
    Then the status code should be 200

  @DeleteTimeEntry
  Scenario: Eliminar una entrada de tiempo específica
    Given endpoint /workspaces/66dcc0fcd2ef02363c07c5d4/time-entries/672a4a2b0129267c27e33262
    When execute method DELETE
    Then the status code should be 204
    * print response


  @bulkEditHours
  Scenario: Editar registros de hora (Bulk PUT)
    And call ClockifyWorkspace.feature@getWorkspaceFromWithCall
    And call ClockifyTimeEntries.feature@GetUserId
    And endpoint /workspaces/$(workSpaceId)/users/$(env.user_id)/time-entries
    And body jsons/bodies/bulkEditHours.json
    When execute method PUT
    Then the status code should be 200
    And response should be $.description = "Editado este texto con bulk"
    * print response

  @bulkEditHours
  Scenario: Editar registros de hora (Bulk PUT)
    And endpoint /workspaces/$(workSpaceId)/users/66dcc0fcd2ef02363c07c5d3/time-entries
    And body jsons/bodies/bulkEditHours.json
    When execute method PUT
    Then the status code should be 200
    And response should be $.description = "Editado este texto con bulk"
    * print response

