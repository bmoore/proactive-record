# proactive-record - Beyond Active Record

A tool that defines your database models for you.

## Features

* Works in node.js
* Supports PostgreSQL
* Extensible

## Installation

### node.js

Install using [npm](http://npmjs.org/):
    npm install proactive-record

## Examples

Assume you have a table with the following schema:

                                      Table "public.person"
      Column  |          Type          |                      Modifiers                      
    ----------+------------------------+-----------------------------------------------------
     id       | integer                | not null default nextval('person_id_seq'::regclass)
     name     | character varying(255) | not null
     username | character varying(255) | not null
     email    | character varying(255) | not null
    Indexes:
        "person_pkey" PRIMARY KEY, btree (id)


**MODELS**

    var Person = require('proactive-record').Person;

    var p = new Person({
        name: 'Brian Moore',
        username: 'bmoore',
        email: 'moore.brian.d@gmail.com'
    });

    p.save();

    var joe = Person.find_first('name', 'Joe Moore');
    console.log(joe);

    // { name: 'Joe Moore',
    //   username: 'jmoore',
    //   email: 'jmoore@mailinator.com' }

## Finder Methods

* Model.find(id)
* Model.first(field, value)
* Model.last(field, value)
* Model.all
* Model.exists(field, value)
* Model.find_some(ids)
* Model.find_first
* Model.find_last
