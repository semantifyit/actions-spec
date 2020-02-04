
# Conceptualization

A schema.org action can have one of four statuses depending on its state. We map different stages of the client-API interaction to schema.org action statuses.

**Request**: An action instance with all required parameters (and possible optional) parameters are filled. This action is in **ActiveActionStatus**.

# Specification

## Resource Description

## Resource Linking
## Lifting and Grounding

### Grounding (Request Mapping)

### Lifting (Response Mapping)

The example below shows a response mapping. An Offer is returned as a result of a SearchAction. A potential action is attached to the Offer instance,with the result of a smtfy:link function as its object. This function returns an action (a SHACL node shape with targetClass schema:Action and its subtypes) with the given parameters filled with the specified value (schema:identifier is filled with the ID of the returned Offer).

?> _TODO_ A short tip about potential actions.

!> **Thibault** please check the syntax. 

```yaml

prefixes:
  schema: "http://schema.org/"

mappings:
  action:
    sources:
      - ['input~xpath', '/Result']
    po:
      - [a, schema:SearchAction]
      - [schema:actionStatus, 'CompletedActionStatus']
      - [schema:result, {mapping: offer}]

  offer:
    sources:
      - ['input~xpath', '/Result/Offer']
    po:
      - [a, schema:Offer]
      - [schema:name, $(@name)]
      - [schema:price, $(@price)]
      - [schema:identifier, $(@id)]
      - [schema:potentialAction, {function: buyActionFn}]

functions:
  buyActionFn:
    - function: smtfy:Link
    parameters:
      - [smtfy:actionURI, smtfy:BuyAction2455]
      - [schema:identifier, $(@id)]
  

```


# Examples
