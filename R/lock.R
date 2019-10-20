#' @export
#' @param password A password to lock/unlock the vault
#' @rdname vault
lock_vault <- function(password) {
  readRDS(proj_keyfile()) %>%
    openssl::write_pem(pvault_path("id_rsa"), password)
  fs::file_delete(proj_keyfile())
  usethis::ui_done("Vault was successfully locked")
}

#' @export
#' @rdname vault
unlock_vault <- function(password) {
  openssl::read_key(pvault_path("id_rsa"), password) %>%
    saveRDS(proj_keyfile())
  fs::file_delete(pvault_path("id_rsa"))
  usethis::ui_done("Vaut was successfully unlocked")
}

is_locked <- function() {
  pvault_path("id_rsa") %>%
    fs::file_exists() %>%
    as.logical()
}

check_unlocked <- function() {
  if (is_locked())
    usethis::ui_stop(paste(
      "The vault is locked. Please unlock with unlock_vault()"
    ))
}
