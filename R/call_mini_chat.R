#' Call GPT-4o Mini Chat
#'
#' Uses the `ellmer::chat_openai()` interface to invoke a GPT-4o mini chat instance.
#' Optionally sets a system prompt before sending a user prompt.
#'
#' @param prompt A character string containing the user prompt to send.
#' @param system_prompt (Optional) A character string to use as the system prompt for the chat instance.
#'
#' @return A character string containing the response from the GPT-4o mini model.
#'
#' @examples
#' \dontrun{
#' call_mini_chat("What is the capital of France?")
#' call_mini_chat("Summarize this text.", system_prompt = "You are a helpful assistant.")
#' }
#' @export
call_mini_chat <- function(prompt, system_prompt = NA, .model = "gpt-4o-mini", .chat = ellmer::chat_openai) {
  chat <- .chat(model = .model, echo = FALSE)
  # Set the system prompt if provided
  if (!missing(system_prompt)) {
    chat$set_system_prompt(system_prompt)
  }
  response <- chat$chat(prompt)
  return(response)
}

#' Tool to Call GPT-4o Mini Chat via ellmer
#'
#' Registers `call_mini_chat()` as an ellmer tool to interact with the GPT-4o mini model.
#'
#' @export
tool_call_mini_chat <- ellmer::tool(
  call_mini_chat,
  "Calls an ellmer gpt-4o mini chat instance based on a given prompt.",
  prompt = ellmer::type_string(
    "The prompt to send to the mini chat instance.",
    required = TRUE
  ),
  system_prompt = ellmer::type_string(
    "An optional system prompt to set for the mini chat instance.",
    required = FALSE
  )
)
