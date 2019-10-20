
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pvault

Create encrypted project vaults and easily store arbirtary R objects to
it.

## Installation

You can install the development version of pvault from github with:

``` r
remotes::install_github("GregorDeCillia/pvault")
```

## Using secrets locally

To initialize a project vault, use `create_vault()`

``` r
library(pvault)
create_vault()
#> ✔ saving vault in '.pvault/vault/'
#> ✔ saving rsa key in '.pvault/key.rds'
```

Secrets can be added and retrieved from the vault using `set_secret()`
and `get_secret()`.

``` r
set_secret(head(iris), id = "secret_table")
get_secret("secret_table")
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
```

Other functions can be used to list and delete secrets

``` r
set_secret(mtcars, id = "secret_cars")
list_secrets()
#> [1] "secret_cars"  "secret_table"
delete_secret("secret_cars")
list_secrets()
#> [1] "secret_table"
```

## How it works

`create_vault()` creates an empty directory `.pvault/vault` to store
secrets and an rsa keypair in `.pvault/key.rds` for encryption. All
secrets are encrypted and decrypted with the key in `.pvault/key.rds`.

Vaults are scoped to the current usethis project. See
`?usethis::proj_get`.

## Sharing vaults

In order to share a vault, lock it with `lock_vault()` and transfer the
contents of `.pvault`. As long as the vault is locked, no secrets can be
set or read.

``` r
lock_vault("vault_password")
#> ✔ Vault was successfully locked
get_secret("secret_table")
#> Error: The vault is locked. Please unlock with unlock_vault()
unlock_vault("wrong_password")
#> Error: OpenSSL error in EVP_DecryptFinal_ex: bad decrypt
get_secret("secret_table")
#> Error: The vault is locked. Please unlock with unlock_vault()
unlock_vault("vault_password")
#> ✔ Vaut was successfully unlocked
get_secret("secret_table")
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
```

## Cleanup

``` r
delete_vault()
#> ✔ Project vault was deleted
```
