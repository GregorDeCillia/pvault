encrypt_robj <- function(obj, pubkey = openssl::my_pubkey()) {
  obj %>%
    serialize(NULL) %>%
    openssl::encrypt_envelope(pubkey = pubkey)
}

decrypt_robj <- function(cipher, key = openssl::my_key()) {
  openssl::decrypt_envelope(cipher$data, cipher$iv, cipher$session, key) %>%
    unserialize()
}

#' Manage secrets
#'
#' Get and retrieve from a vault
#' @param obj An R object to save in the vault
#' @param id An identifier for the secret
#' @name secret
#' @rdname secret
#' @export
set_secret <- function(obj, id = NULL) {
  check_unlocked()
  if (is.null(id))
    id <- deparse(substitute(obj))
  encrypt_robj(obj, pubkey = proj_pubkey()) %>%
    saveRDS(secret_file(id))
}

globalVariables(".")

#' @export
#' @rdname secret
list_secrets <- function() {
  proj_vault() %>%
    list.files() %>%
    gsub("\\.rds", "", .)
}

#' @export
#' @rdname secret
get_secret <- function(id) {
  stopifnot(is.character(id))
  check_unlocked()
  secret_file(id) %>%
    readRDS() %>%
    decrypt_robj(key = proj_key())
}

#' @export
#' @rdname secret
delete_secret <- function(id) {
  secret_file(id) %>%
    fs::file_delete()
}
