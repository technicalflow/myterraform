# My terraform learning files
## What Is Terraform?
Terraform is an open-source infrastructure as code software tool created by HashiCorp. Users define and provide data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally

## What Is HCL?

This low-level syntax of the Terraform language is defined in terms of a syntax called HCL, which is also used by configuration languages in other applications, and in particular other HashiCorp products. HCL was created to be human-readable and easier to work with instead of using JSON or YAML. HCL is a functional-based programming language

## Terraform Developer Concepts
- Immutable: Cannot be changed after a resource is created. Instead, it gets replaced/re-created.
- Mutable: Can be changed after a resource is created

## Terraform Terminology

### Programmatic Terminology
- Provider: Providers interact with sources (AWS, Azure, Cloudflare, etc.) at the programmatic level via API calls.
- Module: A folder that contains all of the Terraform resources that you're utilizing. For example, if you have a directory called *s3-bucket* and inside of it is a Terraform resource to create an S3 bucket, that would be a **Module**
- State: The `tfstate` is cached metadata about the configurations that are created/replaced/updated/delete in a Terraform module.
- Data Source: Return information on resources. For example, to return the metadata of an S3 bucket.
- Output Values: Values returned after creating resources via Terraform that can be used for other configurations or just as information.
 - Backend: Defines where and how operations are performed, where state snapshots are stored, etc.
 - Remote State: Store the state in a remote location (S3 bucket for example).

### Creating/Replacing/Updating/Deleted Terraform Resources
- Init: Initialize a Terraform module to be ready to create/replace/update/delete resources. `init` also downloads the Provider and stores it in the Terraform module.
- Plan: Determines what needs to be created/replaced/updated/deleted to move to the desired state.
- Apply: Creates/replaces/updates/deletes the resources via Terraform
- Destroy: Deletes the resources in the Terraform module
- Resources: A block of code to create/replace/update/delete services, servers, etc.. For example, an S3 bucket.

## Types

- string: Unicode characters representing some text, like "hi terraform" " "hi".
- number (like an `int`): a numeric value. The number type can represent both whole numbers like 15 or 54 and fractional values like 6.28.
- bool: Either true or false.
- list (`tuple`): a sequence of values, like ["us-west-1a", "us-west-1c"]. Elements in a list or tuple are identified by consecutive whole numbers, starting with zero.
- map (or object): a group of values identified by named labels, like {name = "Mabel", age = 52}.

## For Expressions/Loops

Different types of loops:
- `count`
- `for` expressions
- `for_each` meta argument

### For
For loops have a core functionality to transform type values. The expression after the `in` keyword can either be of type `list`, `map`, or it can be a `set` or an object.

The syntax isn't what you'd expect if you're used to general-purpose programming languages, but just think of anything after `:` as what's in your curly brackets (the actual logic and what's happening in the code)

```
list = ["test1", "test2", "test3"]

[for s in var.list : upper(s)]
```

You can also add `for` loops as `blocks`.
```
variable "users" {
  type = map(object({
    is_admin = boolean
  }))
}

locals {
  admin_users = {
    for name, user in var.users : name => user
    if user.is_admin
  }
  regular_users = {
    for name, user in var.users : name => user
    if !user.is_admin
  }
}
```

### For-Each
`for_each` feels a little bit more "human-readable" when it comes to looping.

Notice how to call the key and value in a `for_each` block; by using the `each` keyword.

```
resource "azurerm_resource_group" "rg" {
  for_each = {
    a_group = "eastus"
    another_group = "westus2"
  }
  name     = each.key
  location = each.value
}
```


## Conditionals/if statements

If you're used to programming with a general-purpose programming language, you'll probably notice how `if` statements in Terraform aren't exactly comparable. The logic is definitely there, but it's relatively watered down if you're used to `if/elif/else`

The logic is `CONDITION ? TRUEVAL : FALSEVAL`

The "desired/true" value is on the left and the "undesired/false" value is on the right.

```
${var.create_elastic_ip_address == true ? 1 : 0}
```
## Loops

A `for` loop creates a type value by transforming another type value. The verbiage is pretty much like:

"for `this thing` in `that thing` do something with the data

Example:
```
output "instances_by_availability_zone" {
  value = {
    for instance in aws_instance.example:
    instance.availability_zone => instance.id
  }
}
```

## Comparison/Conditionals (if statements)

A conditional expression (`if` statement in another languages) uses the value of a bool expression to select one of two values.

```
var.a != "" ? var.a : "default-a"
```

```
condition ? true_val : false_val
```

## Operators
Operators in Terraform are anything from "add these two values together" to "greater than, less than, or equal to". When thinking about operators, think mathematical operators.

Arithmetic operators in Terraform expect number values and in-turn ensures that the result is a number value

- a + b returns the result of adding a and b together.
- a - b returns the result of subtracting b from a.
- a * b returns the result of multiplying a and b.
- a / b returns the result of dividing a by b.
- a % b returns the remainder of dividing a by b. This operator is generally useful only when used with whole numbers.
- -a returns the result of multiplying a by -1.

The equality operators take two values of any type and produce boolean values as results.

- a == b returns true if a and b both have the same type and the same value, or false otherwise.
- a != b is the opposite of a == b.

The comparison operators expect number values and produce boolean values as results.

- a < b returns true if a is less than b, or false otherwise.
- a <= b returns true if a is less than or equal to b, or false otherwise.
- a > b returns true if a is greater than b, or false otherwise.
- a >= b returns true if a is greater than or equal to b, or false otherwise.

The logical operators expect bool values and produce bool values as results.

a || b returns true if either a or b is true, or false if both are false.
a && b returns true if both a and b are true, or false if either one is false.
!a returns true if a is false, and false if a is true.

## More Information
For more info, check out the following links:
- https://www.terraform.io/docs/language/expressions/operators.html
- https://www.terraform.io/docs/language/expressions/for.html
- https://www.terraform.io/docs/language/expressions/types.html
