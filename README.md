# Fighting Bad Database Apps

## Introduction

This repository contains the example used in the presentation [Fighting Bad Database Apps](https://www.salvis.com/blog/talks/). The examples require an [Oracle Database](https://www.oracle.com/database/technologies/free-downloads.html) 19c or newer with an installed [utPLSQL](https://github.com/utPLSQL/utPLSQL) framework v3.1.13 or newer.

## Demo App

The demo application in folder src/main contains a [PinkDB](https://www.salvis.com/blog/2018/07/18/the-pink-database-paradigm-pinkdb/) application based on Oracle's dept/emp example. In this folder the following Oracle Database users are managed:

| User | Description | Used in Production? |
| ---- | ----------- | ------------------- |
| `developer` | Personal user. Used for development. | No |
| `app_tester` | Technical user. Used by testing tools. | No |
| `app_connect` | Technical user. Used to by middle tier to connect. | Yes |
| `app` | Schema-only account. Owns the data and the API. Proxy connection allowed via `developer` and `app_tester`. | Yes |

To install the application run [install.sql](install.sql) when connected as an Oracle user with `dba` privileges (e.g. `sys`, `system`, `pdbadmin`). The script is [idempondent](https://en.wikipedia.org/wiki/Idempotence). 

## PinkDB and PoLP Tests

The folder src/test contains utPLSQL tests. In addition to the functional tests, there is a test suite named [test_pinkdb](src/test/app/package/test_pinkdb.pks) that validates the following features of a [PinkDB](https://www.salvis.com/blog/2018/07/18/the-pink-database-paradigm-pinkdb/) application:

| Feature | Test | Notes |
| ------- | ---- | ----- |
| 1. Connect user does not own database objects. | `connect_user_objects` | No exceptions. |
| 2. The connect user has access to API objects only. | `connect_user_privileges` | Only `CREATE SESSION` and `API_ROLE` allowed. |
| | `connect_direct_object_privs` | No directly granted objects allowed (access is granted via `API_ROLE`). |
| 3. The API consists of stored objects and views | api_role_object_privs | Tables are not part of the API and objects granted to `API_ROLE` must be owned by `APP`. |

In addition, the `app_schema_privileges` test verfies that the [Principle of Least Privileges (PoLP)](https://en.wikipedia.org/wiki/Principle_of_least_privilege) is followed for the `app` schema. The following privileges are allowed:

| Privilege               | Used in Production? | At Runtime? |
| ----------------------- | ------------------- | ----------- |
| `CREATE SESSION`        | Yes | No |
| `CREATE TABLE`          | Yes | No |
| `CREATE VIEW`           | Yes | No |
| `CREATE PROCEDURE`      | Yes | No |
| `CREATE PUBLIC SYNONYM` | Yes | No |
| `DROP PUBLIC SYNONYM`   | Yes | No |
| `SELECT ANY DICTIONARY` | No  | No |
| `DEBUG CONNECT SESSION` | No  | No |
| `DEBUG ANY PROCEDURE`   | No  | No |

Some privileges are required only in development and test environments. And all of them are required at install time only. This means after a successful installation of the application all privileges of the `app` schema can be revoked. This can be done with the [revoke_app_privs.sql](revoke_app_privs.sql) script.
