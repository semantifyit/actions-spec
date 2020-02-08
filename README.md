
# Conceptualization

A schema.org action can have one of four statuses depending on its state. We map different stages of the client-API interaction to schema.org action statuses.

**Request**: An action instance with all required parameters (and possible optional) parameters are filled. This action is in **ActiveActionStatus**.

# Specification

## Resource Description

## Resource Linking

In many cases, an operation on a resource of an API requires the response of another operation on another resource in the same or a different API. To support such cases, we allow linking of property shapes as the value of a property whose value needs to be retrieved from the result of another action. There are two ways to do this linking. 

The simplest way is when the entire result object is needed as an input. This can be accomplished by just linking a node shape. See the example below for an action to search bus stops.

**BusStopSearch.jsonld**
```json

{
    "@context": {"@vocab": "http://schema.org/", "smtfy": "https://actions.semantify.it/vocab/"},
    "@type": "SearchAction",
    "@id": "http://actions.semantify.it/actions/30cc4a54-6391-4ec9-aaef-d11b72c752e2"
    "name": "Search for bus stops",
    "actionStatus": "PotentialAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "http://actions.semantify.it/api/vao/busstops",
      "httpMethod": "GET",
      "encodingType": "application/ld+json",
      "contentType": "application/ld+json"
    },
    "smtfy:authentication": {
      "@type": "smtfy:TokenAuthentication",
      "value-input": "required"
    },
    "query-input": "required",
    "result": {
      "@type": "BusStop",
      "name-output": "required",
      "geo": {
        "@type": "GeoCoordinates",
        "latitude-output": "required",
        "longitude-output": "required"
      }
    }
  }

```
In this example, the operation takes a query string (query-input property), and returns a list of BusStop with their names and geo-coordinates. Note that, the Action itself is identified with a URI
> http://actions.semantify.it/actions/30cc4a54-6391-4ec9-aaef-d11b72c752e2

Below there is an example action for searching bus connections. We link the action above to the input properties **fromLocation** and **toLocation**. 

```json
{
    "@context": {
        "@vocab": "http://schema.org/",
        "sh": "https://raw.githubusercontent.com/w3c/shacl/master/.../shacl.context.ld.json",
        "smtfy": "https://actions.semantify.it/ns/",
        "smtfya": "https://actions.semantify.it/actions/"
    },
    "@type": "SearchAction",
    "object": {
        "@type": "Trip, TravelAction",
        "fromLocation-input": "required hasValueFrom={action: smtfy:30cc4a54-6391-4ec9-aaef-d11b72c752e2}",
        "toLocation-input": "required hasValueFrom={action: smtfy:30cc4a54-6391-4ec9-aaef-d11b72c752e2}",
        "departureTime-input": "required ",
        "arrivalTime-input": "optional"
    },
    "result": 
    {
        "@type": ["Trip","TravelAction"],
        "fromlocation": {
          "@type": "Place",
          "name-output": "required"
        },
        "toLocation": {
          "@type": "Place",
          "name-output": "required"
        }
        "departureTime-output": "required",
        "arrivalTime-output": "required",
        "subTrip": {
            "@type": [
                "Trip",
                "TravelAction"
            ],
            "sh:shape": [
                "smtfy:FromLocationShapeOut",
                "smtfy:FromLocationShapeOut"
            ],
            "departureTime-output": "required",
            "arrivalTime-output": "required"
        }
    },
    "target": {
        "@type": "EntryPoint",
        "urltemplate": "http://actions.semantify.it/zpwv/...",
        "httpMethod": "POST"
    }
}

```

An action processing client should first make the necessary request to the linked action (i.e. bus stop search), and then complete the main action (i.e. search connections). 

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


# Use Case: Dialog Generation from API Annotations
