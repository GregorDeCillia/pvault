% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/encrypt.R
\name{secret}
\alias{secret}
\alias{set_secret}
\alias{list_secrets}
\alias{get_secret}
\alias{delete_secret}
\title{Manage secrets}
\usage{
set_secret(obj, id = NULL)

list_secrets()

get_secret(id)

delete_secret(id)
}
\arguments{
\item{obj}{An R object to save in the vault}

\item{id}{An identifier for the secret}
}
\description{
Get and retrieve from a vault
}
