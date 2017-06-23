# Introduction 
Collection of Powershell Scripts to help running and building Docker Containers

# Getting Started
## IIS
* Run build.ps1 once to build the Container
* .\run.ps1 [-RemoveWhenFinished] [-Port 80] -Path C:\wwwroot [-Name myiis_container]

### Defaults
* RemoveWhenFinished: False
* Port: 80
* Name: Auto-generated

## SQL Server
* .\run.ps1 [-RemoveWhenFinished] [-Password MyPassword] -DBPath C:\MyDatabases

### Defaults
* RemoveWhenFinished: False
* Password: P@ssw0rd