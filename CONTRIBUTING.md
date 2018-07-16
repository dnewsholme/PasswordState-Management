# Contributing Principles

+ All functions must contain help comment blocks to allow for auto documenting.
+ All functions should use the get/set/remove/ passwordstate functions to hit the rest API only no direct connections.
+ All functions should have an assoicated pester test with mocked data so the tests can be run without touching passwordstate.
+ All returned items from a function should be an object.
+ All code must be agnostic enough that it will work against any passwordstate server.