# Preface {docsify-ignore}

|        | Name, Affiliation |
|----------------|--------------------------------------------------------------|
| **Editor**:        | [Umutcan Şimşek](http://umutcan.eu), University of Innsbruck |
| **Contributors:**   | [Thibault Gerrier](https://www.sti-innsbruck.at/about/team/details/thibault-gerrier), University of Innsbruck    |
| **Latest Version:** | [v0.5.0](changelog.md ":target=_blank") ({docsify-updated})                                                      |


# Introduction
The schema.org vocabulary is a de facto industrial standard for creating semantically annotated data. The vocabulary with its actions subset that allows to describe not only entities on the web, but also actions that can be taken on them. The Web Service Annotation with Schema.org (WASA) language puts schema.org actions into a Web API perspective by restricting and extending it with the help of the [domain specification](#domain-specification) process for the creation of WASA APIs. 

The WASA language sees Web APIs as a collection of actions that can be taken on a graph resources. These actions can be linked explicitly, allowing clients to achieve certain goals without hardcoding the orchestration of these actions (i.e. order of action invocation). As a domain model to describe input and output parameters, we use [domain-specific patterns](#def-domain-specific-pattern) that restrict and extend the schema.org vocabulary. An API publisher can define constraints over the input and output of an action via these pattern that are defined with SHACL shapes.

?> The namespace of WASA language is **http://vocab.sti2.at/wasa/**. The suggested prefix is **wasa**.

?> The http://vocab.sti2.at/wasa/ interface is under construction. For now the vocabulary can be found in [Turtle format](vocab/ext/WebAPIExt.ttl ':ignore').


Below we first give some definitions of the notions that are used in this specification. Afterward, we first introduce the domain specification approach and domain-specific patterns. We follow with the relevant types and properties of schema.org for creating Web APIs defined with WASA. We also explain the usage of WASA language from a practical perspective with a running example and give some use cases for the potential usage of the action annotations.

# Definitions



<span id="def-potential-action">

**Potential Action**: The description of an operation that can be taken on a resource. 

</span>

<span id="def-active-action">

**Request (Active Action)**: An action instance with that is created by a [WASA Client](#def-wasa-client) to be sent to a [WASA API](#def-wasa-api)

</span>

<span id="def-completed-failed-action">

**Completed/Failed Action**: A response from a WASA API.

</span>

<span id="def-domain-specific-pattern">
  

> **Domain-specific pattern:** An extended restriction of the schema.org vocabulary specified with a SHACL Node Shape.

</span>

<span id="def-wasa-api">
  

> **WASA API:** A Web API that is a collection of potential actions that are created according to WASA specification. 

</span>


<span id="def-wasa-client">


> **WASA Client:** A client that communicates with a WASA API. It processes a potential action and creates an active action based on the input specifications and constraints.

</span>



<span id="def-sparql-property-path">
  

> **SPARQL Property Path:** A route between two graph nodes as defined in [SPARQL 1.1 Specification](https://www.w3.org/TR/sparql11-query/#propertypaths).

</span>

# Domain Specification

A domain specification is a process to create a domain specific pattern, which is an extended subset of schema.org. schema.org is a large vocabulary that covers several domains in a shallow way. To create a domain specific pattern, the domain specification process applies an operator on schema.org to remove the types and properties that are not relevant for the given domain, defines local properties on the remaining types and applies additional constraints on the ranges and values of remaining properties. The syntax of domain specification operator is a subset of [Shapes Constraint Language (SHACL)](https://www.w3.org/TR/shacl/). The semantics is _slightly_ [different](https://drive.google.com/file/d/1BmAikrlw8lRMZWrXT1sFfHZUEPruEbcy/view). 

![ds process](_media/ds-process.svg  ':class=figure' )

<div class="caption">The domain specification process.</div>


!> **_Relationship between SHACL and Domain Specifications_**: SHACL is a language that is built around the notion of *shape* in order to verify RDF graphs. A shape is either a node shape that applies constraints on nodes in an RDF graph, or a property shape that does the same to properties. In principle, we use SHACL as is, but we apply stricter syntax rules in terms of which constraint components can be applied on which type of shapes and how the shapes are interpreted (semantics). For instance, multiple target definitions are interpreted as disjunction in SHACL, but as a conjunction in domain specification approach.

?> For a domain specific pattern, please see the [LodgingBusiness](https://semantify.it/domainSpecifications/public/l49vQ318v) example. The domain specification operator as for this pattern is also [available](https://semantify.it/ds/l49vQ318v) as a SHACL shape. 


# Schema.org Actions

Schema.org contains an [Action](https://schema.org/Action) type to provide a mechanism to define actions that can be take on entities. In the context of schema.org, the actions are quite generic. For example, the [Action](https://schema.org/Action) type includes properties like **startTime** and **endTime** to describe the time span an action occurred or the **location** property to describe where the action took place. We restrict and extend the properties defined for the [Action](https://schema.org/Action) type and consequently its subtypes in order to make them more specific to a Web API annotation task.
The table below shows the properties of Action type that are relevant for the WASA language.

|    **Property**    |            **Range**            | **Description** |
|:--------------:|:---------------------------:|:-----------:|
|  actionStatus  |       ActionStatusType      |           Indicates the current disposition of the Action.  |
|     object     |            Thing            |       The object upon which the action is carried out, whose state is kept intact or changed. Also known as the semantic roles patient, affected or undergoer (which change their state) or theme (which doesn't). e.g. John read a book.      |
|     result     |            Thing            |      The result produced in the action. e.g. John wrote a book.       |
|     target     |          EntryPoint         |      Indicates a target EntryPoint for an Action.       |
|      error     |            Thing            |      An error specification.       |

## Input-Output Parameters

Schema.org actions provide a mechanism to define the input and output parameters of an action. In terms of syntax, this is merely an extension to the name of the property. According to the actions [documentation](https://schema.org/docs/actions.html), the parameter convention is as follows:


|**Property** | **Range** | **Description**|
|:---------:|:----------:|:---------:|
| &lt;property&gt;-input | PropertyValueSpecification | Indicates how a property should be filled in before initiating the action. |
| &lt;property&gt;-output | PropertyValueSpecification | Indicates how the field will be filled in when the action is completed. |

The PropertyValueSpecification type contains several properties that reflect the input attributes in HTML forms. These properties enable the description of the nature of input and output.

[PropertyValueSpecification](http://schema.org/PropertyValueSpecification)


**Property** | **Range** | **Description**
:---------:|:----------:|:---------:
 valueRequired | Boolean | Whether the property must be filled in to complete the action.
 defaultValue | Thing, DataType | The default value for the property.  For properties that expect a DataType, it's a literal value, for properties that expect an object, it's an ID reference to one of the current values
 valueName | Text | Indicates the name of the PropertyValueSpecification to be used in URL templates and form encoding
 readonlyValue | Boolean | Whether or not a property is mutable
 multipleValues | Boolean | Whether multiple values are allowed for the property.
 valueMinLength | Number | Specifies the minimum number of characters in a literal value. 
 valueMaxLength | Text | Specifies the maximum number of characters in a literal value. 
 valuePattern | Text | Specifies a regular expression for testing literal values 
 minValue | Number, Date, Time, DateTime | Specifies the allowed range and intervals for literal values.  
 maxValue | Number, Date, Time, DateTime | The upper value of some characteristic or property. 
 stepValue | Number | The step attribute indicates the granularity that is expected (and required) of the value.

?> The input and output properties on an Action support a syntactical shorthand. One can write `<property>-input: "required maxlength=100 name=q"` in order to specify a required input parameter named **q** with maximum length of 100 characters. See the [documentation](https://schema.org/docs/actions.html) for details.

## Potential Actions
The schema.org vocabulary defines a potentialAction property that enables the connection of actions on instances. Informally, the instance to which an potential action is connected is the object of that action. We explain how potential actions are defined with WASA in the [Specification](#specification) section.


# Specification

In this section, we explain the WASA specification with a running example. We annotate an operation from the [OpenWeather API](https://openweathermap.org/api) and link the resulting action with another action created based on a geocoding operation from the [Open Cage Data API](https://opencagedata.com/api). The content of this section is based on [MindLab Deliverable D543](https://drive.google.com/file/d/13K9AD-uwfv_7zL-LaLPRHC6dPf1ENi_1/view?usp=sharing).

?> The descriptions in this section are rather informal. See [Appendix](#appendix) for the domain specification operators (SHACL shapes) that dictate the WASA language based on the schema.org vocabulary and WASA extension.

?> **Notation:** The types and properties written in the flowing text are `emphasized`. The first letter of types are capitalized (e.g. `Thing`). Properties are written in camel case (e.g. `potentialAction`). Any type or property without a prefix is from schema.org vocabulary. The types and properties introduced by the WASA language represented with _wasa_ prefix. _sh_ is used for SHACL types and properties. 

##  WASA API

The WASA specification uses the `WebAPI` type as the main type to annotate the entry point of a [WASA API](#def-wasa-api). This type allows the definition of the API documentation (machine- and human-readable) as well as some non-functional metadata about the API.

**Thing  > Intangible  > Service  > [WebAPI](http://schema.org/WebAPI)**

| Property | Range | Description                                                                    |
|-------------------|----------------|-----------------------------------------------------------------------------------------|
| name              | Text           | The name of the Web API                                                                 |
| description       | Text           | A short description of the Web API                                                      |
| documentation     | CreativeWork   | The documentation(s) of the Web API. A documentation can be machine- or human-readable. |
| termsOfService    | URL or Text    | A terms of service document of the Web API.                                             |

The most important property of this type is the `documentation` property. This property allows a definition of documentation as an instance of type CreativeWork. This documentation can be processed by a client (human or machine) to consume the API.


```json
{
  "@context": {
    "sh": "http://www.w3.org/ns/shacl#",
    "wasa": "https://vocab.sti2.at/wasa/",
    "weather": "https://vocab.sti2.at/weather/",
    "@vocab": "http://schema.org/"
  },
  "@type": "WebAPI",
  "name": "Open Weather API",
  "description": "Annotation of Open Weather API with schema.org actions",
  "documentation": {
    "@type": "CreativeWork",
    "name": "API documentation",
    "url": "",
    "encodingFormat": "application/ld+json",
    "version": "1.0.0",
    "about": [
      {
        "@id": "http://actions.semantify.it/api/rdf/action/100665a8-a0de-11ea-8c03-c14ba487f916"
      }
    ]
  },
  "@id": "http://actions.semantify.it/api/rdf/webapi/100665a0-a0de-11ea-8c03-c14ba487f916"
}
```
<div class="caption">WebAPI example</div>

## API Documentation 

A documentation of a WASA API is an instance of the `CreativeWork` type.

**Thing > [CreativeWork](http://schema.org/CreativeWork)**

| Property | Range         | Description                                                 |
|-------------------|------------------------|----------------------------------------------------------------------|
| about             | Action                 | An operation on a resource of a  WASA API                              |
| accountablePerson | Person or Organization | A person or organization that is accountable from the WASA API       |
| author            | Person or Organization | The author of the WASA API documentation                              |
| contributor       | Person or Organization | A person or organization who contributed to the WASA API in some way. |
| encodingFormat    | Text                   | A media type. Typically application/ld+json or text/html             |
| license           | CreativeWork           | The license of the WASA API documentation                             |
| name              | Text                   | The name of the documentation                                        |

!> A WASA API can have multiple documentations. However a WASA Client does not have to understand all documentations. A WASA client should be able to process the documentations that are encoded in an RDF serialization format (e.g. application/ld+json). 

The `about` property takes `Action` instances as value. The values of the `about` property comprise a set of operation descriptions (i.e. Potential Actions) that can be taken on a resource on a WASA API.  The value of the `encodingFormat` property indicates to the client how the API can be processed. The properties with the range `Person` or `Organization` typically contain contact information such as name, e-mail and URL of the person or organization's website.

See the value of the `documentation` property in the _WebAPI example_ above. Note that value of the of the `encodingFormat` property is _application/ld+json_. 


## Potential Action
The building blocks of an API annotated with WASA are instances of `Action` which describe the operations that can be taken on a resource.

Thing > [Action](http://schema.org/Action)

| Property             | Range                      | Description                                                                        |
|--------------------------|-------------------------------------|---------------------------------------------------------------------------------------------|
| actionStatus             | ActionStatusType                    | The status of the action                                                                    |
| description              | Text                                | A short description of the operation on a resource                                          |
| error                    | wasa:Error                          | An error message that the operation may return                                              |
| name                     | Text                                | The name of the operation                                                                   |
| target                   | EntryPoint                          | The invocation mechanism of the action over HTTP                                            |
| wasa:actionShape         | sh:NodeShape                        | The domain specification operators that define the input and output parameters              |
| wasa:potentialActionLink | wasa:PotentialActionLink | The potential action that may be attached to the response returned after invoking an action |
| wasa:precedingActionLink | wasa:ActionLink                     | An action whose result is linked to the input of an action.                                 |
 
!> An operation description on a resource has the value `PotentialActionStatus` for the `actionStatus` property.The same property has `ActiveActionStatus` for requests and `CompletedActionStatus` or `FailedActionsStatus` responses. 

Alongside the name and the description of the operation, we can define potential error messages and status codes (via the `error` property), linked actions (via `wasa:potentialActionLink` and `wasa:precedingActionLink` properties), the invocation mechanism (via `target` property) and various input and output specifications (via `wasa:actionShape`).


The example below shows the _GetCurrentWeather_ action. Since it is an operation description, the `actionStatus` property has `PotentialActionStatus` value. The values of `target`, `wasa:actionShape` and `wasa:precedingActionLink` properties will be explained in detail in the following sections.

```json
{
    "@context": {
      "sh": "http://www.w3.org/ns/shacl#",
      "wasa": "https://vocab.sti2.at/wasa/",
      "weather": "https://vocab.sti2.at/weather/",
      "@vocab": "http://schema.org/"
    },
    "@type": "SearchAction",
    "name": "GetCurrentWeather",
    "actionstatus": "PotentialActionStatus",
    "description": "Get current weather forecast at a location by geo-coordinates",
    "target": {
        // an EntryPoint instance that describes the invocation mechanism of the action
    },
    "@id": "/api/rdf/action/100665a8-a0de-11ea-8c03-c14ba487f916",
    "wasa:actionShape": {
        // a SHACL Node Shape describing the input and output parameters
    },
    "wasa:precedingActionLink": [
      {
        // the mapping of the output parameters of an action to the input parameters of another action.
      }
    ]
  }
```
<div id="caption-potential-action" class="caption">Potential Action example</div>

> _TODO_ update example with error and potentialActionLink properties.

### Error

An operation can have multiple error messages that can occur after a request. Alongside the HTTP error code that is returned in the request header, more specific errors can be specified. 
The description of these potential errors that can occur during an operation is done via the instances of `wasa:Error` type. 

**Thing > Intangible > StructuredValue > PropertyValue > wasa:Error**

| Property    | Range | Description                                                                                           |
|-------------|-------|-------------------------------------------------------------------------------------------------------|
| description | Text  | A custom error message supporting the HTTP status                                             |
| propertyID  | Text  | An internal ID for the error message.                                                                 |
| url         | URL   | A website that contains the details about the error message and possibly troubleshooting information. |


For a potential error, a `propertyID` can be specified, which is typically an ID assigned by the API. The `description` property is used for the error message. A URL for the detailed error description and troubleshooting information can be specified with via the `url` property. 

> _TODO_ add an error example

### Invocation

The invocation mechanism of an operation is specified with an instance of the `EntryPoint` type as the value of the `target` property. An entry point is may either describe a generic endpoint to which a WASA Client sends requests or a SPARQL endpoint of a triple store to which a WASA Client sends a SPARQL query generated based on a Potential Action. 


**Thing >  Intangible > [EntryPoint](http://schema.org/EntryPoint)**

**Thing >  Intangible > [EntryPoint](http://schema.org/EntryPoint) > wasa:SPARQLEndpoint**


| Property | Range |  Description                                                                                                                           |
|-------------------|----------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| contentType       | Text           | The supported content type(s) for an EntryPoint response.                                                                                      |
| encodingType      | Text           | The supported encoding type(s) for an EntryPoint request.                                                                                      |
| httpMethod        | Text           | An HTTP method that specifies the appropriate HTTP method for a request to an HTTP EntryPoint. Values are capitalized strings as used in HTTP. |
| urlTemplate       | Text           | An url template (RFC6570) that will be used to construct the target of the execution of the action.                                            |

The interaction mechanism of a client and an API that serves actions is based on exchanging action instances with different status ([see `actionStatus` property and its possible values](#resource-operation-description).) 

?> The interaction mechanism of a WASA Client and a WASA API resembles to [GraphQL](https://graphql.org/learn/serving-over-http/).  

The contentType and encodingFormat properties allows specifying the data format of the response of a WASA API and a request of a WASA Client respectively. A WASA client and an API exchange `Action` instances. This requires the value of the `contentType` and `encodingFormat` properties to be an RDF serialization format. The `httpMethod` property specifies the HTTP method of the request.

!> Although any RDF serialization format can be used, the JSON-LD format is recommended. Since the representation of action instances in may become quite large, POST requests are preferred. 

The value of the `urlTemplate` property represents the endpoint to which a WASA Client should send a request.

!> The endpoint may represent a single resource (e.g., _api.openweathermap.org/data/2.5/weather_) or the entire API as a graph, similar to the GraphQL approach (e.g., _action.semantify.it/api/openweather/action/_). In case of the entry point being a `wasa:SPARQLEndpoint` instance, then the `urlTemplate` property represents a SPARQL endpoint.

The example below shows a target definition on the potential action in [Resource Operation Description example](#caption-potential-action).

```json
//...
   "target": {
      "@type": "EntryPoint",
      "httpMethod": "POST",
      "contentType": "application/ld+json",
      "encodingType": "application/ld+json",
      "urlTemplate": "/api/action/100665a0-a0de-11ea-8c03-c14ba487f916/"
    }
//...
```
<div class="caption">Invocation description of a potential action</div>

> _TODO_ add an example of SPARQL endpoint abstraction with actions

### Action Shape

The action shape defines a [domain-specific pattern](#def-domain-specific-pattern) that describes the input and output parameters of a potential action. The [domain-specific pattern](#def-domain-specific-pattern) is defined with a [SHACL Node Shape](https://www.w3.org/TR/shacl/#node-shapes). It defines three local properties, namely `object`, result, and authentication.

```json
//...
"wasa:actionShape": {
      "@type": "http://www.w3.org/ns/shacl#NodeShape",
      "sh:property": [
        {
          "@id": "/api/rdf/prop/100701e7-a0de-11ea-8c03-c14ba487f916",
          "sh:path": {
            "@id": "object"
          },
          //...
        },
        {
          "@id": "/api/rdf/prop/8e87d870-a104-11ea-b5b6-3596ef396fa2",
          "sh:path": {
            "@id": "wasa:authentication"
          },
          //...
        },
        {
          "@id": "/api/rdf/prop/100701e8-a0de-11ea-8c03-c14ba487f916",
          "sh:path": {
            "@id": "result"
          },
          //...
    },
    ]
```
  
<div class="caption">An action shape example</div>

!> Although the [domain-specification process](#domain-specification) is generic to any restriction and extension of schema.org, an action shape defines object, result and authentication SHACL property shapes by default. The restrictions defined on the values of these properties are used to verify requests and responses. See [WASA Client-API Interaction Specification](_interaction.md).

The `object` property shape in the action shape specifies the input required to complete the operation the potential action describes. The range of the `object` property is a type that is more specific than `Thing`. The range can be further restricted in accordance to the [domain specification process](#domain-specification), in order to define the input parameters.

The example below shows the definition of the input of _GetCurrentWeather_ action. The property path with the path object defines a `weather:WeatherReport` instance as an input. The action requires the geocoordinates (via `contentLocation/geo/latitude` and `contentLocation/geo/longitude` properties) and a unit value (via `variableMeasured/unitCode`) to run the action. Note that the [SHACL constraint components](https://www.w3.org/TR/shacl/#constraints) are used on the property shapes. For example, cardinality constraints are used to indicate required parameters. The _sh:in_ constraint component is used to restrict the range of `unitCode` property to a list of values.
```json
        {
          "@id": "/api/rdf/prop/100701e7-a0de-11ea-8c03-c14ba487f916",
          "sh:path": {
            "@id": "object"
          },
          "sh:group": {
            "@id": "wasa:Input"
          },
          "sh:minCount": 1,
          "sh:maxCount": 1,
          "sh:class": [
            {
              "@id": "weather:WeatherReport"
            }
          ],
          "sh:node": {
            "sh:property": [
              {
                "@id": "/api/rdf/prop/df11fca0-a0ee-11ea-a6f9-bb51539b9814",
                "sh:path": {
                  "@id": "contentLocation"
                },
                "sh:minCount": 1,
                "sh:maxCount": 1,
                "sh:class": [
                  {
                    "@id": "Place"
                  }
                ],
                "sh:node": {
                  "sh:property": [
                    {
                      "@id": "/api/rdf/prop/e8f67cf0-a0ee-11ea-a6f9-bb51539b9814",
                      "sh:path": {
                        "@id": "geo"
                      },
                      "sh:minCount": 1,
                      "sh:maxCount": 1,
                      "sh:class": [
                        {
                          "@id": "GeoCoordinates"
                        }
                      ],
                      "sh:node": {
                        "sh:property": [
                          {
                            "@id": "/api/rdf/prop/eb83de90-a0ee-11ea-a6f9-bb51539b9814",
                            "sh:path": {
                              "@id": "latitude"
                            },
                            "sh:minCount": 1,
                            "sh:maxCount": 1,
                            "sh:datatype": "double"
                          },
                          {
                            "@id": "/api/rdf/prop/ee6839d0-a0ee-11ea-a6f9-bb51539b9814",
                            "sh:path": {
                              "@id": "longitude"
                            },
                            "sh:minCount": 1,
                            "sh:maxCount": 1,
                            "sh:datatype": "double"
                          }
                        ]
                      }
                    }
                  ]
                }
              },
              {
                "@id": "/api/rdf/prop/f2b5e710-a104-11ea-b5b6-3596ef396fa2",
                "sh:path": {
                  "@id": "variableMeasured"
                },
                "sh:minCount": 1,
                "sh:maxCount": 1,
                "sh:class": [
                  {
                    "@id": "PropertyValue"
                  }
                ],
                "sh:node": {
                  "sh:property": [
                    {
                      "@id": "/api/rdf/prop/fc266fe0-a104-11ea-b5b6-3596ef396fa2",
                      "sh:path": {
                        "@id": "unitCode"
                      },
                      "sh:minCount": 1,
                      "sh:maxCount": 1,
                      "sh:in": {
                        "@list": [
                          "CE",
                          "FA"
                        ]
                      },
                      "sh:datatype": "string"
                    }
                  ]
                }
              }
            ]
          }
        }
```
<div class="caption">Input specification by an action shape</div>

An action may require authentication to be conducted. The `wasa:authentication` property specifies the authentication information that needs to be provided by the client to carry out the operation. The range is a type that is more specific than `wasa:AuthenticationSpecification`. 

!> WASA provides three subtypes of `wasa:AuthenticationSpecification`, namely `wasa:FormBasedAuthentication`, `wasa:HTTPBasicAuthentication` and `wasa:TokenAuthentication`. The range can be further restricted to one of these types or another subtype of `wasa:AuthenticationSpecification` that is defined by another extension.

The example below specifies a wasa:TokenAuthentication instance with the SHACL propery shape with the `wasa:authentication` path. This indicates that the client needs to provide a single token value (e.g. an API key) in order to conduct this action.

```json
        {
          "@id": "/api/rdf/prop/8e87d870-a104-11ea-b5b6-3596ef396fa2",
          "sh:path": {
            "@id": "wasa:authentication"
          },
          "sh:group": {
            "@id": "wasa:Input"
          },
          "sh:minCount": 1,
          "sh:maxCount": 1,
          "sh:class": [
            {
              "@id": "wasa:TokenAuthentication"
            }
          ],
          "sh:node": {
            "sh:property": [
              {
                "@id": "/api/rdf/prop/b5916fd0-a104-11ea-b5b6-3596ef396fa2",
                "sh:path": {
                  "@id": "value"
                },
                "sh:minCount": 1,
                "sh:maxCount": 1,
                "sh:datatype": "string"
              }
            ]
          }
        }
```
<div class="caption">Authentication specification by an action shape</div>

The `result` property in the domain-specific pattern specifies the response that should be returned by the server. Similar to the `object` property, the range of the `result` property is a type that is more specific than `Thing`, and it can be further restricted to define the output parameters. 

Similar to the input specification, the example below shows that _GetCurrentWeather_ action returns a weather report with a single weather measurement. The `weather:WeatherReport` is a subtype of [`schema:DataFeed`](http://schema.org/DataFeed). It can normally have multiple `weather:WeatherMeasurement` instances, however in this case the SHACL cardinality constraints require a weather report to have one and only one weather measurement. The `weather:WeatherMeasurement` type provides the weather condition (via [`schema:name`](http://schema.org/name)) date (via [`schema:dateCreated`](http://schema.org/dateCreated)) as well as measured temperature and apparent temperature (via `weather:temperature` and `weather:apparentTemperature`).

```json
        {
          "@id": "/api/rdf/prop/100701e8-a0de-11ea-8c03-c14ba487f916",
          "sh:path": {
            "@id": "result"
          },
          "sh:group": {
            "@id": "wasa:Output"
          },
          "sh:minCount": 1,
          "sh:maxCount": 1,
          "sh:class": [
            {
              "@id": "weather:WeatherReport"
            }
          ],
          "sh:node": {
            "sh:property": [
              {
                "@id": "/api/rdf/prop/1d3b12a0-a0ef-11ea-a6f9-bb51539b9814",
                "sh:path": {
                  "@id": "dataFeedElement"
                },
                "sh:minCount": 1,
                "sh:maxCount": 1,
                "sh:class": [
                  {
                    "@id": "weather:WeatherMeasurement"
                  }
                ],
                "sh:node": {
                  "sh:property": [
                    {
                      "@id": "/api/rdf/prop/1f5f2b20-a0ef-11ea-a6f9-bb51539b9814",
                      "sh:path": {
                        "@id": "dateCreated"
                      },
                      "sh:minCount": 1,
                      "sh:maxCount": 1,
                      "sh:datatype": "date"
                    },
                    {
                      "@id": "/api/rdf/prop/2db0c990-a0ef-11ea-a6f9-bb51539b9814",
                      "sh:path": {
                        "@id": "weather:apparentTemperature"
                      },
                      "sh:minCount": 1,
                      "sh:maxCount": 1,
                      "sh:class": [
                        {
                          "@id": "QuantitativeValue"
                        }
                      ],
                      "sh:node": {
                        "sh:property": [
                          {
                            "@id": "/api/rdf/prop/1490fa30-a107-11ea-b5b6-3596ef396fa2",
                            "sh:path": {
                              "@id": "value"
                            },
                            "sh:minCount": 1,
                            "sh:maxCount": 1,
                            "sh:datatype": "double"
                          },
                          {
                            "@id": "/api/rdf/prop/1e311e80-a107-11ea-b5b6-3596ef396fa2",
                            "sh:path": {
                              "@id": "minValue"
                            },
                            "sh:maxCount": 1,
                            "sh:datatype": "double"
                          },
                          {
                            "@id": "/api/rdf/prop/1f9d58b0-a107-11ea-b5b6-3596ef396fa2",
                            "sh:path": {
                              "@id": "maxValue"
                            },
                            "sh:maxCount": 1,
                            "sh:datatype": "double"
                          },
                          {
                            "@id": "/api/rdf/prop/20f128e0-a107-11ea-b5b6-3596ef396fa2",
                            "sh:path": {
                              "@id": "unitCode"
                            },
                            "sh:minCount": 1,
                            "sh:maxCount": 1,
                            "sh:in": {
                              "@list": [
                                "CE",
                                "FA"
                              ]
                            },
                            "sh:datatype": "string"
                          }
                        ]
                      }
                    },
                    {
                      "@id": "/api/rdf/prop/71fe0510-a106-11ea-b5b6-3596ef396fa2",
                      "sh:path": {
                        "@id": "name"
                      },
                      "sh:minCount": 1,
                      "sh:maxCount": 1,
                      "sh:datatype": "string"
                    },
                    {
                      "@id": "/api/rdf/prop/76049930-a106-11ea-b5b6-3596ef396fa2",
                      "sh:path": {
                        "@id": "description"
                      },
                      "sh:minCount": 1,
                      "sh:maxCount": 1,
                      "sh:datatype": "string"
                    },
                    {
                      "@id": "/api/rdf/prop/ae55b670-a106-11ea-b5b6-3596ef396fa2",
                      "sh:path": {
                        "@id": "weather:temperature"
                      },
                      "sh:minCount": 1,
                      "sh:maxCount": 1,
                      "sh:class": [
                        {
                          "@id": "QuantitativeValue"
                        }
                      ],
                      "sh:node": {
                        "sh:property": [
                          {
                            "@id": "/api/rdf/prop/1490fa30-a107-11ea-b5b6-3596ef396fa2",
                            "sh:path": {
                              "@id": "value"
                            },
                            "sh:minCount": 1,
                            "sh:maxCount": 1,
                            "sh:datatype": "double"
                          },
                          {
                            "@id": "/api/rdf/prop/1e311e80-a107-11ea-b5b6-3596ef396fa2",
                            "sh:path": {
                              "@id": "minValue"
                            },
                            "sh:maxCount": 1,
                            "sh:datatype": "double"
                          },
                          {
                            "@id": "/api/rdf/prop/1f9d58b0-a107-11ea-b5b6-3596ef396fa2",
                            "sh:path": {
                              "@id": "maxValue"
                            },
                            "sh:maxCount": 1,
                            "sh:datatype": "double"
                          },
                          {
                            "@id": "/api/rdf/prop/20f128e0-a107-11ea-b5b6-3596ef396fa2",
                            "sh:path": {
                              "@id": "unitCode"
                            },
                            "sh:minCount": 1,
                            "sh:maxCount": 1,
                            "sh:in": {
                              "@list": [
                                "CE",
                                "FA"
                              ]
                            },
                            "sh:datatype": "string"
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
```
<div class="caption">Output specification by an action shape example</div>

### Action Linking

While annotating an API, two actions can be linked in two directions:

* An action may use the result of another action. We call this a preceding action link.
* An action may be attached to the result of another action. We call this a potential action link.

In order to represent these two links, we define the `wasa:ActionLink` type and its subtype `wasa:PotentialActionLink`. 

**Thing > Intangible > wasa:ActionLink**

| Property             | Range| Description                                               |
|----------------------------------|------------------|---------------------------------------------------------------------|
| wasa:source                      | schema:Action    | The source action for the link                                      |
| wasa:target                      | schema:Action    | The target action for the link                                      |
| wasa:propertyMapping | wasa:PropertyMap | A mapping between the nodes of the source action and target action. |

We define the `wasa:source` and `wasa:target` properties to specify the direction of linked actions. When a client is creating a request, the values of some properties of a result of the source action is assigned as property values of the object of another action. The mapping between the values of result and object properties is done via the `wasa:PropertyMap` type. 

The wasa:PotentialActionLink type extends wasa:ActionLink with two properties:

| Property             | Range            | Description                                                                                                    |
|----------------------|------------------|----------------------------------------------------------------------------------------------------------------|
| wasa:source          | schema:Action    | The source action for the link                                                                                 |
| wasa:target          | schema:Action    | The target action for the link                                                                                 |
| wasa:propertyMapping | wasa:PropertyMap | A mapping between the nodes of the source action and target action.                                            |
| wasa:condition       | fno:Function     | The condition that needs to be satisfied by the instance selected by the iterator, to have a potential action. |
| wasa:iterator        | schema:Text      | A [SPARQL Property Path](#def-sparql-property-path) that specifies the instance(s) to which the potential action should be attached.        |

 A potential action attached on a response may be attached to any part of the value of the result property in the response. Therefore we define the `wasa:iterator` property to define the [SPARQL Property](#def-sparql-property-path) Path that indicates the node to which the potential action will be assigned. The `wasa:condition` property takes a boolean returning function as input and decides whether an instance should have a specific potential action (e.g., if there is a "withdraw" potential action defined on bank accounts, this action should be only available for the accounts that have a balance greater than zero).

?> We use [Function Ontology](https://fno.io) to describe concrete function implementations that return boolean values for the specification potential actiton conditions. This is currently underspecified in WASA.

The example below shows the specification of a _Preceeding Action Link_ for our [potential action example](#caption-potential-action). The _GetCurrentWeather_ action requires geo-location to return the current weather measurements at a location. In many cases, the geo-location must be obtained from an external source such as an end user device (e.g smartphone) or a Geocoding API based on a user input. The a preceding action link specifies how the output of an action is linked to the input of another action. Here we provide a city name to a Geocoding API and connect its output to the the input of _GetCurrentWeather_ potential action via `wasa:PropertyMap` instance.

```json
//...
    "wasa:precedingActionLink": [
      {
        "@id": "/api/rdf/actionlink/f37289fa-d8d1-4b0d-912a-de6e96da0836",
        "@type": "wasa:PrecedingActionLink",
        "wasa:source": {
          "@id": "/api/rdf/action/92552567-a10a-11ea-b5b6-3596ef396fa2"
        },
        "wasa:target": {
          "@id": "/api/rdf/action/100665a8-a0de-11ea-8c03-c14ba487f916"
        },
        "wasa:propertyMapping": [
          {
            "@type": "wasa:PropertyMap",
            "wasa:from": "<result>/<geo>/<latitude>",
            "wasa:to": "<object>/<contentLocation>/<geo>/<latitude>"
          },
          {
            "@type": "wasa:PropertyMap",
            "wasa:from": "<result>/<geo>/<longitude>",
            "wasa:to": "<object>/<contentLocation>/<geo>/<longitude>"
          }
        ]
      }
    ]

//...

```

# Grounding and Lifting

There are many Web APIs in the wild that are served over HTTP and follow REST architectural design to some extent. We provide a non-normative guideline for annotating these APIs with WASA. The annotation of existing Web APIs have two major components:

1. Mapping of WASA Requests (Active Actions) to an HTTP request (Grounding)
2. Mapping of responses of a Web API to WASA Responses (Completed or Failed Actions) (Lifting)

Below we describe these two processes and a possible way of implementing them with established mapping languages.

## Grounding (Request Mapping)

> _TODO_ will be done with an extended version of Xquery and Handlebars.

## Lifting (Response Mapping)

> _TODO_ RML example

> _TODO_ Function Ontology for describing functions


# Tools

There is a tool under development to support the creation of WASA APIs. It will be published on http://actions.semantify.it (currently has an older version and does not fully support WASA) soon. Until then, you can reach the [source code](https://github.com/semantifyit/api-actions) and try the development version on your own hardware. We also provide docker containers.

# Use Case: Dialog Generation from WASA APIs

> _TODO_ link to uimo

# Appendix 

## Abstract Syntax

TBD

## Domain Specification Operators for WASA

TBD

# Acknowledgement

# Publications