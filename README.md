# Fighting Bad Database Apps

## Introduction

This repository contains the example used in the presentation [Fighting Bad Database Apps](https://www.salvis.com/blog/talks/). The examples require an Oracle Database 19c or newer.

## Demo App

The demo application in folder src/main contains a PinkDB application with some issues. In this folder the following Oracle Database Users are managed:

| User | Description | Used in Production? |
| ---- | ----------- | ------------------- |
| `developer` | Personal user. Used for development. | No |
| `demoapp_test` | Technical user. Used by testing tools. | No |
| `demoapp_connect` | Technical user. Used to by middle tier to connect. | Yes |
| `demoapp_api` | Schema-only account. Owns the data and the API. Proxy connection allowed via `developer` and `tester`. | Yes |

For installation access to a `sysdba` user is required (e.g. `sys`).

```mermaid
C4Context
title Demo App
person(developer, "Application developer")
```

## PinkDB Tests

The folder src/test contains utPLSQL tests. These tests are no application specific. They are generic tests that can be applied to any PinkDB application. The tests need to be installed in the schema owning the API and the data. For the demo app that's `demoapp_api`.
