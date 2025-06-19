@clockify @Pojects
Feature: Pruebas para /projects en Clockify

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = "application/json"
    And header Accept = "application/json"
    And header X-Api-Key = "$(env.api_key)"

  @getProjectsFromWorkspace
  Scenario: Obtener todos los proyectos de un workspace
    And endpoint /workspaces/$(env.workspace_id)/projects
    When execute method GET
    Then the status code should be 200
    * print response

  @GetProjectById
  Scenario: Consultar un proyecto por su identificador
    Given call Projects.feature@getProjectsFromWorkspace
    And endpoint /workspaces/$(env.workspace_id)/projects/{{projectId}}
    When execute method GET
    Then the status code should be 200
    * define projectId = $[0].id
    * print response

  @CreateProject
  Scenario: Crear un proyecto
    Given call Workspaces.feature@getAllWorkspaces
    And endpoint /workspaces/$(env.workspace_id)/projects
    And body jsons/bodies/createProject.json
    When execute method POST
    Then the status code should be 201
    And I save from result JSON the attribute id on variable env.project_id
    And response should be $.name = "werodsaa"
    And response should be $.billable = true
    * print response

  @AddProjectWithOptional
  Scenario: Crear un proyecto con campos opcionales adicionales
    Given call Workspaces.feature@getAllWorkspaces
    * define random = java.util.UUID.randomUUID().toString().substring(0, 8)
    And endpoint /workspaces/$(env.workspace_id)/projects
    And body jsons/bodies/createProjectFull.json
    When execute method POST
    Then the status code should be 201
    And response should be $.color = "#03A9F4"
    * print response

  @GetProjectsFiltered
  Scenario: Obtener el proyecto filtrado por un nombre
    Given call Workspaces.feature@getAllWorkspaces
    And endpoint /workspaces/$(env.workspace_id)/projects?name=Aguas
    When execute method GET
    Then the status code should be 200
    * print response

  @CheckProjectExists
  Scenario: Verificar que el proyecto existe y el id es correcto
    Given call Projects.feature@CreateProject
    And endpoint /workspaces/$(env.workspace_id)/projects/$(env.project_id)
    When execute method GET
    Then the status code should be 200
    And response should be $.id = "$(env.project_id)"
    * print response

  @EditProject
  Scenario: Editar un proyecto
    Given call Projects.feature@CreateProject
    And endpoint /workspaces/$(env.workspace_id)/projects/$(env.project_id)
    And body jsons/bodies/editProject.json
    When execute method PUT
    Then the status code should be 200
    And response should be $.name = "ProyectoEditadoLowCode"
    * print response

  @ArchiveOnly
  Scenario: Archivar un proyecto
    Given call Projects.feature@CreateProject
    And endpoint /workspaces/$(env.workspace_id)/projects/$(env.project_id)
    And body jsons/bodies/archiveProject.json
    When execute method PUT
    Then the status code should be 200

  @DeleteOnly
  Scenario: Eliminar un proyecto
    Given call Projects.feature@CreateProject
    And call Projects.feature@ArchiveOnly
    And endpoint /workspaces/$(env.workspace_id)/projects/$(env.project_id)
    When execute method DELETE
    Then the status code should be 200
    * print response

  @VerifyDeletion
  Scenario: Validar que el proyecto eliminado no existe
    Given call Projects.feature@CreateProject
    And call Projects.feature@ArchiveOnly
    And call Projects.feature@DeleteOnly
    And endpoint /workspaces/$(env.workspace_id)/projects/$(env.project_id)
    When execute method GET
    Then the status code should be 404
    * print response



