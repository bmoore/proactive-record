# proactive-record - Beyond Active Record

An ORM that defines your database models for you.

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

    var Proactive = require('proactive-record');

    Proactive.load('person', function(Person) {
        var p = new Person({
            name: 'Brian Moore',
            username: 'bmoore',
            email: 'moore.brian.d@gmail.com'
        });

        p.save();

        Person.find({name: "Brian Moore"}, function(p) {
            console.log(p)
            // { name: 'Brian Moore',
            //   username: 'bmoore',
            //   email: 'moore.brian.d@gmail.com'}
        });
    });


## Finder Methods

* Model.find(finder)
 * finder can be:
 * integer,
 * array of integers,
 * {column: value} objects
* Model.all() // TBD
* Model.exists(field, value) // TBD

## Other Methods
* .save() // Create and Update
* .delete() // Remove Record
* .children('address', function(addresses){}) // Access Child Table Records
* .parent('company', function(company){}) // Access Parent Table Record
