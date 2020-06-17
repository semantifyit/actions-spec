# Introduction
The schema.org vocabulary is a de facto industrial standard for creating semantically annotated data. The vocabulary with its actions subset that allows to describe not only entities on the web, but also actions that can be taken on them. This specification puts schema.org actions into a web services perspective by restricting and extending it with the help of the [domain specification](#domain-specification) process for the annotation of HTTP APIs. 

?> _TODO_ add namespace


# Domain Specification

A domain specification is a process to create a domain specific pattern, which is an extended subset of schema.org. schema.org is a large vocabulary that covers several domains in a shallow way. To create a domain specific pattern, the domain specification process applies an operator on schema.org to remove the types and properties that are not relevant for the given domain, defines local properties on the remaining types and applies additional constraints on the ranges and values of remaining properties. The syntax of domain specification operator is a subset of [Shapes Constraint Language (SHACL)](https://www.w3.org/TR/shacl/). The semantics is _slightly_ [different](https://drive.google.com/file/d/1BmAikrlw8lRMZWrXT1sFfHZUEPruEbcy/view). 

![ds process](_media/ds-process.svg  ':class=figure' )

<center><span class="caption">The domain specification process.</span></center>


!> **_Relationship between SHACL and Domain Specifications_**: SHACL is a language that is built around the notion of *shape* in order to verify RDF graphs. A shape is either a node shape that applies constraints on nodes in an RDF graph, or a property shape that does the same to properties. In principle, we use SHACL as is, but we apply stricter syntax rules in terms of which constraint components can be applied on which type of shapes and how the shapes are interpreted (semantics). For instance, multiple target definitions are interpreted as disjunction in SHACL, but as a conjunction in domain specification approach.

?> _TODO_ add an example domain specification 


# Schema.org Actions

Schema.org contains an [Action](https://schema.org/Action) type to provide a mechanism to define actions that can be take on entities. In the context of schema.org, the actions are quite generic. For example, the [Action](https://schema.org/Action) type includes properties like **startTime** and **endTime** to describe the time span an action occurred or the **location** property to describe where the action took place. We restrict and extend the properties defined for the [Action](https://schema.org/Action) type and consequently its subtypes in order to make them more specific to a Web API annotation task.
The table below shows the properties of Action type we use for the Web API annotations (Italic properties and types indicate that they come from the semantify.it actions extension).

|    **Property**    |            **Range**            | **Description** |
|:--------------:|:---------------------------:|:-----------:|
|  actionStatus  |       ActionStatusType      |           Indicates the current disposition of the Action.  |
| _authentication_ | _AuthenticationSpecification_ |        A specification for different authentication methods.     |
|     object     |            Thing            |       The object upon which the action is carried out, whose state is kept intact or changed. Also known as the semantic roles patient, affected or undergoer (which change their state) or theme (which doesn't). e.g. John read a book.      |
|     result     |            Thing            |      The result produced in the action. e.g. John wrote a book.       |
|     target     |          EntryPoint         |      Indicates a target EntryPoint for an Action.       |
|      error     |            _Error_            |      An error specification.       |

## Input-Output Parameters

Schema.org actions provide a mechanism to define the input and output parameters of an action. In terms of syntax, this is merely an extension to the name of the property. According to the actions [documentation](https://schema.org/docs/actions.html), the parameter convention is as follows:


|**Property** | **Range** | **Description**|
|:---------:|:----------:|:---------:|
| &lt;property&gt;-input | PropertyValueSpecification | Indicates how a property should be filled in before initiating the action. |
| &lt;property&gt;-output | PropertyValueSpecification | Indicates how the field will be filled in when the action is completed. |

The PropertyValueSpecification type contains several properties that reflect the input attributes in HTML forms. These properties enable the description of the nature of input and output (Italic property indicates a property from the semantify.it actions extension).

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
 _valueList_ | [SHACL List](https://www.w3.org/TR/shacl/#dfn-shacl-list) | A list of possible values for the property.

?> The input and output properties on an Action support a syntactical shorthand. One can write `<property>-input: "required maxlength=100 name=q"` in order to specify a required input parameter named **q** with maximum length of 100 characters. See the [documentation](https://schema.org/docs/actions.html) for details.

## Potential Actions
The schema.org vocabulary defines a potentialAction property that enables the connection of actions on instances. Informally, the instance to which an potential action is connected is the object of that action. For a more formal definition for Web API annotation, see the [specification](#specification).

# Conceptualization

A schema.org action can have one of four statuses depending on its state. We map different stages of the client-API interaction to schema.org action statuses.

**Resource Description**: The description of an operation on a specific resource. This action is in **PotentialActionStatus**. 

?> See [Appendix](#appendix) for the domain specification operator that defines the Action pattern for resource descriptions.

**Request**: An action instance with all required parameters (and possible optional) parameters are filled. This action is in **ActiveActionStatus**.

**Response**: A (lifted) response from the server to a request. This action instance is in **CompletedActionStatus**.

# Specification

?> _TODO_ explanation about the examples

##  Web API

A resource description is an extended SHACL node shape. It consists of the following elements:
## API Documentation 

## Resource Description
 
## Resource Linking


In many cases, an operation on a resource of an API requires the response of another operation on another resource in the same or a different API. To support such cases, we allow linking of property shapes as the value of a property whose value needs to be retrieved from the result of another action. There are two ways to do this linking. 

The simplest way is when the entire result object is needed as an input. This can be accomplished by just linking a node shape. See the example below for an action to search bus stops.


## Lifting and Grounding

### Grounding (Request Mapping)

?> _TODO_ will be done with an extended version of Xquery and Handlebars.

### Lifting (Response Mapping)

RML example

?> _TODO_ Check the Function Ontology from imec Gent for describing functions.


# Tools

# Use Case: Dialog Generation from API Annotations

?> _TODO_ link to uimo

# Appendix 

## Abstract Syntax

TBD

## Domain Specification for Resource Description Annotations

TBD