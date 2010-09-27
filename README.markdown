# Temporaries

Set things temporarily and declaratively. Perfect for tests!

 * Set values of constants.
 * Set values of attributes.
 * Set values of hash keys.
 * Set values of instance variables.
 * Set values of class variables.
 * Set values of globals.
 * Set a temporary directory.

Do it for the length of a test, or within a specific block in your
code. Nest them arbitrarily; the innermost one applies.

## How

## In RSpec

    describe MyClass do
      # Set Mylib.foo will be 5 within these examples.
      use_temporary_attribute_value MyLib, :foo, 5

      describe MyClass do
        # In this nested example group, it will be 7.
        use_temporary_attribute_value MyLib, :foo, 7
      end
    end

  * Similarly of course for constants, hash keys, etc.

## In Test::Unit

    # Oh look, exactly the same as RSpec!
    class MyTest < Test::Unit::TestCase
      use_temporary_attribute_value MyLib, :foo, 5
    end

## Getting Deeper

You may also set the temporary for the duration of a particular block of code:

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

    with_temporary_directory path do
      # `tmp' refers to the directory.
    end

Or push and pop temporary values onto the stack yourself:

    push_hash_value hash, key, value
    pop_hash_value hash, key

    push_constant_value module, :constant, value
    pop_constant_value module, :constant

    # etc.

Naturally, you must keep them balancd.

## Contributing

 * Bug reports: http://github.com/oggy/temporaries/issues
 * Source: http://github.com/oggy/temporaries
 * Patches: Fork on Github, send pull request.
   * Ensure patch includes tests.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) 2010 George Ogata. See LICENSE for details.
