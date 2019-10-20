#' Manage vaults
#'
#' Create and delete a vault for the current project
#' @name vault
#' @export
create_vault <- function() {
  vault <- proj_vault()
  if (fs::dir_exists(vault))
    return(usethis::ui_done("vault already exists"))
  fs::dir_create(vault)
  usethis::ui_done("saving vault in {usethis::ui_path(vault)}")
  key <- openssl::rsa_keygen()
  key_file <- proj_keyfile()
  saveRDS(key, key_file)
  usethis::ui_done("saving rsa key in {usethis::ui_path(key_file)}")
}

#' @export
#' @name vault
delete_vault <- function() {
  if (!fs::dir_exists(pvault_path()))
    usethis::ui_stop("The current project does not contain a project vault")
  fs::dir_delete(pvault_path())
  usethis::ui_done("Project vault was deleted")
}

pvault_path <- function(...) {
  usethis::proj_path(".pvault", ...)
}

proj_vault <- function() {
  pvault_path("vault")
}

secret_file <- function(id) {
  pvault_path("vault", id, ext = "rds")
}

proj_keyfile <- function() {
  pvault_path("key.rds")
}

proj_key <- function() {
  readRDS(proj_keyfile())
}

proj_pubkey <- function() {
  proj_key()$pubkey
}
