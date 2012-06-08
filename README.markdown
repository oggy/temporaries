# Temporaries

Set things temporarily and declaratively. Best way to test.

 * Set values of constants.
 * Set values of attributes.
 * Set values of hash keys.
 * Set values of instance variables.
 * Set values of class variables.
 * Set values of globals.
 * Set definitions of methods.
 * Set a temporary directory.

Do it for the length of a test, or within a specific block in your
code. Nest them arbitrarily; the innermost one applies.

## How

### In RSpec

    describe MyClass do
      # Mylib.foo will be 5 within these examples.
      use_attribute_value MyLib, :foo, 5

      describe MyClass do
        # In this nested example group, it will be 7.
        use_attribute_value MyLib, :foo, 7
      end
    end

Here's the full list of methods you can use:

    use_hash_value(hash, key, value)
    use_constant_value(module, :constant, value)
    use_attribute_value(object, :attribute, value)
    use_instance_variable_value(object, :name, value)
    use_class_variable_value(object, :name, value)
    use_global_value(:name, value)
    use_method_definition(module, :name, ->(*args){defintion})

Sigils in the `name` are unnecessary in the last 3 (unlike
`instance_variable_get`, for instance).

### In Test::Unit

    class MyTest < Test::Unit::TestCase
      use_attribute_value MyLib, :foo, 5
    end

## Digging Deeper

You may also set the temporary for the duration of a particular block:

    with_hash_value hash, key, value do
      ...
    end

    with_constant_value module, :constant, value do
      ...
    end

    with_attribute_value object, :attribute, value do
      ...
    end

    with_instance_variable_value object, :name, value do
      ...
    end

    with_class_variable_value object, :name, value do
      ...
    end

    with_global_value :name, value do
      ...
    end

    with_method_definition module, :name, ->(*args){definition} do
      ...
    end

    with_temporary_directory path do
      # `tmp' refers to the directory.
    end

Or push and pop temporary values onto the stack yourself:

    push_hash_value hash, key, value
    pop_hash_value hash, key

    push_constant_value module, :constant, value
    pop_constant_value module, :constant

    # etc.

Keep 'em balanced, maestro.

## Contributing

 * [Source](https://github.com/oggy/temporaries)
 * [Bug reports](https://github.com/oggy/temporaries/issues)
 * Patches: Fork on Github, send pull request.
   * Include tests where practical.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) George Ogata. See LICENSE for details.
