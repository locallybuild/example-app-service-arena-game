variable "prefix" {
  description = "The prefix used for all resources in this example"
  type        = string
}

variable "location" {
  description = "The Region where these resources should be deployed."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to all resources in this example."
  type        = map(string)
}
