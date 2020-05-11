# PasswordState Management 

[![Build status](https://ci.appveyor.com/api/projects/status/uitb02g8iig9gbga?svg=true)](https://ci.appveyor.com/project/dnewsholme/passwordstate-management)
[![PowershellGallery](https://img.shields.io/powershellgallery/v/passwordstate-management.svg)](https://www.powershellgallery.com/packages/passwordstate-management)
[![GalleryVersion](https://img.shields.io/powershellgallery/dt/passwordstate-management.svg)](https://www.powershellgallery.com/packages/passwordstate-management)
![PowershellVersion](https://img.shields.io/powershellgallery/p/passwordstate-management.svg)

![PasswordState Logo](https://www.clickstudios.com.au/assets/images/laptop-1.png)

## Introduction

Contains various functions for the management of passwordstate via powershell.

## Requirements

| Requirement   | Version |
|---------------|---------|
| passwordstate | 8.0+    |
| Powershell    | 5.1+    |

Powershell Core 6.0 Compatible.

## How to use

First you will need to setup the environment for PasswordState using the function `Set-PasswordStateEnvironment`. This prevents you having to enter the api key all the time as it's stored in an encrypted format. Or you can use Windows authentication using the currently logged on user or a specific credential.

## Additional Info

* Functions all contain Pester tests ensuring that the code works.
* Full documentation is available under `.\docs`
