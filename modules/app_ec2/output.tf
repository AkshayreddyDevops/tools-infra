output "test" {
  value = aws_launch_template.ltemplate[*].name
}