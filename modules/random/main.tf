# Generate random text for naming resources
resource "random_id" "random_id" {
  byte_length = 6
}
